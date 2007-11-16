From: akpm@linux-foundation.org
Subject: + uml-host-tls-diagnostics.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:15:40 -0800
Message-ID: <200711160015.lAG0FeUX023229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934349AbXKPAPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:15:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: host TLS diagnostics
has been added to the -mm tree.  Its filename is
     uml-host-tls-diagnostics.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
