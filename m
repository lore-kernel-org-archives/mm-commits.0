From: akpm@linux-foundation.org
Subject: - mm-fix-pagecache-write-deadlocks.patch removed from -mm tree
Date: Sun, 04 Feb 2007 01:08:10 -0800
Message-ID: <200702040908.l1498Aj0026154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34091 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbXBDJIR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Feb 2007 04:08:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: fix pagecache write deadlocks
has been removed from the -mm tree.  Its filename was
     mm-fix-pagecache-write-deadlocks.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mm: fix pagecache write deadlocks
From: Andrew Morton <akpm@osdl.org> and Nick Piggin <npiggin@suse.de>

The idea is to modify the core write() code so that it won't take a
pagefault while holding a lock on the pagecache page.  There are a number
of different deadlocks possible if we try to do such a thing:

1.  generic_buffered_write
2.   lock_page
3.    prepare_write
4.     unlock_page+vmtruncate
5.     copy_from_user
6.      mmap_sem(r)
7.       handle_mm_fault
8.        lock_page (filemap_nopage)
9.    commit_write
1.   unlock_page

b. sys_munmap / sys_mlock / others
c.  mmap_sem(w)
d.   make_pages_present
e.    get_user_pages
f.     handle_mm_fault
g.      lock_page (filemap_nopage)

2,8	- recursive deadlock if page is same
2,8;2,8	- ABBA deadlock is page is different
2,6;c,g	- ABBA deadlock if page is same

- Instead of copy_from_user(), use inc_preempt_count() and
  copy_from_user_inatomic().

- If the copy_from_user_inatomic() hits a pagefault, it'll return a short
  copy.

  - if the page was not uptodate, we cannot commit the write, because the
    uncopied bit could have uninitialised data. Commit zero length copy,
    which should do the right thing (ie. not set the page uptodate).

  - if the page was uptodate, commit the copied portion so we make some
    progress.

  - unlock_page()

  - go back and try to fault the page in again, redo the lock_page,
    prepare_write, copy_from_user_inatomic(), etc.

- Now we have a non uptodate page, and we keep faulting on a 2nd or later
  iovec, this gives a deadlock, because fault_in_pages readable only faults
  in the first iovec. To fix this situation, if we fault on a !uptodate page,
  make the next iteration only attempt to copy a single iovec.

- This also showed up a number of buggy prepare_write / commit_write
  implementations that were setting the page uptodate in the prepare_write
  side: bad! this allows uninitialised data to be read. Fix these.

(also, rename maxlen to seglen, because it was confusing)

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/buffer.c  |   41 +++++------------
 fs/libfs.c   |   41 +++++++++--------
 mm/filemap.c |  112 +++++++++++++++++++++++++++++++------------------
 mm/filemap.h |   74 +++++++++++++++++++++-----------
 4 files changed, 154 insertions(+), 114 deletions(-)

