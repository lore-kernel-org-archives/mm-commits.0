Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A973729D19
	for <mm-commits@vger.kernel.org>; Sun,  8 Sep 2024 04:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725769465; cv=none; b=bQ08zsj3bfw+8lmzOleu+wC2cGuvcEw6Zj3GdZsIYKlB391f/PIvdMUaVazijnk0GWqCNJI8qHMrXaUNzx5zTP2VKdgc8oBgFQWqikZ3A0+R03iyr5SrdGsErZgfAwGf3NQkLLJRUHrHoSuxMTcXOIcqmbgX9qUVGxJo+LiZAFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725769465; c=relaxed/simple;
	bh=h+QvNp/NIn6HzjogXdNIDdR4o9VMRkdmddKM19bQIfM=;
	h=Date:To:From:Subject:Message-Id; b=FDyy8eonacKuj8Hi0ZcqPuqi/5qK/nJCTQXdoP5dfjd0IDlS7v99mi4C1b0p8i2v2hv/4OJcCG9xBxY7ZOGRChNHZBYgH7nIoUDflygoO9KhMInvxh2YVyxnJMz7znatRC3bb7kgyJZrdFzr/pCXc/BZK+9WgT9s3JKz8qP4AsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gCRZWb/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gCRZWb/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFC4C4CEC3;
	Sun,  8 Sep 2024 04:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725769465;
	bh=h+QvNp/NIn6HzjogXdNIDdR4o9VMRkdmddKM19bQIfM=;
	h=Date:To:From:Subject:From;
	b=gCRZWb/1UepMuVLTAEQQK+IBRsa1LP8ZEDOBwwGSbPKv0oTS1dqsxUUgvbkI5TsH3
	 fLxPYUDB+kX6NXLLO3zSjvwV1IccL4uQlDoU8emyKiJbUg/mFTzJUKK9y0Lw4z5F8g
	 Tvy79f7cfRyJ2OZq1dllV+27qLzevb+a9CUKgjvg=
Date: Sat, 07 Sep 2024 21:24:24 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-show_memc-report-alloc-tags-in-human-readable-units.patch added to mm-unstable branch
Message-Id: <20240908042425.1DFC4C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/show_mem.c: report alloc tags in human readable units
has been added to the -mm mm-unstable branch.  Its filename is
     mm-show_memc-report-alloc-tags-in-human-readable-units.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-show_memc-report-alloc-tags-in-human-readable-units.patch

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
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: mm/show_mem.c: report alloc tags in human readable units
Date: Thu, 5 Sep 2024 20:53:37 -0400

We already do this when reporting slab info - more consistent and more
readable.

Link: https://lkml.kernel.org/r/20240906005337.1220091-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/show_mem.c~mm-show_memc-report-alloc-tags-in-human-readable-units
+++ a/mm/show_mem.c
@@ -435,15 +435,18 @@ void __show_mem(unsigned int filter, nod
 				struct codetag *ct = tags[i].ct;
 				struct alloc_tag *tag = ct_to_alloc_tag(ct);
 				struct alloc_tag_counters counter = alloc_tag_read(tag);
+				char bytes[10];
+
+				string_get_size(counter.bytes, 1, STRING_UNITS_2, bytes, sizeof(bytes));
 
 				/* Same as alloc_tag_to_text() but w/o intermediate buffer */
 				if (ct->modname)
-					pr_notice("%12lli %8llu %s:%u [%s] func:%s\n",
-						  counter.bytes, counter.calls, ct->filename,
+					pr_notice("%12s %8llu %s:%u [%s] func:%s\n",
+						  bytes, counter.calls, ct->filename,
 						  ct->lineno, ct->modname, ct->function);
 				else
-					pr_notice("%12lli %8llu %s:%u func:%s\n",
-						  counter.bytes, counter.calls, ct->filename,
+					pr_notice("%12s %8llu %s:%u func:%s\n",
+						  bytes, counter.calls, ct->filename,
 						  ct->lineno, ct->function);
 			}
 		}
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

mm-fix-folio_alloc_noprof.patch
mm-show_memc-report-alloc-tags-in-human-readable-units.patch

