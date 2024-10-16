Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F261B2193;
	Wed, 16 Oct 2024 21:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729115817; cv=none; b=eWg8MkEMU8R9sWp7KK0PzHXlXW2PKJhbfCJdjyqE50Y1g3qelB4f1FlPmPd3glXBfu9lmhoMqUQ2eqKrdiikGJmJb95hwaCdYAuyPWHRDkuwQUPPFCJ6yNUIwbv95ktlyIAO159GvfBqQsrMniNDYi0zg0FnQufBh3xBhpSUw5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729115817; c=relaxed/simple;
	bh=imJM00J/kQiyZJ1Q7WwvmA2krbMI5+jzDnCnq2xgjWw=;
	h=Date:To:From:Subject:Message-Id; b=JsL5nhEVCVT5oSEIXDapKDnxBOAh257AKgFYeD784CtzGqKH6+gSh0lR5PQWSm5cfgAdB138Gf5OW87tIUw3F8cTyBKrnayLnuRYgLh36SKgiulPGu7/PrDvWzSZE/kYFCvrd9fpVtSo5IPI02DRgmdgsSErRRcJq3OESUuORcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QkOPXSi1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QkOPXSi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF61C4CEC7;
	Wed, 16 Oct 2024 21:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729115816;
	bh=imJM00J/kQiyZJ1Q7WwvmA2krbMI5+jzDnCnq2xgjWw=;
	h=Date:To:From:Subject:From;
	b=QkOPXSi1i4L9W4GgMsW7F9uUL+A6Wc6duwR2sPZeW/uunP5UrQsCWkQOx4fRar6wn
	 zraxAUDzsVd1AhazYxT+8PgldQ9vHUJkesPshWG6WswCsbtkPdtehTt02gf5pzf0Ju
	 TwpKZucGxDkEdCzIn6vHwOMr3ehg4eDKFDBbZfIo=
Date: Wed, 16 Oct 2024 14:56:55 -0700
To: mm-commits@vger.kernel.org,syoshida@redhat.com,stable@vger.kernel.org,pasha.tatashin@soleen.com,minchan@kernel.org,jgg@nvidia.com,david@redhat.com,apopple@nvidia.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch added to mm-hotfixes-unstable branch
Message-Id: <20241016215656.6EF61C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: stop leaking pinned pages in low memory conditions
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: stop leaking pinned pages in low memory conditions
Date: Wed, 16 Oct 2024 13:22:42 -0700

If a driver tries to call any of the pin_user_pages*(FOLL_LONGTERM) family
of functions, and requests "too many" pages, then the call will
erroneously leave pages pinned.  This is visible in user space as an
actual memory leak.

Repro is trivial: just make enough pin_user_pages(FOLL_LONGTERM) calls to
exhaust memory.

The root cause of the problem is this sequence, within
__gup_longterm_locked():

    __get_user_pages_locked()
    rc = check_and_migrate_movable_pages()

...which gets retried in a loop.  The loop error handling is incomplete,
clearly due to a somewhat unusual and complicated tri-state error API. 
But anyway, if -ENOMEM, or in fact, any unexpected error is returned from
check_and_migrate_movable_pages(), then __gup_longterm_locked() happily
returns the error, while leaving the pages pinned.

In the failed case, which is an app that requests (via a device driver)
30720000000 bytes to be pinned, and then exits, I see this:

    $ grep foll /proc/vmstat
        nr_foll_pin_acquired 7502048
        nr_foll_pin_released 2048

And after applying this patch, it returns to balanced pins:

    $ grep foll /proc/vmstat
        nr_foll_pin_acquired 7502048
        nr_foll_pin_released 7502048

Fix this by unpinning the pages that __get_user_pages_locked() has
pinned, in such error cases.

Link: https://lkml.kernel.org/r/20241016202242.456953-1-jhubbard@nvidia.com
Fixes: 24a95998e9ba ("mm/gup.c: simplify and fix check_and_migrate_movable_pages() return codes")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Shigeru Yoshida <syoshida@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/gup.c~mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions
+++ a/mm/gup.c
@@ -2492,6 +2492,17 @@ static long __gup_longterm_locked(struct
 
 		/* FOLL_LONGTERM implies FOLL_PIN */
 		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages);
+
+		/*
+		 * The __get_user_pages_locked() call happens before we know
+		 * that whether it's possible to successfully complete the whole
+		 * operation. To compensate for this, if we get an unexpected
+		 * error (such as -ENOMEM) then we must unpin everything, before
+		 * erroring out.
+		 */
+		if (rc != -EAGAIN && rc != 0)
+			unpin_user_pages(pages, nr_pinned_pages);
+
 	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 	return rc ? rc : nr_pinned_pages;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions.patch
kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

