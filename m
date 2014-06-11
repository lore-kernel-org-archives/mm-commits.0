From: akpm@linux-foundation.org
Subject: + kernel-test_kprobesc-use-current-logging-functions.patch added
 to -mm tree
Date: Wed, 11 Jun 2014 15:42:45 -0700
Message-ID: <5398db65.hmGuk0NUFGBh/SmA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaFKWmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 18:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, masami.hiramatsu.pt@hitachi.com, davem@davemloft.net, anil.s.keshavamurthy@intel.com, ananth@in.ibm.com, fabf@skynet.be

Subject: + kernel-test_kprobesc-use-current-logging-functions.patch added to -mm tree
To: fabf@skynet.be,ananth@in.ibm.com,anil.s.keshavamurthy@intel.com,davem@davemloft.net,masami.hiramatsu.pt@hitachi.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 15:42:45 -0700


The patch titled
     Subject: kernel/test_kprobes.c: use current logging functions
has been added to the -mm tree.  Its filename is
     kernel-test_kprobesc-use-current-logging-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-test_kprobesc-use-current-logging-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-test_kprobesc-use-current-logging-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/test_kprobes.c: use current logging functions

- Add pr_fmt
- Coalesce formats
- Use current pr_foo() functions instead of printk
- Remove unnecessary "failed" display (already in log level).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/test_kprobes.c |   87 ++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 56 deletions(-)

diff -puN kernel/test_kprobes.c~kernel-test_kprobesc-use-current-logging-functions kernel/test_kprobes.c
--- a/kernel/test_kprobes.c~kernel-test_kprobesc-use-current-logging-functions
+++ a/kernel/test_kprobes.c
@@ -14,6 +14,8 @@
  * the GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) "Kprobe smoke test: " fmt
+
 #include <linux/kernel.h>
 #include <linux/kprobes.h>
 #include <linux/random.h>
@@ -41,8 +43,7 @@ static void kp_post_handler(struct kprob
 {
 	if (preh_val != (rand1 / div_factor)) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in post_handler\n");
+		pr_err("incorrect value in post_handler\n");
 	}
 	posth_val = preh_val + div_factor;
 }
@@ -59,8 +60,7 @@ static int test_kprobe(void)
 
 	ret = register_kprobe(&kp);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_kprobe returned %d\n", ret);
+		pr_err("register_kprobe returned %d\n", ret);
 		return ret;
 	}
 
@@ -68,14 +68,12 @@ static int test_kprobe(void)
 	unregister_kprobe(&kp);
 
 	if (preh_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe pre_handler not called\n");
+		pr_err("kprobe pre_handler not called\n");
 		handler_errors++;
 	}
 
 	if (posth_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe post_handler not called\n");
+		pr_err("kprobe post_handler not called\n");
 		handler_errors++;
 	}
 
@@ -98,8 +96,7 @@ static void kp_post_handler2(struct kpro
 {
 	if (preh_val != (rand1 / div_factor) + 1) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in post_handler2\n");
+		pr_err("incorrect value in post_handler2\n");
 	}
 	posth_val = preh_val + div_factor;
 }
@@ -120,8 +117,7 @@ static int test_kprobes(void)
 	kp.flags = 0;
 	ret = register_kprobes(kps, 2);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_kprobes returned %d\n", ret);
+		pr_err("register_kprobes returned %d\n", ret);
 		return ret;
 	}
 
@@ -130,14 +126,12 @@ static int test_kprobes(void)
 	ret = target(rand1);
 
 	if (preh_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe pre_handler not called\n");
+		pr_err("kprobe pre_handler not called\n");
 		handler_errors++;
 	}
 
 	if (posth_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe post_handler not called\n");
+		pr_err("kprobe post_handler not called\n");
 		handler_errors++;
 	}
 
@@ -146,14 +140,12 @@ static int test_kprobes(void)
 	ret = target2(rand1);
 
 	if (preh_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe pre_handler2 not called\n");
+		pr_err("kprobe pre_handler2 not called\n");
 		handler_errors++;
 	}
 
 	if (posth_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kprobe post_handler2 not called\n");
+		pr_err("kprobe post_handler2 not called\n");
 		handler_errors++;
 	}
 
@@ -166,8 +158,7 @@ static u32 j_kprobe_target(u32 value)
 {
 	if (value != rand1) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in jprobe handler\n");
+		pr_err("incorrect value in jprobe handler\n");
 	}
 
 	jph_val = rand1;
