From: akpm@linux-foundation.org
Subject: - kprobes-fix-error-checking-of-batch-registration.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:24 -0700
Message-ID: <200806160603.m5G63OMa010593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbYFPGEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, jkenisto@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: fix error checking of batch registration
has been removed from the -mm tree.  Its filename was
     kprobes-fix-error-checking-of-batch-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: fix error checking of batch registration
From: Masami Hiramatsu <mhiramat@redhat.com>

Fix error checking routine to catch an error which occurs in first
__register_*probe().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN kernel/kprobes.c~kprobes-fix-error-checking-of-batch-registration kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-fix-error-checking-of-batch-registration
+++ a/kernel/kprobes.c
@@ -699,8 +699,9 @@ static int __register_kprobes(struct kpr
 		return -EINVAL;
 	for (i = 0; i < num; i++) {
 		ret = __register_kprobe(kps[i], called_from);
-		if (ret < 0 && i > 0) {
-			unregister_kprobes(kps, i);
+		if (ret < 0) {
+			if (i > 0)
+				unregister_kprobes(kps, i);
 			break;
 		}
 	}
@@ -776,8 +777,9 @@ static int __register_jprobes(struct jpr
 			jp->kp.break_handler = longjmp_break_handler;
 			ret = __register_kprobe(&jp->kp, called_from);
 		}
-		if (ret < 0 && i > 0) {
-			unregister_jprobes(jps, i);
+		if (ret < 0) {
+			if (i > 0)
+				unregister_jprobes(jps, i);
 			break;
 		}
 	}
@@ -920,8 +922,9 @@ static int __register_kretprobes(struct 
 		return -EINVAL;
 	for (i = 0; i < num; i++) {
 		ret = __register_kretprobe(rps[i], called_from);
-		if (ret < 0 && i > 0) {
-			unregister_kretprobes(rps, i);
+		if (ret < 0) {
+			if (i > 0)
+				unregister_kretprobes(rps, i);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
kprobes-improve-kretprobe-scalability-with-hashed-locking.patch
kprobes-remove-redundant-config-check.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
make-kprobe_blacklist-static.patch

