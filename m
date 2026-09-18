Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A39C282F3F;
	Fri, 18 Sep 2026 21:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789767811; cv=none; b=pPRMSrOa9TUCIr7o9/BaeV5V9MFtaZqIAnjdnUo5rjGaaT49RuTQXU5CrUYTtn4eM4SlHVIdUTSGHj5jH+nf0Fzx0g01IQcWSFd+Vl1phbmZQMbuXAh8sFgx3gyMZ88TBaTd3Zw4W7Y+j0YugZhjQOJ307+PRfAd/MfsES7NbYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789767811; c=relaxed/simple;
	bh=AsVtusUixwmmy3M9myCe+BR+NyMp1aRRF2NxWrafoK0=;
	h=Date:To:From:Subject:Message-Id; b=q3Uv86XWESQl01cIPEJdrwGUx22qmUxUOu68l005S+LBgf3In6+k0cBWBB9+3yyLZF5ih4+ConHFeFri5hpeQbmHBCK/KrvRaqbLurA+NoVDAfOgoQpMCRShRhmlz0v09jaaSX+F1p9FpwVsptnTs2SAqOGzjJd9kkfDX0t57TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s66FDOn7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s66FDOn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E87F1F000FF;
	Fri, 18 Sep 2026 21:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789767809;
	bh=eu0YRngYLFL7ctP+6nzbwFHIB9XI4Py7Z0Yh2iQNhGQ=;
	h=Date:To:From:Subject;
	b=s66FDOn7FwYLecjOvsCVhS41HiMhkbwDd7+KEhJgcLPXzTvyoJ1iI1I2rT1iUYBbJ
	 tfCAD4/5P81EGAkkYwEm2ChaJ9JWlRP/PJ/8ScYDeKxFQ51rC4RajlaR0AghaAgZh/
	 c3awjLg6OZz3imQCY4N/PbzBsh/npS9lFmSpvcc4=
Date: Fri, 18 Sep 2026 14:43:29 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check.patch added to mm-new branch
Message-Id: <20260918214329.9E87F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/alloc_tag: account for reserved tag ids in the kernel tag check
has been added to the -mm mm-new branch.  Its filename is
     mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: mm/alloc_tag: account for reserved tag ids in the kernel tag check
Date: Wed, 16 Sep 2026 15:55:57 +0800

The tag ids stored in the page flags include two reserved markers.
Id 0 means the page has no tag and id 1 means the tag was cleared,
so real tags start at CODETAG_ID_FIRST. The kernel-side check in
alloc_tag_sec_init() compared kernel_tags.count alone against the
addressable limit, so with the count at or just under the limit
the last tag ids wrapped into those markers. Pages allocated
through them then look the same as untagged pages on free, nothing
is ever subtracted from the real tag and /proc/allocinfo shows
that memory as still allocated.

Add the missing CODETAG_ID_FIRST, same as tags_addressable().

Link: https://lore.kernel.org/20260916075557.121316-1-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/alloc_tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/alloc_tag.c~mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check
+++ a/mm/alloc_tag.c
@@ -629,7 +629,7 @@ void __init alloc_tag_sec_init(void)
 	kernel_tags.count = last_codetag - kernel_tags.first_tag;
 
 	/* Check if kernel tags fit into page flags */
-	if (kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
+	if (CODETAG_ID_FIRST + kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
 		shutdown_mem_profiling(false); /* allocinfo file does not exist yet */
 		pr_err("%lu allocation tags cannot be references using %d available page flag bits. Memory allocation profiling is disabled!\n",
 			kernel_tags.count, NR_UNUSED_PAGEFLAG_BITS);
_

Patches currently in -mm which might be from hao.ge@linux.dev are

module-fix-lost-error-code-from-codetag_load_module.patch
alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled.patch
alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch
mm-alloc_tag-account-for-reserved-tag-ids-in-the-kernel-tag-check.patch

