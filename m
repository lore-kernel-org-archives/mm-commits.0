From: akpm@linux-foundation.org
Subject: + kprobes-indirectly-call-kprobe_target.patch added to -mm tree
Date: Tue, 10 Jun 2008 15:03:50 -0700
Message-ID: <200806102203.m5AM3oeW031760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059AbYFJWFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 18:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, jkenisto@us.ibm.com


The patch titled
     kprobes: indirectly call kprobe_target
has been added to the -mm tree.  Its filename is
     kprobes-indirectly-call-kprobe_target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 tests/test_kprobes.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN tests/test_kprobes.c~kprobes-indirectly-call-kprobe_target tests/test_kprobes.c
--- a/tests/test_kprobes.c~kprobes-indirectly-call-kprobe_target
+++ a/tests/test_kprobes.c
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

kprobes-improve-kretprobe-scalability-with-hashed-locking.patch
kprobes-remove-redundant-config-check.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
make-kprobe_blacklist-static.patch

