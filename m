From: akpm@linux-foundation.org
Subject: [merged] kernel-add-panic_on_taint.patch removed from -mm
 tree
Date: Mon, 08 Jun 2020 15:31:38 -0700
Message-ID: <20200608223138.BalDQvs5h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgFHWbj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, bhe@redhat.com, bunk@kernel.org, cai@lca.pw, corbet@lwn.net, dyoung@redhat.com, gregkh@linuxfoundation.org, jeffm@suse.com, jikos@kernel.org, keescook@chromium.org, labbott@redhat.com, mcgrof@kernel.org, mm-commits@vger.kernel.org, rdunlap@infradead.org, tiwai@suse.de, tytso@mit.edu


The patch titled
     Subject: kernel: add panic_on_taint
has been removed from the -mm tree.  Its filename was
     kernel-add-panic_on_taint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: kernel: add panic_on_taint

Analogously to the introduction of panic_on_warn, this patch introduces a
kernel option named panic_on_taint in order to provide a simple and
generic way to stop execution and catch a coredump when the kernel gets
tainted by any given flag.

This is useful for debugging sessions as it avoids having to rebuild the
kernel to explicitly add calls to panic() into the code sites that
introduce the taint flags of interest.  For instance, if one is interested
in proceeding with a post-mortem analysis at the point a given code path
is hitting a bad page (i.e.  unaccount_page_cache_page(), or slab_bug()),
a coredump can be collected by rebooting the kernel with
'panic_on_taint=0x20' amended to the command line.

Another, perhaps less frequent, use for this option would be as a means
for assuring a security policy case where only a subset of taints, or no
single taint (in paranoid mode), is allowed for the running system.  The
optional switch 'nousertaint' is handy in this particular scenario, as it
will avoid userspace induced crashes by writes to sysctl interface
/proc/sys/kernel/tainted causing false positive hits for such policies.

[akpm@linux-foundation.org: tweak kernel-parameters.txt wording]
Link: http://lkml.kernel.org/r/20200515175502.146720-1-aquini@redhat.com
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Suggested-by: Qian Cai <cai@lca.pw>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst       |    8 +++
 Documentation/admin-guide/kernel-parameters.txt |   13 +++++
 Documentation/admin-guide/sysctl/kernel.rst     |    7 ++
 include/linux/kernel.h                          |    3 +
 kernel/panic.c                                  |   34 ++++++++++++++
 kernel/sysctl.c                                 |   11 ++++
 6 files changed, 75 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/kdump/kdump.rst~kernel-add-panic_on_taint
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -521,6 +521,14 @@ will cause a kdump to occur at the panic
 to specify this during runtime, /proc/sys/kernel/panic_on_warn can be set to 1
 to achieve the same behaviour.
 
+Trigger Kdump on add_taint()
+============================
+
+The kernel parameter panic_on_taint facilitates a conditional call to panic()
+from within add_taint() whenever the value set in this bitmask matches with the
+bit flag being set by add_taint().
+This will cause a kdump to occur at the add_taint()->panic() call.
+
 Contact
 =======
 
--- a/Documentation/admin-guide/kernel-parameters.txt~kernel-add-panic_on_taint
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3447,6 +3447,19 @@
 			bit 4: print ftrace buffer
 			bit 5: print all printk messages in buffer
 
+	panic_on_taint=	Bitmask for conditionally calling panic() in add_taint()
+			Format: <hex>[,nousertaint]
+			Hexadecimal bitmask representing the set of TAINT flags
+			that will cause the kernel to panic when add_taint() is
+			called with any of the flags in this set.
+			The optional switch "nousertaint" can be utilized to
+			prevent userspace forced crashes by writing to sysctl
+			/proc/sys/kernel/tainted any flagset matching with the
+			bitmask set on panic_on_taint.
+			See Documentation/admin-guide/tainted-kernels.rst for
+			extra details on the taint flags that users can pick
+			to compose the bitmask to assign to panic_on_taint.
+
 	panic_on_warn	panic() instead of WARN().  Useful to cause kdump
 			on a WARN().
 
