From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Tue, 29 Oct 2013 12:44:40 -0700
Message-ID: <52701028.71fyWLI3OpYUltC8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3J2Tol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Oct 2013 15:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 29 Oct 2013 12:44:39 -0700


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c                    |   20 ++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/htc.c |    8 ++++----
 2 files changed, 22 insertions(+), 6 deletions(-)

diff -puN arch/x86/mm/init.c~linux-next-rejects arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~linux-next-rejects
+++ a/arch/x86/mm/init.c
@@ -399,8 +399,24 @@ static unsigned long __init init_range_m
 	return mapped_ram_size;
 }
 
-/* (PUD_SHIFT-PMD_SHIFT)/2 */
-#define STEP_SIZE_SHIFT 5
+static unsigned long __init get_new_step_size(unsigned long step_size)
+{
+	/*
+	 * Explain why we shift by 5 and why we don't have to worry about
+	 * 'step_size << 5' overflowing:
+	 *
+	 * initial mapped size is PMD_SIZE (2M).
+	 * We can not set step_size to be PUD_SIZE (1G) yet.
+	 * In worse case, when we cross the 1G boundary, and
+	 * PG_LEVEL_2M is not set, we will need 1+1+512 pages (2M + 8k)
+	 * to map 1G range with PTE. Use 5 as shift for now.
+	 *
+	 * Don't need to worry about overflow, on 32bit, when step_size
+	 * is 0, round_down() returns 0 for start, and that turns it
+	 * into 0x100000000ULL.
+	 */
+	return step_size << 5;
+}
 
 /**
  * memory_map_top_down - Map [map_start, map_end) top down
diff -puN drivers/net/wireless/ath/ath10k/htc.c~linux-next-rejects drivers/net/wireless/ath/ath10k/htc.c
--- a/drivers/net/wireless/ath/ath10k/htc.c~linux-next-rejects
+++ a/drivers/net/wireless/ath/ath10k/htc.c
@@ -772,16 +772,16 @@ int ath10k_htc_connect_service(struct at
 
 	flags |= SM(tx_alloc, ATH10K_HTC_CONN_FLAGS_RECV_ALLOC);
 
-	req_msg = &msg->connect_service;
-	req_msg->flags = __cpu_to_le16(flags);
-	req_msg->service_id = __cpu_to_le16(conn_req->service_id);
-
 	/* Only enable credit flow control for WMI ctrl service */
 	if (conn_req->service_id != ATH10K_HTC_SVC_ID_WMI_CONTROL) {
 		flags |= ATH10K_HTC_CONN_FLAGS_DISABLE_CREDIT_FLOW_CTRL;
 		disable_credit_flow_ctrl = true;
 	}
 
+	req_msg = &msg->connect_service;
+	req_msg->flags = __cpu_to_le16(flags);
+	req_msg->service_id = __cpu_to_le16(conn_req->service_id);
+
 	reinit_completion(&htc->ctl_resp);
 
 	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