diff -puN fs/buffer.c~mm-fix-pagecache-write-deadlocks fs/buffer.c
--- a/fs/buffer.c~mm-fix-pagecache-write-deadlocks
+++ a/fs/buffer.c
@@ -1881,6 +1881,9 @@ static int __block_commit_write(struct i
 	unsigned blocksize;
 	struct buffer_head *bh, *head;
 
+	if (from == to)
+		return 0;
+
 	blocksize = 1 << inode->i_blkbits;
 
 	for(bh = head = page_buffers(page), block_start = 0;
@@ -2342,17 +2345,6 @@ int nobh_prepare_write(struct page *page
 
 	if (is_mapped_to_disk)
 		SetPageMappedToDisk(page);
-	SetPageUptodate(page);
-
-	/*
-	 * Setting the page dirty here isn't necessary for the prepare_write
-	 * function - commit_write will do that.  But if/when this function is
-	 * used within the pagefault handler to ensure that all mmapped pages
-	 * have backing space in the filesystem, we will need to dirty the page
-	 * if its contents were altered.
-	 */
-	if (dirtied_it)
-		set_page_dirty(page);
 
 	return 0;
 
@@ -2361,17 +2353,6 @@ failed:
 		if (read_bh[i])
 			free_buffer_head(read_bh[i]);
 	}
-
-	/*
-	 * Error recovery is pretty slack.  Clear the page and mark it dirty
-	 * so we'll later zero out any blocks which _were_ allocated.
-	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-	SetPageUptodate(page);
-	set_page_dirty(page);
 	return ret;
 }
 EXPORT_SYMBOL(nobh_prepare_write);
@@ -2379,13 +2360,16 @@ EXPORT_SYMBOL(nobh_prepare_write);
 int nobh_commit_write(struct file *file, struct page *page,
 		unsigned from, unsigned to)
 {
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	if (to > from) {
+		struct inode *inode = page->mapping->host;
+		loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
 
-	set_page_dirty(page);
-	if (pos > inode->i_size) {
-		i_size_write(inode, pos);
-		mark_inode_dirty(inode);
+		SetPageUptodate(page);
+		set_page_dirty(page);
+		if (pos > inode->i_size) {
+			i_size_write(inode, pos);
+			mark_inode_dirty(inode);
+		}
 	}
 	return 0;
 }
@@ -2476,6 +2460,7 @@ int nobh_truncate_page(struct address_sp
 		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
 		flush_dcache_page(page);
 		kunmap_atomic(kaddr, KM_USER0);
+		SetPageUptodate(page);
 		set_page_dirty(page);
 	}
 	unlock_page(page);
diff -puN fs/libfs.c~mm-fix-pagecache-write-deadlocks fs/libfs.c
--- a/fs/libfs.c~mm-fix-pagecache-write-deadlocks
+++ a/fs/libfs.c
@@ -327,32 +327,35 @@ int simple_readpage(struct file *file, s
 int simple_prepare_write(struct file *file, struct page *page,
 			unsigned from, unsigned to)
 {
-	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE) {
-			void *kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr, 0, from);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
+	if (PageUptodate(page))
+		return 0;
+
+	if (to - from != PAGE_CACHE_SIZE) {
+		clear_highpage(page);
+		flush_dcache_page(page);
 		SetPageUptodate(page);
 	}
+
 	return 0;
 }
 
 int simple_commit_write(struct file *file, struct page *page,
-			unsigned offset, unsigned to)
+			unsigned from, unsigned to)
 {
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
-
-	/*
-	 * No need to use i_size_read() here, the i_size
-	 * cannot change under us because we hold the i_mutex.
-	 */
-	if (pos > inode->i_size)
-		i_size_write(inode, pos);
-	set_page_dirty(page);
+	if (to > from) {
+		struct inode *inode = page->mapping->host;
+		loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+
+		if (to - from == PAGE_CACHE_SIZE)
+			SetPageUptodate(page);
+		/*
+		 * No need to use i_size_read() here, the i_size
+		 * cannot change under us because we hold the i_mutex.
+		 */
+		if (pos > inode->i_size)
+			i_size_write(inode, pos);
+		set_page_dirty(page);
+	}
 	return 0;
 }
 
diff -puN mm/filemap.c~mm-fix-pagecache-write-deadlocks mm/filemap.c
--- a/mm/filemap.c~mm-fix-pagecache-write-deadlocks
+++ a/mm/filemap.c
@@ -2092,7 +2092,7 @@ generic_file_buffered_write(struct kiocb
 	do {
 		pgoff_t index;		/* Pagecache index for current page */
 		unsigned long offset;	/* Offset into pagecache page */
-		unsigned long maxlen;	/* Bytes remaining in current iovec */
+		unsigned long seglen;	/* Bytes remaining in current iovec */
 		size_t bytes;		/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 
@@ -2102,18 +2102,16 @@ generic_file_buffered_write(struct kiocb
 		if (bytes > count)
 			bytes = count;
 
-		maxlen = cur_iov->iov_len - iov_offset;
-		if (maxlen > bytes)
-			maxlen = bytes;
+		seglen = min(cur_iov->iov_len - iov_offset, bytes);
 
+retry_noprogress:
 #ifndef CONFIG_DEBUG_VM
 		/*
-		 * Bring in the user page that we will copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
-		 * up-to-date.
+		 * Bring in the user page that we will copy from _first_, this
+		 * minimises the chance we have to break into the slowpath
+		 * below.
 		 */
-		fault_in_pages_readable(buf, maxlen);
+		fault_in_pages_readable(buf, seglen);
 #endif
 
 		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
@@ -2124,8 +2122,6 @@ generic_file_buffered_write(struct kiocb
 
 		status = a_ops->prepare_write(file, page, offset, offset+bytes);
 		if (unlikely(status)) {
-			loff_t isize = i_size_read(inode);
-
 			if (status != AOP_TRUNCATED_PAGE)
 				unlock_page(page);
 			page_cache_release(page);
@@ -2133,52 +2129,86 @@ generic_file_buffered_write(struct kiocb
 				continue;
 			/*
 			 * prepare_write() may have instantiated a few blocks
-			 * outside i_size.  Trim these off again.
+			 * outside i_size.  Trim these off again. Don't need
+			 * i_size_read because we hold i_mutex.
 			 */
-			if (pos + bytes > isize)
-				vmtruncate(inode, isize);
+			if (pos + bytes > inode->i_size)
+				vmtruncate(inode, inode->i_size);
 			break;
 		}
+
+		/*
+		 * Must not enter the pagefault handler here, because we hold
+		 * the page lock, so we might recursively deadlock on the same
+		 * lock, or get an ABBA deadlock against a different lock, or
+		 * against the mmap_sem (which nests outside the page lock).
+		 * So increment preempt count, and use _atomic usercopies.
+		 */
+		inc_preempt_count();
 		if (likely(nr_segs == 1))
-			copied = filemap_copy_from_user(page, offset,
+			copied = filemap_copy_from_user_atomic(page, offset,
 							buf, bytes);
 		else
-			copied = filemap_copy_from_user_iovec(page, offset,
-						cur_iov, iov_offset, bytes);
+			copied = filemap_copy_from_user_iovec_atomic(page,
+						offset, cur_iov, iov_offset,
+						bytes);
+		dec_preempt_count();
+
+		if (!PageUptodate(page)) {
+			/*
+			 * If the page is not uptodate, we cannot allow a
+			 * partial commit_write, because that might expose
+			 * uninitialised data.
+			 *
+			 * We will enter the single-segment path below, which
+			 * should get the filesystem to bring the page
+			 * uputodate for us next time.
+			 */
+			if (unlikely(copied != bytes))
+				copied = 0;
+		}
+
 		flush_dcache_page(page);
-		status = a_ops->commit_write(file, page, offset, offset+bytes);
+		status = a_ops->commit_write(file, page, offset, offset+copied);
 		if (status == AOP_TRUNCATED_PAGE) {
 			page_cache_release(page);
 			continue;
 		}
-		if (likely(copied > 0)) {
-			if (!status)
-				status = copied;
-
-			if (status >= 0) {
-				written += status;
-				count -= status;
-				pos += status;
-				buf += status;
-				if (unlikely(nr_segs > 1)) {
-					filemap_set_next_iovec(&cur_iov,
-							&iov_offset, status);
-					if (count)
-						buf = cur_iov->iov_base +
-							iov_offset;
-				} else {
-					iov_offset += status;
-				}
-			}
-		}
-		if (unlikely(copied != bytes))
-			if (status >= 0)
-				status = -EFAULT;
 		unlock_page(page);
 		mark_page_accessed(page);
 		page_cache_release(page);
+
 		if (status < 0)
 			break;
+		if (likely(copied > 0)) {
+			written += copied;
+			count -= copied;
+			pos += copied;
+			buf += copied;
+			if (unlikely(nr_segs > 1)) {
+				filemap_set_next_iovec(&cur_iov,
+						&iov_offset, copied);
+				if (count)
+					buf = cur_iov->iov_base + iov_offset;
+			} else {
+				iov_offset += copied;
+			}
+		} else {
+#ifdef CONFIG_DEBUG_VM
+			fault_in_pages_readable(buf, bytes);
+#endif
+			/*
+			 * OK, we took a fault without making progress. Fall
+			 * back to trying just a single segment next time.
+			 * This is important to prevent deadlock if a full
+			 * page write was not causing the page to be brought
+			 * uptodate. A smaller write will tend to bring it
+			 * uptodate in ->prepare_write, and thus we have a
+			 * chance of making some progress.
+			 */
+			bytes = seglen;
+			goto retry_noprogress;
+		}
 		balance_dirty_pages_ratelimited(mapping);
 		cond_resched();
 	} while (count);
diff -puN mm/filemap.h~mm-fix-pagecache-write-deadlocks mm/filemap.h
--- a/mm/filemap.h~mm-fix-pagecache-write-deadlocks
+++ a/mm/filemap.h
@@ -22,19 +22,19 @@ __filemap_copy_from_user_iovec_inatomic(
 
 /*
  * Copy as much as we can into the page and return the number of bytes which
- * were sucessfully copied.  If a fault is encountered then clear the page
- * out to (offset+bytes) and return the number of bytes which were copied.
+ * were sucessfully copied.  If a fault is encountered then return the number of
+ * bytes which were copied.
  *
- * NOTE: For this to work reliably we really want copy_from_user_inatomic_nocache
- * to *NOT* zero any tail of the buffer that it failed to copy.  If it does,
- * and if the following non-atomic copy succeeds, then there is a small window
- * where the target page contains neither the data before the write, nor the
- * data after the write (it contains zero).  A read at this time will see
- * data that is inconsistent with any ordering of the read and the write.
- * (This has been detected in practice).
+ * NOTE: For this to work reliably we really want
+ * copy_from_user_inatomic_nocache to *NOT* zero any tail of the buffer that it
+ * failed to copy.  If it does, and if the following non-atomic copy succeeds,
+ * then there is a small window where the target page contains neither the data
+ * before the write, nor the data after the write (it contains zero).  A read at
+ * this time will see data that is inconsistent with any ordering of the read
+ * and the write.  (This has been detected in practice).
  */
 static inline size_t
-filemap_copy_from_user(struct page *page, unsigned long offset,
+filemap_copy_from_user_atomic(struct page *page, unsigned long offset,
 			const char __user *buf, unsigned bytes)
 {
 	char *kaddr;
@@ -44,23 +44,32 @@ filemap_copy_from_user(struct page *page
 	left = __copy_from_user_inatomic_nocache(kaddr + offset, buf, bytes);
 	kunmap_atomic(kaddr, KM_USER0);
 
-	if (left != 0) {
-		/* Do it the slow way */
-		kaddr = kmap(page);
-		left = __copy_from_user_nocache(kaddr + offset, buf, bytes);
-		kunmap(page);
-	}
+	return bytes - left;
+}
+
+static inline size_t
+filemap_copy_from_user_nonatomic(struct page *page, unsigned long offset,
+			const char __user *buf, unsigned bytes)
+{
+	char *kaddr;
+	int left;
+
+	kaddr = kmap(page);
+	left = __copy_from_user_nocache(kaddr + offset, buf, bytes);
+	kunmap(page);
+
 	return bytes - left;
 }
 
 /*
- * This has the same sideeffects and return value as filemap_copy_from_user().
+ * This has the same sideeffects and return value as
+ * filemap_copy_from_user_atomic().
  * The difference is that on a fault we need to memset the remainder of the
  * page (out to offset+bytes), to emulate filemap_copy_from_user()'s
  * single-segment behaviour.
  */
 static inline size_t
-filemap_copy_from_user_iovec(struct page *page, unsigned long offset,
+filemap_copy_from_user_iovec_atomic(struct page *page, unsigned long offset,
 			const struct iovec *iov, size_t base, size_t bytes)
 {
 	char *kaddr;
@@ -70,14 +79,27 @@ filemap_copy_from_user_iovec(struct page
 	copied = __filemap_copy_from_user_iovec_inatomic(kaddr + offset, iov,
 							 base, bytes);
 	kunmap_atomic(kaddr, KM_USER0);
-	if (copied != bytes) {
-		kaddr = kmap(page);
-		copied = __filemap_copy_from_user_iovec_inatomic(kaddr + offset, iov,
-								 base, bytes);
-		if (bytes - copied)
-			memset(kaddr + offset + copied, 0, bytes - copied);
-		kunmap(page);
-	}
+	return copied;
+}
+
+/*
+ * This has the same sideeffects and return value as
+ * filemap_copy_from_user_nonatomic().
+ * The difference is that on a fault we need to memset the remainder of the
+ * page (out to offset+bytes), to emulate filemap_copy_from_user_nonatomic()'s
+ * single-segment behaviour.
+ */
+static inline size_t
+filemap_copy_from_user_iovec_nonatomic(struct page *page, unsigned long offset,
+			const struct iovec *iov, size_t base, size_t bytes)
+{
+	char *kaddr;
+	size_t copied;
+
+	kaddr = kmap(page);
+	copied = __filemap_copy_from_user_iovec_inatomic(kaddr + offset, iov,
+							 base, bytes);
+	kunmap(page);
 	return copied;
 }
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
revert-blockdev-direct-io-back-to-2619-version.patch
x86-fix-vdso-mapping-for-aout-executables.patch
mm-show-bounce-pages-in-oom-killer-output.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled-tidy.patch
acpi-updates-rtc-cmos-device-platform_data-vs-git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
agpgart-allow-drm-populated-agp-memory-types-tidy.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
powerpc-make-it-compile.patch
git-dvb.patch
dvb-video_buf-depends-on-pci.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
sata_nv-cleanup-adma-error-handling-v2.patch
sata_sis-avoid-extern-decl-in-c.patch
mm-ide-ide-acpi-support-warning-fix.patch
git-lxdialog-fixup.patch
git-mips-kconfig-fix.patch
git-mips-prom_free_prom_memory-borkage.patch
git-mmc.patch
git-mmc-fixup.patch
git-ubi.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls-fix.patch
dccp-warning-fixes.patch
netfilter-warning-fix.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
nfs-fix-congestion-control-v4-tweaks.patch
r8169-warning-fixes.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch
sh-add-kconfig-default.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
scsi_kmap_atomic_sg-check-that-local-irqs-are-disabled.patch
git-block-fixup.patch
git-block-borkage.patch
git-block-atomicity-fix.patch
git-block-xfs-fix.patch
git-block-xfs-barriers-broke.patch
fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
nokia-e70-is-an-unusual-device.patch
git-ipwireless_cs.patch
revert-x86_64-mm-msr-on-cpu.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
cyrix-fails-to-detect-mediagx-warning-fix.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
use-zvc-for-inactive-and-active-counts-up-fix.patch
drop-free_pages-fix.patch
drop-free_pages-sparc64-fix.patch
optional-zone_dma-in-the-vm-tidy.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch
remove-invalidate_inode_pages.patch
add-an-rcu-version-of-list-splicing-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
block_write_full_page-handle-enospc.patch
sysctl-warning-fix.patch
proc_misc-warning-fix.patch
rtc-framework-driver-for-cmos-rtcs-fix.patch
rtc-framework-driver-for-cmos-rtcs-fix-2.patch
return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-tidy.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-tidy-fixes.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
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
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
dynamic-kernel-command-line-ia64-fix.patch
rcu-preemptible-rcu-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
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
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
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
squash-ipc-warnings.patch
squash-udf-warnings.patch
mm-revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
mm-revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
mm-generic_file_buffered_write-cleanup.patch
