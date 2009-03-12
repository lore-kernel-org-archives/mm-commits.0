From: akpm@linux-foundation.org
Subject: [merged] kgdb-fix-kernel-doc-error.patch removed from -mm tree
Date: Thu, 12 Mar 2009 13:16:40 -0700
Message-ID: <200903122016.n2CKGeKI032563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732AbZCLUSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 16:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     kgdb: fix kernel-doc error
has been removed from the -mm tree.  Its filename was
     kgdb-fix-kernel-doc-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kgdb: fix kernel-doc error
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc format error in kgdb.h:

linux-next-20081022//include/linux/kgdb.h:308): duplicate section name 'Description'

and fix typos in that file's kernel-doc comments.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kgdb.h |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN include/linux/kgdb.h~kgdb-fix-kernel-doc-error include/linux/kgdb.h
--- a/include/linux/kgdb.h~kgdb-fix-kernel-doc-error
+++ a/include/linux/kgdb.h
@@ -29,8 +29,7 @@ struct pt_regs;
  *
  *	On some architectures it is required to skip a breakpoint
  *	exception when it occurs after a breakpoint has been removed.
- *	This can be implemented in the architecture specific portion of
- *	for kgdb.
+ *	This can be implemented in the architecture specific portion of kgdb.
  */
 extern int kgdb_skipexception(int exception, struct pt_regs *regs);
 
@@ -42,7 +41,7 @@ extern int kgdb_skipexception(int except
  *
  *	This is usually needed on architectures which support SMP and
  *	KGDB.  This function is called after all the secondary cpus have
- *	been put to a know spin state and the primary CPU has control over
+ *	been put to a known spin state and the primary CPU has control over
  *	KGDB.
  */
 extern void kgdb_post_primary_code(struct pt_regs *regs, int e_vector,
@@ -65,7 +64,7 @@ struct uart_port;
 /**
  *	kgdb_breakpoint - compiled in breakpoint
  *
- *	This will be impelmented a static inline per architecture.  This
+ *	This will be implemented as a static inline per architecture.  This
  *	function is called by the kgdb core to execute an architecture
  *	specific trap to cause kgdb to enter the exception processing.
  *
@@ -190,7 +189,7 @@ kgdb_arch_handle_exception(int vector, i
  *	@flags: Current IRQ state
  *
  *	On SMP systems, we need to get the attention of the other CPUs
- *	and get them be in a known state.  This should do what is needed
+ *	and get them into a known state.  This should do what is needed
  *	to get the other CPUs to call kgdb_wait(). Note that on some arches,
  *	the NMI approach is not used for rounding up all the CPUs. For example,
  *	in case of MIPS, smp_call_function() is used to roundup CPUs. In
@@ -295,8 +294,7 @@ extern int __weak kgdb_mem2hex(char *mem
 extern int __weak kgdb_hex2mem(char *buf, char *mem, int count);
 
 /**
- *      kgdb_ebin2mem - (optional arch override) Copy the binary array
- *     pointed to by buf into mem.
+ *      kgdb_ebin2mem - (optional arch override) Copy binary array from @buf into @mem
  *      @buf: source buffer
  *      @mem: target buffer
  *      @count: number of bytes in mem
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
git-acpi-vs-git-cpufreq.patch
x86-oqo-depends-on-input_polldev.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
wimax-fix-i2400m-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
alpha-convert-u64-to-unsigned-long-long.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
documentation-ignore-byproducts-from-latex.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