@@ -186,16 +177,14 @@ static int test_jprobe(void)
 
 	ret = register_jprobe(&jp);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_jprobe returned %d\n", ret);
+		pr_err("register_jprobe returned %d\n", ret);
 		return ret;
 	}
 
 	ret = target(rand1);
 	unregister_jprobe(&jp);
 	if (jph_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"jprobe handler not called\n");
+		pr_err("jprobe handler not called\n");
 		handler_errors++;
 	}
 
@@ -217,24 +206,21 @@ static int test_jprobes(void)
 	jp.kp.flags = 0;
 	ret = register_jprobes(jps, 2);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_jprobes returned %d\n", ret);
+		pr_err("register_jprobes returned %d\n", ret);
 		return ret;
 	}
 
 	jph_val = 0;
 	ret = target(rand1);
 	if (jph_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"jprobe handler not called\n");
+		pr_err("jprobe handler not called\n");
 		handler_errors++;
 	}
 
 	jph_val = 0;
 	ret = target2(rand1);
 	if (jph_val == 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"jprobe handler2 not called\n");
+		pr_err("jprobe handler2 not called\n");
 		handler_errors++;
 	}
 	unregister_jprobes(jps, 2);
@@ -256,13 +242,11 @@ static int return_handler(struct kretpro
 
 	if (ret != (rand1 / div_factor)) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in kretprobe handler\n");
+		pr_err("incorrect value in kretprobe handler\n");
 	}
 	if (krph_val == 0) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"call to kretprobe entry handler failed\n");
+		pr_err("call to kretprobe entry handler failed\n");
 	}
 
 	krph_val = rand1;
@@ -281,16 +265,14 @@ static int test_kretprobe(void)
 
 	ret = register_kretprobe(&rp);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_kretprobe returned %d\n", ret);
+		pr_err("register_kretprobe returned %d\n", ret);
 		return ret;
 	}
 
 	ret = target(rand1);
 	unregister_kretprobe(&rp);
 	if (krph_val != rand1) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kretprobe handler not called\n");
+		pr_err("kretprobe handler not called\n");
 		handler_errors++;
 	}
 
@@ -303,13 +285,11 @@ static int return_handler2(struct kretpr
 
 	if (ret != (rand1 / div_factor) + 1) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"incorrect value in kretprobe handler2\n");
+		pr_err("incorrect value in kretprobe handler2\n");
 	}
 	if (krph_val == 0) {
 		handler_errors++;
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"call to kretprobe entry handler failed\n");
+		pr_err("call to kretprobe entry handler failed\n");
 	}
 
 	krph_val = rand1;
@@ -332,24 +312,21 @@ static int test_kretprobes(void)
 	rp.kp.flags = 0;
 	ret = register_kretprobes(rps, 2);
 	if (ret < 0) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"register_kretprobe returned %d\n", ret);
+		pr_err("register_kretprobe returned %d\n", ret);
 		return ret;
 	}
 
 	krph_val = 0;
 	ret = target(rand1);
 	if (krph_val != rand1) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kretprobe handler not called\n");
+		pr_err("kretprobe handler not called\n");
 		handler_errors++;
 	}
 
 	krph_val = 0;
 	ret = target2(rand1);
 	if (krph_val != rand1) {
-		printk(KERN_ERR "Kprobe smoke test failed: "
-				"kretprobe handler2 not called\n");
+		pr_err("kretprobe handler2 not called\n");
 		handler_errors++;
 	}
 	unregister_kretprobes(rps, 2);
@@ -368,7 +345,7 @@ int init_test_probes(void)
 		rand1 = prandom_u32();
 	} while (rand1 <= div_factor);
 
-	printk(KERN_INFO "Kprobe smoke test started\n");
+	pr_info("started\n");
 	num_tests++;
 	ret = test_kprobe();
 	if (ret < 0)
@@ -402,13 +379,11 @@ int init_test_probes(void)
 #endif /* CONFIG_KRETPROBES */
 
 	if (errors)
-		printk(KERN_ERR "BUG: Kprobe smoke test: %d out of "
-				"%d tests failed\n", errors, num_tests);
+		pr_err("BUG: %d out of %d tests failed\n", errors, num_tests);
 	else if (handler_errors)
-		printk(KERN_ERR "BUG: Kprobe smoke test: %d error(s) "
-				"running handlers\n", handler_errors);
+		pr_err("BUG: %d error(s) running handlers\n", handler_errors);
 	else
-		printk(KERN_INFO "Kprobe smoke test passed successfully\n");
+		pr_info("passed successfully\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

