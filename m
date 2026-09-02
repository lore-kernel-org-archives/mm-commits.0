Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285D838DC64;
	Wed,  2 Sep 2026 19:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788376693; cv=none; b=uEV8woNWv8GvmxOTKlfurUwE4LoKXgK+d5R2zyeRa6ejSl+uI8xawGtMx6VSSaLEpKHkL2AXRZNFc1MCjX9jjNliKPwR6IymgiZhCC5k1f3q4AXwGMFtUtAl10nbCIdWzGs6t6NlBqoW3AjEIFQA//ixkmBrlsvNgERi1QsyWws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788376693; c=relaxed/simple;
	bh=tUWAZg5rJssCok4Jzqfcoam18XtefVWpxelMN6Ec6E8=;
	h=Date:To:From:Subject:Message-Id; b=lqPxnV9/Rup7ZBtCPcLAIX5StDrL7PfEM3yEugmHstzHv3uYSKNt5+0CQ4+iwlm6BbME2fS++blxMVymCZTUGV1L6a7ZJcUrZVFpAZr01d0qUyhwBn5uIATMkdslV/Bek65gSvkHyRdrXwc+q20HIAtxhZX4Cz5Twviu15YL36Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CaDjMIzn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CaDjMIzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0735A1F000E9;
	Wed,  2 Sep 2026 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788376687;
	bh=jTmWdVY//G8EJgNSC4FOCmbrA0bLt0bYwl9tIeAmH7w=;
	h=Date:To:From:Subject;
	b=CaDjMIznm17CRbCRPJDb9tFH33xOgwlxaPLpC8JH8sGJPFl5WvDDbVN9iXW8QoCwn
	 wQPNGGs+vZHhLg6PrxIP5NNnNcQyT+oGun3cPYxCUd9xrTzoFeLjcCbfQrya0YwpLY
	 HkKEbhi/OsrQCj8uX6yskbFPvFfR0K/StAtrwgok=
Date: Wed, 02 Sep 2026 12:18:06 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,liam@infradead.org,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20260902191807.0735A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: correctly unaccount on mmap_prepare() failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: correctly unaccount on mmap_prepare() failure
Date: Wed, 02 Sep 2026 19:08:08 +0100

__mmap_setup() accounts memory for relevant mappings via:

security_vm_enough_memory_mm()
  -> __vm_enough_memory()
    -> vm_acct_memory()

If __mmap_setup() fails, this indicates that this accounting did not take
place, and thus it's appropriate for __mmap_region() to jump to
abort_munmap.

However if call_mmap_prepare() fails, it also jumps there and any accounted
memory is not correctly unaccounted.

Fix this by handling each error separately.

Link: https://lore.kernel.org/20260902-fix-unaccount-mmap_prepare-v1-1-ea070189fdfb@kernel.org
Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/vma.c~mm-vma-correctly-unaccount-on-mmap_prepare-failure
+++ a/mm/vma.c
@@ -2859,10 +2859,12 @@ static unsigned long __mmap_region(struc
 	map.check_ksm_early = can_set_ksm_flags_early(&map);
 
 	error = __mmap_setup(&map, &desc, uf);
-	if (!error && have_mmap_prepare)
-		error = call_mmap_prepare(&map, &desc);
 	if (error)
 		goto abort_munmap;
+	if (have_mmap_prepare)
+		error = call_mmap_prepare(&map, &desc);
+	if (error)
+		goto unacct_error;
 
 	if (map.check_ksm_early)
 		update_ksm_flags(&map);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch
mm-secretmem-properly-account-locked-pages.patch
mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch
mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch
mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch

