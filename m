From: akpm@linux-foundation.org
Subject: [folded-merged]
 smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch removed from -mm tree
Date: Fri, 06 Jun 2014 14:06:24 -0700
Message-ID: <53922d50.nWro6pVmLPaIq9yj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaFFVG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:06:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com, rusty@rustcorp.com.au, rostedt@goodmis.org, rjw@rjwysocki.net, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, mgalbraith@suse.de, hch@infradead.org, fweisbec@gmail.com, ego@linux.vnet.ibm.com, bp@suse.de, akpm@linux-foundation.org

Subject: [folded-merged] smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,bp@suse.de,ego@linux.vnet.ibm.com,fweisbec@gmail.com,hch@infradead.org,mgalbraith@suse.de,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,rjw@rjwysocki.net,rostedt@goodmis.org,rusty@rustcorp.com.au,srivatsa.bhat@linux.vnet.ibm.com,tglx@linutronix.de,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:06:24 -0700


The patch titled
     Subject: smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix
has been removed from the -mm tree.  Its filename was
     smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch

This patch was dropped because it was folded into smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix

correctly suppress warning output on second and later occurrences

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Galbraith <mgalbraith@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN kernel/smp.c~smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix kernel/smp.c
--- a/kernel/smp.c~smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix
+++ a/kernel/smp.c
@@ -185,20 +185,17 @@ void generic_smp_call_function_single_in
 {
 	struct llist_node *entry;
 	struct call_single_data *csd, *csd_next;
-	int warn = 0;
-
-	/*
-	 * Shouldn't receive this interrupt on a cpu that is not yet online.
-	 */
-	if (unlikely(!cpu_online(smp_processor_id()))) {
-		warn = 1;
-		WARN_ON_ONCE(1);
-	}
+	static bool warned;
 
 	entry = llist_del_all(&__get_cpu_var(call_single_queue));
 	entry = llist_reverse_order(entry);
 
-	if (unlikely(warn)) {
+	/*
+	 * Shouldn't receive this interrupt on a cpu that is not yet online.
+	 */
+	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
+		warned = true;
+		WARN_ON(1);
 		/*
 		 * We don't have to use the _safe() variant here
 		 * because we are not invoking the IPI handlers yet.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
rtc-da9063-rtc-driver.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch

