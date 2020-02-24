From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 samples-hw_breakpoint-drop-use-of-kallsyms_lookup_name.patch added to -mm
 tree
Date: Mon, 24 Feb 2020 14:31:01 -0800
Message-ID: <20200224223101.-rRHDWmp3%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWbD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 17:31:03 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, frederic@kernel.org, gregkh@linuxfoundation.org, hch@lst.de, mhiramat@kernel.org, mm-commits@vger.kernel.org, prasad@linux.vnet.ibm.com, qperret@google.com, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: samples/hw_breakpoint: drop use of kallsyms_lookup_name()
has been added to the -mm tree.  Its filename is
     samples-hw_breakpoint-drop-use-of-kallsyms_lookup_name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/samples-hw_breakpoint-drop-use-of-kallsyms_lookup_name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/samples-hw_breakpoint-drop-use-of-kallsyms_lookup_name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
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

samples-hw_breakpoint-drop-hw_breakpoint_r-when-reporting-writes.patch
samples-hw_breakpoint-drop-use-of-kallsyms_lookup_name.patch
kallsyms-unexport-kallsyms_lookup_name-and-kallsyms_on_each_symbol.patch
