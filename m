From: akpm@linux-foundation.org
Subject: [merged]
 samples-hw_breakpoint-drop-use-of-kallsyms_lookup_name.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 19:02:03 -0700
Message-ID: <20200408020203.aub5PqLhr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCCE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, frederic@kernel.org, gregkh@linuxfoundation.org, hch@lst.de, joe.lawrence@redhat.com, mbenes@suse.cz, mhiramat@kernel.org, mm-commits@vger.kernel.org, pmladek@suse.com, prasad@linux.vnet.ibm.com, qperret@google.com, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: samples/hw_breakpoint: drop use of kallsyms_lookup_name()
has been removed from the -mm tree.  Its filename was
     samples-hw_breakpoint-drop-use-of-kallsyms_lookup_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will@kernel.org>
Subject: samples/hw_breakpoint: drop use of kallsyms_lookup_name()

The 'data_breakpoint' test code is the only modular user of
kallsyms_lookup_name(), which was exported as part of fixing the test in
f60d24d2ad04 ("hw-breakpoints: Fix broken hw-breakpoint sample module").

In preparation for un-exporting this symbol, switch the test over to using
__symbol_get(), which can be used to place breakpoints on exported
symbols.

Link: http://lkml.kernel.org/r/20200221114404.14641-3-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Quentin Perret <qperret@google.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/hw_breakpoint/data_breakpoint.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/samples/hw_breakpoint/data_breakpoint.c~samples-hw_breakpoint-drop-use-of-kallsyms_lookup_name
+++ a/samples/hw_breakpoint/data_breakpoint.c
@@ -23,7 +23,7 @@
 
 struct perf_event * __percpu *sample_hbp;
 
-static char ksym_name[KSYM_NAME_LEN] = "pid_max";
+static char ksym_name[KSYM_NAME_LEN] = "jiffies";
 module_param_string(ksym, ksym_name, KSYM_NAME_LEN, S_IRUGO);
 MODULE_PARM_DESC(ksym, "Kernel symbol to monitor; this module will report any"
 			" write operations on the kernel symbol");
@@ -41,9 +41,13 @@ static int __init hw_break_module_init(v
 {
 	int ret;
 	struct perf_event_attr attr;
+	void *addr = __symbol_get(ksym_name);
+
+	if (!addr)
+		return -ENXIO;
 
 	hw_breakpoint_init(&attr);
-	attr.bp_addr = kallsyms_lookup_name(ksym_name);
+	attr.bp_addr = (unsigned long)addr;
 	attr.bp_len = HW_BREAKPOINT_LEN_4;
 	attr.bp_type = HW_BREAKPOINT_W;
 
@@ -66,6 +70,7 @@ fail:
 static void __exit hw_break_module_exit(void)
 {
 	unregister_wide_hw_breakpoint(sample_hbp);
+	symbol_put(ksym_name);
 	printk(KERN_INFO "HW Breakpoint for %s write uninstalled\n", ksym_name);
 }
 
_

Patches currently in -mm which might be from will@kernel.org are
