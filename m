Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3FF1802C6
	for <mm-commits@vger.kernel.org>; Thu, 18 Apr 2024 19:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469475; cv=none; b=o2xgj7LWug45ZeiZeyklRwzrj7GdVayzjanwN1OX48HHVPeXDAG6XbivQWh0Q3Snfsjy4QRgqDd1lYt9w93IC/yR+jCc+c9l2seUcluMxnaBGIdcOeFtRRH1ygdLIJfxiRulpYJr228gIWzpIawTt5ywaInVv6AQXG0miwcAurI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469475; c=relaxed/simple;
	bh=6DmsAFfSfICohmUE+VVzYhVXN8QLZ4+G4uPQ/MsCJ7w=;
	h=Date:To:From:Subject:Message-Id; b=tAB2sNUDiu3Wc07/W8uq4BZh+qFnouWTd3uWtYxeuzxQl1S2dLy+oX5tngtBgfa/yFN3dgUA5DvbeaWq398X1ZA726vErh5Tw66RODCIszEmFTyz/YQg9mGICdzKVLodaRxkADgxxIEP51oABVwXH+jfBr1/O40h4Yto121yPIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R7Z8MrrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R7Z8MrrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF790C113CC;
	Thu, 18 Apr 2024 19:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713469474;
	bh=6DmsAFfSfICohmUE+VVzYhVXN8QLZ4+G4uPQ/MsCJ7w=;
	h=Date:To:From:Subject:From;
	b=R7Z8MrrHFcXpo0mcqSna1LQzGXMFOlIyE+aFZlB0IgjaHez+ufFgtMopdcezXnTZ9
	 /3s2PX09L+MxX32SM8tjgNM6UUbDYjdJqiNtaydAYMLUUH/KgeYPF9ETb5UVcBD19z
	 ekXqFM4UB4/BrhO6bljOv0KkHRnm+E72OLyVRyV0=
Date: Thu, 18 Apr 2024 12:44:34 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch added to mm-unstable branch
Message-Id: <20240418194434.CF790C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swapfile: check usable swap device in __folio_throttle_swaprate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: swapfile: check usable swap device in __folio_throttle_swaprate()
Date: Thu, 18 Apr 2024 21:56:44 +0800

Skip blk_cgroup_congested() if there is no usable swap device since no
swapin/out will occur, Thereby avoid taking swap_lock.  The difference is
shown below from perf date of CoW pagefault,

 perf report -g -i perf.data.swapoff  | egrep "blk_cgroup_congested|__folio_throttle_swaprate"
     1.01%     0.16%  page_fault2_pro  [kernel.kallsyms]      [k] __folio_throttle_swaprate
     0.83%     0.80%  page_fault2_pro  [kernel.kallsyms]      [k] blk_cgroup_congested

 perf report -g -i perf.data.swapon   | egrep "blk_cgroup_congested|__folio_throttle_swaprate"
     0.15%     0.15%  page_fault2_pro  [kernel.kallsyms]      [k] __folio_throttle_swaprate

Link: https://lkml.kernel.org/r/20240418135644.2736748-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate
+++ a/mm/swapfile.c
@@ -2444,13 +2444,17 @@ static void reinsert_swap_info(struct sw
 	spin_unlock(&swap_lock);
 }
 
+static bool __has_usable_swap(void)
+{
+	return !plist_head_empty(&swap_active_head);
+}
+
 bool has_usable_swap(void)
 {
-	bool ret = true;
+	bool ret;
 
 	spin_lock(&swap_lock);
-	if (plist_head_empty(&swap_active_head))
-		ret = false;
+	ret = __has_usable_swap();
 	spin_unlock(&swap_lock);
 	return ret;
 }
@@ -3710,6 +3714,9 @@ void __folio_throttle_swaprate(struct fo
 	if (!(gfp & __GFP_IO))
 		return;
 
+	if (!__has_usable_swap())
+		return;
+
 	if (!blk_cgroup_congested())
 		return;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch
mm-remove-__set_page_dirty_nobuffers.patch
arm64-mm-cleanup-__do_page_fault.patch
arm64-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
powerpc-mm-accelerate-pagefault-when-badaccess.patch
riscv-mm-accelerate-pagefault-when-badaccess.patch
riscv-mm-accelerate-pagefault-when-badaccess-fix.patch
s390-mm-accelerate-pagefault-when-badaccess.patch
x86-mm-accelerate-pagefault-when-badaccess.patch
arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch

