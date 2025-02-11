Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3586EC5
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 01:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739236553; cv=none; b=F1LC/q/KSblhVgDMasnV28Ra6xusakkZUkVRDVZcYK82zbaaqn9TfnMOlHfap2nYtB7rdvI2FTBNgzU7dUNJnoZAR0ukPvKuzkdqrlGY/BojeqFqcFMKCrK2dLr2QGKCP90eQvOyEYsSuCWlp6/xVUhqv6mfk+8ep4+gmC196Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739236553; c=relaxed/simple;
	bh=yGTUhx30fHFCtjCWv2XWeEpj7j+OQML2F8F1eq8aSuc=;
	h=Date:To:From:Subject:Message-Id; b=j1w1dawfJK5Dm1U10t+eTIcIyCP5hL8j7Xb0HPI+zjcP255JoYAt5hJ/E5XSBmpJ7eryEAqxc6N8RJtZRkqIQqZQSAwfu5HSU1z5H2rRg1LixSY4tZAdBsKXLHUuu5XYeCIli0SzoteMw1eWiEBLCWpDgr08iZ8pyWRHS1bNGXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VAktI2j/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VAktI2j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4007CC4CED1;
	Tue, 11 Feb 2025 01:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739236552;
	bh=yGTUhx30fHFCtjCWv2XWeEpj7j+OQML2F8F1eq8aSuc=;
	h=Date:To:From:Subject:From;
	b=VAktI2j/64dw0sg7b6v9l67zF7aeu/Xi0wvp0kOFm8cagcXCTjxHfj5niUYMRJkrP
	 SeQMaLtN6kSNwBtS9CQrQdY4r2B9q4Jt/C45y6q0YAnW886Hw+1130x9ncxOrOFovx
	 eH1zjIPaA/4XAuZWoCRGCklvJTYz8NHxb5B/m7P4=
Date: Mon, 10 Feb 2025 17:15:51 -0800
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,peterz@infradead.org,peterx@redhat.com,mingo@redhat.com,luto@kernel.org,jhubbard@nvidia.com,jgg@nvidia.com,jack@suse.cz,david@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-access_ok-call-from-gup_fast_fallback.patch added to mm-unstable branch
Message-Id: <20250211011552.4007CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove the access_ok() call from gup_fast_fallback().
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-access_ok-call-from-gup_fast_fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-access_ok-call-from-gup_fast_fallback.patch

This patch will later appear in the mm-unstable branch at
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
From: David Laight <david.laight.linux@gmail.com>
Subject: mm: remove the access_ok() call from gup_fast_fallback().
Date: Sun, 9 Feb 2025 17:47:11 +0000

Historiaclly the code relied on access_ok() to validate the address range.
Commit 26f4c328079d7 added an explicit wrap check before access_ok().
Commit c28b1fc70390d then changed the wrap test to use check_add_overflow().
Commit 6014bc27561f2 relaxed the checks in x86-64's access_ok() and added
  an explicit check for TASK_SIZE here to make up for it.
That left a pointless access_ok() call with its associated 'lfence' that
can never actually fail.

So just delete the test.

Link: https://lkml.kernel.org/r/20250209174711.60889-1-david.laight.linux@gmail.com
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/gup.c~mm-remove-the-access_ok-call-from-gup_fast_fallback
+++ a/mm/gup.c
@@ -2757,7 +2757,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  *
  *  *) ptes can be read atomically by the architecture.
  *
- *  *) access_ok is sufficient to validate userspace address ranges.
+ *  *) valid user addesses are below TASK_MAX_SIZE
  *
  * The last two assumptions can be relaxed by the addition of helper functions.
  *
@@ -3406,8 +3406,6 @@ static int gup_fast_fallback(unsigned lo
 		return -EOVERFLOW;
 	if (end > TASK_SIZE_MAX)
 		return -EFAULT;
-	if (unlikely(!access_ok((void __user *)start, len)))
-		return -EFAULT;
 
 	nr_pinned = gup_fast(start, end, gup_flags, pages);
 	if (nr_pinned == nr_pages || gup_flags & FOLL_FAST_ONLY)
_

Patches currently in -mm which might be from david.laight.linux@gmail.com are

mm-remove-the-access_ok-call-from-gup_fast_fallback.patch

