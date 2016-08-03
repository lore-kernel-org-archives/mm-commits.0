From: akpm@linux-foundation.org
Subject: [merged] add-a-kexec_crash_loaded-function.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:14:01 -0700
Message-ID: <57a23469./O9x0kSJ+LFTwP8+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073AbcHCSOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:14:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ptesarik@suse.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, jgross@suse.com, josh@joshtriplett.org, mingo@redhat.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: add a kexec_crash_loaded() function
has been removed from the -mm tree.  Its filename was
     add-a-kexec_crash_loaded-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.com>
Subject: kexec: add a kexec_crash_loaded() function

Provide a wrapper function to be used by kernel code to check whether a
crash kernel is loaded.  It returns the same value that can be seen in
/sys/kernel/kexec_crash_loaded by userspace programs.

I'm exporting the function, because it will be used by Xen, and it is
possible to compile Xen modules separately to enable the use of PV drivers
with unmodified bare-metal kernels.

Link: http://lkml.kernel.org/r/20160713121955.14969.69080.stgit@hananiah.suse.cz
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    2 ++
 kernel/kexec_core.c   |    6 ++++++
 kernel/ksysfs.c       |    2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff -puN include/linux/kexec.h~add-a-kexec_crash_loaded-function include/linux/kexec.h
--- a/include/linux/kexec.h~add-a-kexec_crash_loaded-function
+++ a/include/linux/kexec.h
@@ -230,6 +230,7 @@ extern void *kexec_purgatory_get_symbol_
 extern void __crash_kexec(struct pt_regs *);
 extern void crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
+int kexec_crash_loaded(void);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
 void crash_save_vmcoreinfo(void);
 void arch_crash_save_vmcoreinfo(void);
@@ -364,6 +365,7 @@ struct task_struct;
 static inline void __crash_kexec(struct pt_regs *regs) { }
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
+static inline int kexec_crash_loaded(void) { return 0; }
 #define kexec_in_progress false
 #endif /* CONFIG_KEXEC_CORE */
 
diff -puN kernel/kexec_core.c~add-a-kexec_crash_loaded-function kernel/kexec_core.c
--- a/kernel/kexec_core.c~add-a-kexec_crash_loaded-function
+++ a/kernel/kexec_core.c
@@ -95,6 +95,12 @@ int kexec_should_crash(struct task_struc
 	return 0;
 }
 
+int kexec_crash_loaded(void)
+{
+	return !!kexec_crash_image;
+}
+EXPORT_SYMBOL_GPL(kexec_crash_loaded);
+
 /*
  * When kexec transitions to the new kernel there is a one-to-one
  * mapping between physical and virtual addresses.  On processors
diff -puN kernel/ksysfs.c~add-a-kexec_crash_loaded-function kernel/ksysfs.c
--- a/kernel/ksysfs.c~add-a-kexec_crash_loaded-function
+++ a/kernel/ksysfs.c
@@ -101,7 +101,7 @@ KERNEL_ATTR_RO(kexec_loaded);
 static ssize_t kexec_crash_loaded_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", !!kexec_crash_image);
+	return sprintf(buf, "%d\n", kexec_crash_loaded());
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
 
_

Patches currently in -mm which might be from ptesarik@suse.com are


