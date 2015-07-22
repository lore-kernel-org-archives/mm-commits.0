From: akpm@linux-foundation.org
Subject: + mmu-notifier-add-clear_young-callback-fix.patch added to -mm
 tree
Date: Wed, 22 Jul 2015 12:26:59 -0700
Message-ID: <55afee83.jil4KP9rK0e9o5ee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbGVT1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 15:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmu-notifier-add-clear_young-callback-fix
has been added to the -mm tree.  Its filename is
     mmu-notifier-add-clear_young-callback-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmu-notifier-add-clear_young-callback-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmu-notifier-add-clear_young-callback-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
mmu-notifier-add-clear_young-callback-fix.patch
proc-add-kpageidle-file.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-swap-zswap-maybe_preload-refactoring.patch

