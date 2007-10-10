From: akpm@linux-foundation.org
Subject: - kgdb-fix-docbook-and-kernel-doc-typos.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:11:08 -0700
Message-ID: <200710102111.l9ALB8qS026001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39998 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580AbXJJVV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kgdb: fix docbook and kernel-doc typos
has been removed from the -mm tree.  Its filename was
     kgdb-fix-docbook-and-kernel-doc-typos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-alsa.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
git-mtd.patch
git-net.patch
git-nfsd.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
dontdiff-update-based-on-gitignore-updates.patch
ecryptfs-remove-header_extent_size-fix.patch
video-gfx-fix-menu-ordering.patch
video-gfx-merge-kconfig-menus.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
