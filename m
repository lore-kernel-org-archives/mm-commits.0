From: akpm@linux-foundation.org
Subject: [merged]
 kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:18:49 -0800
Message-ID: <54e250a9.tgjO+LVqyHuEC6s8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbBPUTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:19:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangnan0@huawei.com, masami.hiramatsu.pt@hitachi.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: makes kprobes/enabled works correctly for optimized kprobes.
has been removed from the -mm tree.  Its filename was
     kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Nan <wangnan0@huawei.com>
Subject: kprobes: makes kprobes/enabled works correctly for optimized kprobes.

debugfs/kprobes/enabled doesn't work correctly on optimized kprobes. 
Masami Hiramatsu has a test report on x86_64 platform:

https://lkml.org/lkml/2015/1/19/274

This patch forces it to unoptimize kprobe if kprobes_all_disarmed is set. 
It also checks the flag in unregistering path for skipping unneeded
disarming process when kprobes globally disarmed.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN kernel/kprobes.c~kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-makes-kprobes-enabled-works-correctly-for-optimized-kprobes
+++ a/kernel/kprobes.c
@@ -869,7 +869,8 @@ static void __disarm_kprobe(struct kprob
 {
 	struct kprobe *_p;
 
-	unoptimize_kprobe(p, false);	/* Try to unoptimize */
+	/* Try to unoptimize */
+	unoptimize_kprobe(p, kprobes_all_disarmed);
 
 	if (!kprobe_queued(p)) {
 		arch_disarm_kprobe(p);
@@ -1571,7 +1572,13 @@ static struct kprobe *__disable_kprobe(s
 
 		/* Try to disarm and disable this/parent probe */
 		if (p == orig_p || aggr_kprobe_disabled(orig_p)) {
-			disarm_kprobe(orig_p, true);
+			/*
+			 * If kprobes_all_disarmed is set, orig_p
+			 * should have already been disarmed, so
+			 * skip unneed disarming process.
+			 */
+			if (!kprobes_all_disarmed)
+				disarm_kprobe(orig_p, true);
 			orig_p->flags |= KPROBE_FLAG_DISABLED;
 		}
 	}
_

Patches currently in -mm which might be from wangnan0@huawei.com are

origin.patch

