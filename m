Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20B434BA38
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 22:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760220258; cv=none; b=jgcE5t6tqPwFC/wfMREAPR0RZL1FUDY57ekJBzE/BXxJpGYv9yc7LynIkmAdYRf+DVfH3X8daDdbbTf3uJzEkxHNrcSt99xrNeC6t7wnerseXQ/0bePZk56/UQUxwf8pDhobd6vcDXEN/vtwouUfpB+c8v8IYnVDFkh2b3FZa3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760220258; c=relaxed/simple;
	bh=ui3kBCA9fN/rlUeKuJEpRSLD+W7sAoleyOJlbySTEYI=;
	h=Date:To:From:Subject:Message-Id; b=Fy4myqSAnFhpHKWNebs3tzcMtgfiGcSmRMjdWOiOsNZk8KGkkpy30nIEp85+ulqnZcVsQ5eUL37h+lCGRVASGL62RSoVvtbi49JXHvHN0IhjXofbvkld6g6qtJATU8o8SIqQ081D7eZ+VLqtZdBbmcMWnMPXKSBUuFJYKr6AerE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HU7ww0NC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HU7ww0NC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20643C4CEF4;
	Sat, 11 Oct 2025 22:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760220258;
	bh=ui3kBCA9fN/rlUeKuJEpRSLD+W7sAoleyOJlbySTEYI=;
	h=Date:To:From:Subject:From;
	b=HU7ww0NC1XG9R42OYdQzVhzzZST3nCgZ5MY2UlEMj08hd82UGsg5RlLS6KpjOnR8U
	 V4sWDdBuBFKFuaDyN5mxsWE9VpWmVdZMVNUYdlgfI46AjOW/Aj2fk2s5BxKh/XZSHO
	 5fJlfkkvgYvwOZBTUhfA6GPVG1cHfDB43jcRcOKg=
Date: Sat, 11 Oct 2025 15:04:17 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,lkp@intel.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,aaron.lu@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-do-not-choose-swap-device-according-to-numa-node-fix.patch added to mm-new branch
Message-Id: <20251011220418.20643C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-do-not-choose-swap-device-according-to-numa-node-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-do-not-choose-swap-device-according-to-numa-node-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-do-not-choose-swap-device-according-to-numa-node-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-do-not-choose-swap-device-according-to-numa-node-fix
Date: Sat Oct 11 02:57:29 PM PDT 2025

fix build issues

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510120456.vTSygUXV-lkp@intel.com/
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-do-not-choose-swap-device-according-to-numa-node-fix
+++ a/mm/swapfile.c
@@ -1388,11 +1388,10 @@ start_over:
 static bool swap_sync_discard(void)
 {
 	bool ret = false;
-	int nid = numa_node_id();
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
 			if (si->flags & SWP_PAGE_DISCARD)
@@ -2890,7 +2889,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	del_from_avail_list(p, true);
 	if (p->prio < 0) {
 		struct swap_info_struct *si = p;
-		int nid;
 
 		plist_for_each_entry_continue(si, &swap_active_head, list) {
 			si->prio++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-swap-do-not-choose-swap-device-according-to-numa-node-fix.patch

