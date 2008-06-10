From: akpm@linux-foundation.org
Subject: + kprobes-add-tests-for-register_kprobes.patch added to -mm tree
Date: Tue, 10 Jun 2008 15:03:55 -0700
Message-ID: <200806102203.m5AM3tk0031765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758937AbYFJWEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 18:04:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, jkenisto@us.ibm.com


The patch titled
     kprobes: add tests for register_kprobes
has been added to the -mm tree.  Its filename is
     kprobes-add-tests-for-register_kprobes.patch

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
Subject: kprobes: add tests for register_kprobes
From: Masami Hiramatsu <mhiramat@redhat.com>

Add testcases for *probe batch registration (register_kprobes) to kprobes
sanity tests.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tests/test_kprobes.c |  189 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 189 insertions(+)

diff -puN tests/test_kprobes.c~kprobes-add-tests-for-register_kprobes tests/test_kprobes.c
--- a/tests/test_kprobes.c~kprobes-add-tests-for-register_kprobes
+++ a/tests/test_kprobes.c
@@ -23,6 +23,7 @@
 static u32 rand1, preh_val, posth_val, jph_val;
 static int errors, handler_errors, num_tests;
 static u32 (*target)(u32 value);
+static u32 (*target2)(u32 value);
 
 static noinline u32 kprobe_target(u32 value)
 {
@@ -81,6 +82,84 @@ static int test_kprobe(void)
 	return 0;
 }
 
+static noinline u32 kprobe_target2(u32 value)
+{
+	return (value / div_factor) + 1;
+}
+
+static int kp_pre_handler2(struct kprobe *p, struct pt_regs *regs)
+{
+	preh_val = (rand1 / div_factor) + 1;
+	return 0;
+}
+
+static void kp_post_handler2(struct kprobe *p, struct pt_regs *regs,
+		unsigned long flags)
+{
+	if (preh_val != (rand1 / div_factor) + 1) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"incorrect value in post_handler2\n");
+	}
+	posth_val = preh_val + div_factor;
+}
+
+static struct kprobe kp2 = {
+	.symbol_name = "kprobe_target2",
+	.pre_handler = kp_pre_handler2,
+	.post_handler = kp_post_handler2
+};
+
+static int test_kprobes(void)
+{
+	int ret;
+	struct kprobe *kps[2] = {&kp, &kp2};
+
+	kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	ret = register_kprobes(kps, 2);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_kprobes returned %d\n", ret);
+		return ret;
+	}
+
+	preh_val = 0;
+	posth_val = 0;
+	ret = target(rand1);
+
+	if (preh_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kprobe pre_handler not called\n");
+		handler_errors++;
+	}
+
+	if (posth_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kprobe post_handler not called\n");
+		handler_errors++;
+	}
+
+	preh_val = 0;
+	posth_val = 0;
+	ret = target2(rand1);
+
+	if (preh_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kprobe pre_handler2 not called\n");
+		handler_errors++;
+	}
+
+	if (posth_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kprobe post_handler2 not called\n");
+		handler_errors++;
+	}
+
+	unregister_kprobes(kps, 2);
+	return 0;
+
+}
+
 static u32 j_kprobe_target(u32 value)
 {
 	if (value != rand1) {
@@ -121,6 +200,43 @@ static int test_jprobe(void)
 	return 0;
 }
 
+static struct jprobe jp2 = {
+	.entry          = j_kprobe_target,
+	.kp.symbol_name = "kprobe_target2"
+};
+
+static int test_jprobes(void)
+{
+	int ret;
+	struct jprobe *jps[2] = {&jp, &jp2};
+
+	jp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	ret = register_jprobes(jps, 2);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_jprobes returned %d\n", ret);
+		return ret;
+	}
+
+	jph_val = 0;
+	ret = target(rand1);
+	if (jph_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"jprobe handler not called\n");
+		handler_errors++;
+	}
+
+	jph_val = 0;
+	ret = target2(rand1);
+	if (jph_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"jprobe handler2 not called\n");
+		handler_errors++;
+	}
+	unregister_jprobes(jps, 2);
+
+	return 0;
+}
 #ifdef CONFIG_KRETPROBES
 static u32 krph_val;
 
@@ -176,6 +292,63 @@ static int test_kretprobe(void)
 
 	return 0;
 }
+
+static int return_handler2(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	unsigned long ret = regs_return_value(regs);
+
+	if (ret != (rand1 / div_factor) + 1) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"incorrect value in kretprobe handler2\n");
+	}
+	if (krph_val == 0) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"call to kretprobe entry handler failed\n");
+	}
+
+	krph_val = rand1;
+	return 0;
+}
+
+static struct kretprobe rp2 = {
+	.handler	= return_handler2,
+	.entry_handler  = entry_handler,
+	.kp.symbol_name = "kprobe_target2"
+};
+
+static int test_kretprobes(void)
+{
+	int ret;
+	struct kretprobe *rps[2] = {&rp, &rp2};
+
+	rp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	ret = register_kretprobes(rps, 2);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_kretprobe returned %d\n", ret);
+		return ret;
+	}
+
+	krph_val = 0;
+	ret = target(rand1);
+	if (krph_val != rand1) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kretprobe handler not called\n");
+		handler_errors++;
+	}
+
+	krph_val = 0;
+	ret = target2(rand1);
+	if (krph_val != rand1) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kretprobe handler2 not called\n");
+		handler_errors++;
+	}
+	unregister_kretprobes(rps, 2);
+	return 0;
+}
 #endif /* CONFIG_KRETPROBES */
 
 int init_test_probes(void)
@@ -183,6 +356,7 @@ int init_test_probes(void)
 	int ret;
 
 	target = kprobe_target;
+	target2 = kprobe_target2;
 
 	do {
 		rand1 = random32();
@@ -195,15 +369,30 @@ int init_test_probes(void)
 		errors++;
 
 	num_tests++;
+	ret = test_kprobes();
+	if (ret < 0)
+		errors++;
+
+	num_tests++;
 	ret = test_jprobe();
 	if (ret < 0)
 		errors++;
 
+	num_tests++;
+	ret = test_jprobes();
+	if (ret < 0)
+		errors++;
+
 #ifdef CONFIG_KRETPROBES
 	num_tests++;
 	ret = test_kretprobe();
 	if (ret < 0)
 		errors++;
+
+	num_tests++;
+	ret = test_kretprobes();
+	if (ret < 0)
+		errors++;
 #endif /* CONFIG_KRETPROBES */
 
 	if (errors)
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-improve-kretprobe-scalability-with-hashed-locking.patch
kprobes-remove-redundant-config-check.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
make-kprobe_blacklist-static.patch

