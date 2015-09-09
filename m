From: akpm@linux-foundation.org
Subject: [folded-merged] mmu-notifier-add-clear_young-callback-fix.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 15:05:20 -0700
Message-ID: <55f0ad20.X8DjIFa5Wep37XpM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbbIIWFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmu-notifier-add-clear_young-callback-fix
has been removed from the -mm tree.  Its filename was
     mmu-notifier-add-clear_young-callback-fix.patch

This patch was dropped because it was folded into mmu-notifier-add-clear_young-callback.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mmu-notifier-add-clear_young-callback-fix

Cc: Andres Lagar-Cavilla <andreslc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN virt/kvm/kvm_main.c~mmu-notifier-add-clear_young-callback-fix virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~mmu-notifier-add-clear_young-callback-fix
+++ a/virt/kvm/kvm_main.c
@@ -397,6 +397,19 @@ static int kvm_mmu_notifier_clear_young(
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
+	/*
+	 * Even though we do not flush TLB, this will still adversely
+	 * affect performance on pre-Haswell Intel EPT, where there is
+	 * no EPT Access Bit to clear so that we have to tear down EPT
+	 * tables instead. If we find this unacceptable, we can always
+	 * add a parameter to kvm_age_hva so that it effectively doesn't
+	 * do anything on clear_young.
+	 *
+	 * Also note that currently we never issue secondary TLB flushes
+	 * from clear_young, leaving this job up to the regular system
+	 * cadence. If we find this inaccurate, we might come up with a
+	 * more sophisticated heuristic later.
+	 */
 	young = kvm_age_hva(kvm, start, end);
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix.patch
proc-add-kpageidle-file-fix-2.patch
proc-add-kpageidle-file-fix-3.patch
proc-add-kpageidle-file-fix-4.patch
proc-add-kpageidle-file-fix-5.patch
proc-add-kpageidle-file-fix-6.patch
proc-add-kpageidle-file-fix-6-fix-2.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch

