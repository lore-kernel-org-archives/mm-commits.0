From: akpm@linux-foundation.org
Subject: - uml-host-tls-diagnostics.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:23 -0800
Message-ID: <200802052236.m15Ma4mb012677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762300AbYBEWld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: host TLS diagnostics
has been removed from the -mm tree.  Its filename was
     uml-host-tls-diagnostics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: host TLS diagnostics
From: Jeff Dike <jdike@addtoit.com>

Add some diagnostics when TLS operations on the host fail.  Also spit out more
information about the TLS environment on the host at boot time.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/tls.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff -puN arch/um/sys-i386/tls.c~uml-host-tls-diagnostics arch/um/sys-i386/tls.c
--- a/arch/um/sys-i386/tls.c~uml-host-tls-diagnostics
+++ a/arch/um/sys-i386/tls.c
@@ -26,6 +26,11 @@ int do_set_thread_area(struct user_desc 
 	cpu = get_cpu();
 	ret = os_set_thread_area(info, userspace_pid[cpu]);
 	put_cpu();
+
+	if (ret)
+		printk(KERN_ERR "PTRACE_SET_THREAD_AREA failed, err = %d, "
+		       "index = %d\n", ret, info->entry_number);
+
 	return ret;
 }
 
@@ -37,6 +42,11 @@ int do_get_thread_area(struct user_desc 
 	cpu = get_cpu();
 	ret = os_get_thread_area(info, userspace_pid[cpu]);
 	put_cpu();
+
+	if (ret)
+		printk(KERN_ERR "PTRACE_GET_THREAD_AREA failed, err = %d, "
+		       "index = %d\n", ret, info->entry_number);
+
 	return ret;
 }
 
@@ -356,10 +366,9 @@ out:
 	return ret;
 }
 
-
 /*
- * XXX: This part is probably common to i386 and x86-64. Don't create a common
- * file for now, do that when implementing x86-64 support.
+ * This code is really i386-only, but it detects and logs x86_64 GDT indexes
+ * if a 32-bit UML is running on a 64-bit host.
  */
 static int __init __setup_host_supports_tls(void)
 {
@@ -368,13 +377,16 @@ static int __init __setup_host_supports_
 		printk(KERN_INFO "Host TLS support detected\n");
 		printk(KERN_INFO "Detected host type: ");
 		switch (host_gdt_entry_tls_min) {
-			case GDT_ENTRY_TLS_MIN_I386:
-				printk("i386\n");
-				break;
-			case GDT_ENTRY_TLS_MIN_X86_64:
-				printk("x86_64\n");
-				break;
+		case GDT_ENTRY_TLS_MIN_I386:
+			printk(KERN_CONT "i386");
+			break;
+		case GDT_ENTRY_TLS_MIN_X86_64:
+			printk(KERN_CONT "x86_64");
+			break;
 		}
+		printk(KERN_CONT " (GDT indexes %d to %d)\n",
+		       host_gdt_entry_tls_min,
+		       host_gdt_entry_tls_min + GDT_ENTRY_TLS_ENTRIES);
 	} else
 		printk(KERN_ERR "  Host TLS support NOT detected! "
 				"TLS support inside UML will not work\n");
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
