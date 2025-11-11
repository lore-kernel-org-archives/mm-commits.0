Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E420933D6F9;
	Tue, 11 Nov 2025 20:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762893964; cv=none; b=uUVbBtzePYX/EntNhROxTQPwRyvPPOSaLT3SRulrtzVr5gZ4SGgiX0CvABXUM+1K59GmzTP6J8BZZyBiMz+j5VXMNzPiHtlGwhiJclZpmRKB2uUgw4ugguDAYlawp2wEPH2l5067D5trU7IvoPl37DrqxFesvf0vWhUEHmem10Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762893964; c=relaxed/simple;
	bh=NIWTxMQS9jFvAervRzPIb4HAcewHjt9dt19VCk6IElU=;
	h=Date:To:From:Subject:Message-Id; b=GY09/d6bkcjqyV4vrXgzo7Grz499ITI0yLVSmkZpvixPNftb5Ecjn1au4MAuIqmiJmHJzlkjvb5QeCHBel+QUna/FdzOoi7zrXbQsozqp/KOSto3Oa6fwQMy1LBRNp9MEpkUj95DzXdAAmM0Qnhm2xfLG6Dlut/4E04LNtX6GaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MdZZoZF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MdZZoZF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B14C4CEF5;
	Tue, 11 Nov 2025 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762893963;
	bh=NIWTxMQS9jFvAervRzPIb4HAcewHjt9dt19VCk6IElU=;
	h=Date:To:From:Subject:From;
	b=MdZZoZF0141ew0S6GCvQn7Nk4EcHgi98pLGdsuE5NVmO0Efqjgx3fwNJ7J8HhZOwH
	 qREpoLlVkqSr+eO2IK+7SnhrlsNLqtxdO6UO8wjiw3geLVEdHcfFGPDWWmguOqhh4T
	 Z7fIxizOl9f2KPjlDa8VPgr6dsqtvH5K7LR+cwZY=
Date: Tue, 11 Nov 2025 12:46:02 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-potential-uaf-issue-for-vma-readahead.patch added to mm-hotfixes-unstable branch
Message-Id: <20251111204603.56B14C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: fix potential UAF issue for VMA readahead
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-fix-potential-uaf-issue-for-vma-readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-potential-uaf-issue-for-vma-readahead.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fix potential UAF issue for VMA readahead
Date: Tue, 11 Nov 2025 21:36:08 +0800

Since commit 78524b05f1a3 ("mm, swap: avoid redundant swap device
pinning"), the common helper for allocating and preparing a folio in the
swap cache layer no longer tries to get a swap device reference
internally, because all callers of __read_swap_cache_async are already
holding a swap entry reference.  The repeated swap device pinning isn't
needed on the same swap device.

Caller of VMA readahead is also holding a reference to the target entry's
swap device, but VMA readahead walks the page table, so it might encounter
swap entries from other devices, and call __read_swap_cache_async on
another device without holding a reference to it.

So it is possible to cause a UAF when swapoff of device A raced with
swapin on device B, and VMA readahead tries to read swap entries from
device A.  It's not easy to trigger, but in theory, it could cause real
issues.

Make VMA readahead try to get the device reference first if the swap
device is a different one from the target entry.

Link: https://lkml.kernel.org/r/20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com
Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/swap_state.c~mm-swap-fix-potential-uaf-issue-for-vma-readahead
+++ a/mm/swap_state.c
@@ -748,6 +748,8 @@ static struct folio *swap_vma_readahead(
 
 	blk_start_plug(&plug);
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
+		struct swap_info_struct *si = NULL;
+
 		if (!pte++) {
 			pte = pte_offset_map(vmf->pmd, addr);
 			if (!pte)
@@ -761,8 +763,19 @@ static struct folio *swap_vma_readahead(
 			continue;
 		pte_unmap(pte);
 		pte = NULL;
+		/*
+		 * Readahead entry may come from a device that we are not
+		 * holding a reference to, try to grab a reference, or skip.
+		 */
+		if (swp_type(entry) != swp_type(targ_entry)) {
+			si = get_swap_device(entry);
+			if (!si)
+				continue;
+		}
 		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
+		if (si)
+			put_swap_device(si);
 		if (!folio)
 			continue;
 		if (page_allocated) {
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-fix-potential-uaf-issue-for-vma-readahead.patch
mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch
mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch
revert-mm-swap-avoid-redundant-swap-device-pinning.patch

