From: akpm@linux-foundation.org
Subject: - kprobes-indirectly-call-kprobe_target.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:54 -0800
Message-ID: <200901072217.n07MHs6W017470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762289AbZAGWTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, jkenisto@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: indirectly call kprobe_target
has been removed from the -mm tree.  Its filename was
     kprobes-indirectly-call-kprobe_target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: indirectly call kprobe_target
From: Masami Hiramatsu <mhiramat@redhat.com>

Call kprobe_target indirectly.  This prevents gcc to unroll a noinline
function in caller function.

I ported patches which had been discussed on
http://sources.redhat.com/bugzilla/show_bug.cgi?id=3542

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/test_kprobes.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN kernel/test_kprobes.c~kprobes-indirectly-call-kprobe_target kernel/test_kprobes.c
--- a/kernel/test_kprobes.c~kprobes-indirectly-call-kprobe_target
+++ a/kernel/test_kprobes.c
@@ -22,21 +22,10 @@
 
 static u32 rand1, preh_val, posth_val, jph_val;
 static int errors, handler_errors, num_tests;
+static u32 (*target)(u32 value);
 
 static noinline u32 kprobe_target(u32 value)
 {
-	/*
-	 * gcc ignores noinline on some architectures unless we stuff
-	 * sufficient lard into the function. The get_kprobe() here is
-	 * just for that.
-	 *
-	 * NOTE: We aren't concerned about the correctness of get_kprobe()
-	 * here; hence, this call is neither under !preempt nor with the
-	 * kprobe_mutex held. This is fine(tm)
-	 */
-	if (get_kprobe((void *)0xdeadbeef))
-		printk(KERN_INFO "Kprobe smoke test: probe on 0xdeadbeef!\n");
-
 	return (value / div_factor);
 }
 
@@ -74,7 +63,7 @@ static int test_kprobe(void)
 		return ret;
 	}
 
-	ret = kprobe_target(rand1);
+	ret = target(rand1);
 	unregister_kprobe(&kp);
 
 	if (preh_val == 0) {
@@ -121,7 +110,7 @@ static int test_jprobe(void)
 		return ret;
 	}
 
-	ret = kprobe_target(rand1);
+	ret = target(rand1);
 	unregister_jprobe(&jp);
 	if (jph_val == 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
@@ -177,7 +166,7 @@ static int test_kretprobe(void)
 		return ret;
 	}
 
-	ret = kprobe_target(rand1);
+	ret = target(rand1);
 	unregister_kretprobe(&rp);
 	if (krph_val != rand1) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
@@ -193,6 +182,8 @@ int init_test_probes(void)
 {
 	int ret;
 
+	target = kprobe_target;
+
 	do {
 		rand1 = random32();
 	} while (rand1 <= div_factor);
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch

