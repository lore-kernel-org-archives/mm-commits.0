Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA61F130495
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924927; cv=none; b=J8rJgiS+735dZQN71YF9dGrdQgALoA8x0+PTjqQEM3SPdfzsjtVfQ3r7hf4jzBcKV3QOLeQBCN4hCX/VxYXMLu0WhIlv5WeboGsS/1Tk+HpFgl5Mp5/gNtMnYM4db7vNLh5GzXVFFX8pQZMQlDgu0YhrRrVUi/J2Y8B4rp6IOvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924927; c=relaxed/simple;
	bh=p9V+y1u3DeDcabA69z6NWDZKGs/2wxP63QlWY6/hzGQ=;
	h=Date:To:From:Subject:Message-Id; b=R9a0JLmTuQGJFSFM1Wzoia1Olix7eIm11dB5Cgf5SihusmBFBbuA/xrMiT4BFLMuZ4STwX6gw9ueBvIQHaNgcBNWJ11I2Uj76oUEoCbtWbLGdJ20voziVkUGowxZcvMZTpWeVf+GdlFfu4sG3osDdOA+W/8eh7KcaVWQ32HBsXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jO2Jhoox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jO2Jhoox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC2AC4CEC5;
	Mon,  9 Sep 2024 23:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725924927;
	bh=p9V+y1u3DeDcabA69z6NWDZKGs/2wxP63QlWY6/hzGQ=;
	h=Date:To:From:Subject:From;
	b=jO2JhooxmBESJ8JvWcJ2BEjN8XUxTRiETTHppJodYG0izLQcgRiDZPcHULzO3MDdg
	 /YO0tiJOMeorUdHDegzZ3r0r4ezH/ltjf4Y6iWsIR1G2KTqZOmpbmEet7PfCjjlPRU
	 hRyg1j4SUuc1921kxVNW8wvNNH4qGZPQw+AJqMbE=
Date: Mon, 09 Sep 2024 16:35:27 -0700
To: mm-commits@vger.kernel.org,riel@surriel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20240909233527.ACC2AC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch

This patch was dropped because it was folded into mmtmpfs-consider-end-of-file-write-in-shmem_is_huge.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes
Date: Tue Sep  3 01:17:51 PM PDT 2024

ERROR: code indent should use tabs where possible
#215: FILE: mm/shmem.c:1676:
+^I^I       ^I^I^I^Ishmem_huge_force, vma, vm_flags);$

WARNING: please, no space before tabs
#215: FILE: mm/shmem.c:1676:
+^I^I       ^I^I^I^Ishmem_huge_force, vma, vm_flags);$

ERROR: code indent should use tabs where possible
#254: FILE: mm/shmem.c:2439:
+^I       ^Istruct folio **foliop, enum sgp_type sgp)$

WARNING: please, no space before tabs
#254: FILE: mm/shmem.c:2439:
+^I       ^Istruct folio **foliop, enum sgp_type sgp)$

total: 2 errors, 2 warnings, 263 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mmtmpfs-consider-end-of-file-write-in-shmem_is_huge.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes
+++ a/mm/shmem.c
@@ -1673,7 +1673,7 @@ unsigned long shmem_allowable_huge_order
 		return 0;
 
 	global_huge = shmem_huge_global_enabled(inode, index, write_end,
-		       				shmem_huge_force, vma, vm_flags);
+					shmem_huge_force, vma, vm_flags);
 	if (!vma || !vma_is_anon_shmem(vma)) {
 		/*
 		 * For tmpfs, we now only support PMD sized THP if huge page
@@ -2436,7 +2436,7 @@ unlock:
  * Return: 0 if successful, else a negative error code.
  */
 int shmem_get_folio(struct inode *inode, pgoff_t index, loff_t write_end,
-	       	struct folio **foliop, enum sgp_type sgp)
+		    struct folio **foliop, enum sgp_type sgp)
 {
 	return shmem_get_folio_gfp(inode, index, write_end, foliop, sgp,
 			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmtmpfs-consider-end-of-file-write-in-shmem_is_huge.patch
mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch
mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch

