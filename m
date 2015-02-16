From: akpm@linux-foundation.org
Subject: [merged]
 kprobes-set-kprobes_all_disarmed-earlier-to-enable-re-optimization.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:18:46 -0800
Message-ID: <54e250a6.IVZobBZItR58iFgf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbBPUTX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangnan0@huawei.com, masami.hiramatsu.pt@hitachi.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: set kprobes_all_disarmed earlier to enable re-optimization.
has been removed from the -mm tree.  Its filename was
     kprobes-set-kprobes_all_disarmed-earlier-to-enable-re-optimization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Nan <wangnan0@huawei.com>
Subject: kprobes: set kprobes_all_disarmed earlier to enable re-optimization.

In original code, the probed instruction doesn't get optimized after

echo 0 > /sys/kernel/debug/kprobes/enabled
echo 1 > /sys/kernel/debug/kprobes/enabled

This is because original code checks kprobes_all_disarmed in
optimize_kprobe(), but this flag is turned off after calling that
function.  Therefore, optimize_kprobe() will see kprobes_all_disarmed ==
true and doesn't do the optimization.

This patch simply turns off kprobes_all_disarmed earlier to enable
optimization.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/kprobes.c~kprobes-set-kprobes_all_disarmed-earlier-to-enable-re-optimization kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-set-kprobes_all_disarmed-earlier-to-enable-re-optimization
+++ a/kernel/kprobes.c
@@ -2320,6 +2320,12 @@ static void arm_all_kprobes(void)
 	if (!kprobes_all_disarmed)
 		goto already_enabled;
 
+	/*
+	 * optimize_kprobe() called by arm_kprobe() checks
+	 * kprobes_all_disarmed, so set kprobes_all_disarmed before
+	 * arm_kprobe.
+	 */
+	kprobes_all_disarmed = false;
 	/* Arming kprobes doesn't optimize kprobe itself */
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
@@ -2328,7 +2334,6 @@ static void arm_all_kprobes(void)
 				arm_kprobe(p);
 	}
 
-	kprobes_all_disarmed = false;
 	printk(KERN_INFO "Kprobes globally enabled\n");
 
 already_enabled:
_

Patches currently in -mm which might be from wangnan0@huawei.com are

origin.patch