--- a/Documentation/admin-guide/sysctl/kernel.rst~kernel-add-panic_on_taint
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -1239,6 +1239,13 @@ ORed together. The letters are seen in "
 
 See :doc:`/admin-guide/tainted-kernels` for more information.
 
+Note:
+  writes to this sysctl interface will fail with ``EINVAL`` if the kernel is
+  booted with the command line option ``panic_on_taint=<bitmask>,nousertaint``
+  and any of the ORed together values being written to ``tainted`` match with
+  the bitmask declared on panic_on_taint.
+  See :doc:`/admin-guide/kernel-parameters` for more details on that particular
+  kernel command line option and its optional ``nousertaint`` switch.
 
 threads-max
 ===========
--- a/include/linux/kernel.h~kernel-add-panic_on_taint
+++ a/include/linux/kernel.h
@@ -528,6 +528,8 @@ extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
 extern int panic_on_warn;
+extern unsigned long panic_on_taint;
+extern bool panic_on_taint_nousertaint;
 extern int sysctl_panic_on_rcu_stall;
 extern int sysctl_panic_on_stackoverflow;
 
@@ -596,6 +598,7 @@ extern enum system_states {
 #define TAINT_AUX			16
 #define TAINT_RANDSTRUCT		17
 #define TAINT_FLAGS_COUNT		18
+#define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
 
 struct taint_flag {
 	char c_true;	/* character printed when tainted */
--- a/kernel/panic.c~kernel-add-panic_on_taint
+++ a/kernel/panic.c
@@ -44,6 +44,8 @@ static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 bool crash_kexec_post_notifiers;
 int panic_on_warn __read_mostly;
+unsigned long panic_on_taint;
+bool panic_on_taint_nousertaint = false;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -434,6 +436,11 @@ void add_taint(unsigned flag, enum lockd
 		pr_warn("Disabling lock debugging due to kernel taint\n");
 
 	set_bit(flag, &tainted_mask);
+
+	if (tainted_mask & panic_on_taint) {
+		panic_on_taint = 0;
+		panic("panic_on_taint set ...");
+	}
 }
 EXPORT_SYMBOL(add_taint);
 
@@ -686,3 +693,30 @@ static int __init oops_setup(char *s)
 	return 0;
 }
 early_param("oops", oops_setup);
+
+static int __init panic_on_taint_setup(char *s)
+{
+	char *taint_str;
+
+	if (!s)
+		return -EINVAL;
+
+	taint_str = strsep(&s, ",");
+	if (kstrtoul(taint_str, 16, &panic_on_taint))
+		return -EINVAL;
+
+	/* make sure panic_on_taint doesn't hold out-of-range TAINT flags */
+	panic_on_taint &= TAINT_FLAGS_MAX;
+
+	if (!panic_on_taint)
+		return -EINVAL;
+
+	if (s && !strcmp(s, "nousertaint"))
+		panic_on_taint_nousertaint = true;
+
+	pr_info("panic_on_taint: bitmask=0x%lx nousertaint_mode=%sabled\n",
+		panic_on_taint, panic_on_taint_nousertaint ? "en" : "dis");
+
+	return 0;
+}
+early_param("panic_on_taint", panic_on_taint_setup);
--- a/kernel/sysctl.c~kernel-add-panic_on_taint
+++ a/kernel/sysctl.c
@@ -866,11 +866,20 @@ static int proc_taint(struct ctl_table *
 		return err;
 
 	if (write) {
+		int i;
+
+		/*
+		 * If we are relying on panic_on_taint not producing
+		 * false positives due to userspace input, bail out
+		 * before setting the requested taint flags.
+		 */
+		if (panic_on_taint_nousertaint && (tmptaint & panic_on_taint))
+			return -EINVAL;
+
 		/*
 		 * Poor man's atomic or. Not worth adding a primitive
 		 * to everyone's atomic.h for this
 		 */
-		int i;
 		for (i = 0; i < BITS_PER_LONG && tmptaint >> i; i++) {
 			if ((tmptaint >> i) & 1)
 				add_taint(i, LOCKDEP_STILL_OK);
_

Patches currently in -mm which might be from aquini@redhat.com are
