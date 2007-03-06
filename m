From: akpm@linux-foundation.org
Subject: - modpost-remove-fixed-size-buffer.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:01:05 -0800
Message-ID: <200703060101.l26115ZO007043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43877 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbXCFBBg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, john.voltz@gmail.com, rusty@rustcorp.com.au, samuel@sortiz.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     modpost: remove fixed size buffer
has been removed from the -mm tree.  Its filename was
     modpost-remove-fixed-size-buffer.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: modpost: remove fixed size buffer
From: Andrew Morton <akpm@osdl.org>

modpost has a couple of fixed-sized buffers.  As reported in
http://bugzilla.kernel.org/show_bug.cgi?id=7878, it broke.

Fix by dynamically allocating these things.  Unpleasingly: we really want
vasprintf(), but that's gnu-only.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: John Voltz <john.voltz@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/mod/modpost.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff -puN scripts/mod/modpost.c~modpost-remove-fixed-size-buffer scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~modpost-remove-fixed-size-buffer
+++ a/scripts/mod/modpost.c
@@ -1110,8 +1110,6 @@ static void read_symbols(char *modname)
 		mod->unres = alloc_symbol("struct_module", 0, mod->unres);
 }
 
-#define SZ 500
-
 /* We first write the generated file into memory using the
  * following helper, then compare to the file on disk and
  * only update the later if anything changed */
@@ -1119,20 +1117,28 @@ static void read_symbols(char *modname)
 void __attribute__((format(printf, 2, 3))) buf_printf(struct buffer *buf,
 						      const char *fmt, ...)
 {
-	char tmp[SZ];
-	int len;
+	char *tmp;
+	size_t len;
 	va_list ap;
 
 	va_start(ap, fmt);
-	len = vsnprintf(tmp, SZ, fmt, ap);
+	len = snprintf(NULL, 0, fmt, ap);
+	va_end(ap);
+	tmp = malloc(len + 1);
+	if (tmp == NULL)
+		fatal("modpost: out of memory in %s\n", __FUNCTION__);
+
+	va_start(ap, fmt);
+	len = snprintf(tmp, len, fmt, ap);
 	buf_write(buf, tmp, len);
 	va_end(ap);
+	free(tmp);
 }
 
 void buf_write(struct buffer *buf, const char *s, int len)
 {
 	if (buf->size - buf->pos < len) {
-		buf->size += len + SZ;
+		buf->size += len + 500;
 		buf->p = realloc(buf->p, buf->size);
 	}
 	strncpy(buf->p + buf->pos, s, len);
@@ -1442,7 +1448,6 @@ int main(int argc, char **argv)
 {
 	struct module *mod;
 	struct buffer buf = { };
-	char fname[SZ];
 	char *kernel_read = NULL, *module_read = NULL;
 	char *dump_write = NULL;
 	int opt;
@@ -1492,6 +1497,9 @@ int main(int argc, char **argv)
 	err = 0;
 
 	for (mod = modules; mod; mod = mod->next) {
+		char *fname;
+		static const char fmt[] = "%s.mod.c";
+
 		if (mod->skip)
 			continue;
 
@@ -1503,8 +1511,12 @@ int main(int argc, char **argv)
 		add_moddevtable(&buf, mod);
 		add_srcversion(&buf, mod);
 
-		sprintf(fname, "%s.mod.c", mod->name);
+		fname = malloc(strlen(mod->name) + sizeof(fmt));
+		if (fname == NULL)
+			fatal("modpost: out of memory in %s\n", __FUNCTION__);
+		sprintf(fname, fmt, mod->name);
 		write_if_changed(&buf, fname);
+		free(fname);
 	}
 
 	if (dump_write)
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
rcu-preemptible-rcu.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix-2.patch
local_t-powerpc-extension-fix.patch
local_t-powerpc-extension-fix-build-fix.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
