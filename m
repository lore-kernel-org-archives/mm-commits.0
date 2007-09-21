From: akpm@linux-foundation.org
Subject: + kgdb-fix-docbook-and-kernel-doc-typos.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:49:53 -0700
Message-ID: <200709210449.l8L4nrWb019268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbXIUEuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kgdb: fix docbook and kernel-doc typos
has been added to the -mm tree.  Its filename is
     kgdb-fix-docbook-and-kernel-doc-typos.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kgdb: fix docbook and kernel-doc typos
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos/spellos in kgdb docbook template and included kernel-doc
file(s).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kgdb.tmpl |   10 +++++-----
 include/linux/kgdb.h            |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN Documentation/DocBook/kgdb.tmpl~kgdb-fix-docbook-and-kernel-doc-typos Documentation/DocBook/kgdb.tmpl
--- a/Documentation/DocBook/kgdb.tmpl~kgdb-fix-docbook-and-kernel-doc-typos
+++ a/Documentation/DocBook/kgdb.tmpl
@@ -149,9 +149,9 @@
     </itemizedlist>
     </para>
     <para>
-    The <symbol>CONFIG_KGDBOE</symbol> driver can be reconfigured at run
-    time, if <symbol>CONFIG_SYSFS</symbol> and
-    <symbol>CONFIG_MODULES</symbol> by echo'ing a new config string to
+    The <symbol>CONFIG_KGDBOE</symbol> driver can be reconfigured at run time,
+    if <symbol>CONFIG_SYSFS</symbol> and <symbol>CONFIG_MODULES</symbol>
+    are enabled, by echo'ing a new config string to
     <constant>/sys/module/kgdboe/parameter/kgdboe</constant>.  The
     driver can be unconfigured with the special string
     <constant>not_configured</constant>.
@@ -213,7 +213,7 @@
 	  This must be larger than NUMREGBYTES.
 	  </para>
 	  <para>
-	  CACHE_FLUSH_IS_SAFE: Set to one if it always safe to call
+	  CACHE_FLUSH_IS_SAFE: Set to one if it is always safe to call
 	  flush_cache_range or flush_icache_range.  On some architectures,
 	  these functions may not be safe to call on SMP since we keep other
 	  CPUs in a holding pattern.
@@ -223,7 +223,7 @@
       </para>
       <para>
       There are also the following functions for the common backend,
-      found in kernel/kgdb.c that must be supplied by the
+      found in kernel/kgdb.c, that must be supplied by the
       architecture-specific backend.  No weak version of these is provided.
       </para>
 !Iinclude/linux/kgdb.h
diff -puN include/linux/kgdb.h~kgdb-fix-docbook-and-kernel-doc-typos include/linux/kgdb.h
--- a/include/linux/kgdb.h~kgdb-fix-docbook-and-kernel-doc-typos
+++ a/include/linux/kgdb.h
@@ -116,7 +116,7 @@ extern void sleeping_thread_to_gdb_regs(
 
 /**
  *	gdb_regs_to_regs - Convert GDB regs to ptrace regs.
- *	@gdb_regs: A pointer to hold the registers we've recieved from GDB.
+ *	@gdb_regs: A pointer to hold the registers we've received from GDB.
  *	@regs: A pointer to a &struct pt_regs to hold these values in.
  *
  *	Convert the GDB regs in @gdb_regs into the pt_regs, and store them
@@ -130,7 +130,7 @@ extern void gdb_regs_to_regs(unsigned lo
  *	@signo: The signal number of the exception that happened.
  *	@err_code: The error code of the exception that happened.
  *	@remcom_in_buffer: The buffer of the packet we have read.
- *	@remcom_out_buffer: The buffer, of %BUFMAX to write a packet into.
+ *	@remcom_out_buffer: The buffer of %BUFMAX bytes to write a packet into.
  *	@regs: The &struct pt_regs of the current process.
  *
  *	This function MUST handle the 'c' and 's' command packets,
@@ -173,7 +173,7 @@ extern unsigned long kgdb_fault_jmp_regs
  *	kgdb_fault_setjmp - Store state in case we fault.
  *	@curr_context: An array to store state into.
  *
- *	Certain functions may try and access memory, and in doing so may
+ *	Certain functions may try to access memory, and in doing so may
  *	cause a fault.  When this happens, we trap it, restore state to
  *	this call, and let ourself know that something bad has happened.
  */
@@ -195,7 +195,7 @@ extern int kgdb_arch_set_breakpoint(unsi
 extern int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle);
 
 /**
- * struct kgdb_arch - Desribe architecture specific values.
+ * struct kgdb_arch - Describe architecture specific values.
  * @gdb_bpt_instr: The instruction to trigger a breakpoint.
  * @flags: Flags for the breakpoint, currently just %KGDB_HW_BREAKPOINT.
  * @shadowth: A value of %1 indicates we shadow information on processes.
@@ -229,7 +229,7 @@ struct kgdb_arch {
 };
 
 /**
- * struct kgdb_io - Desribe the interface for an I/O driver to talk with KGDB.
+ * struct kgdb_io - Describe the interface for an I/O driver to talk with KGDB.
  * @read_char: Pointer to a function that will return one char.
  * @write_char: Pointer to a function that will write one char.
  * @flush: Pointer to a function that will flush any pending writes.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
sound-hda-fix-help-text.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
menuconfig-distinguish-between-selected-by-another-options-and-comments.patch
git-mtd.patch
git-net.patch
git-nfsd.patch
fix-signedness-of-parameters-in-scsi-module.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
kgdb-fix-help-text.patch
kgdb-fix-docbook-and-kernel-doc-typos.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
profile-likely-unlikely-macros.patch
