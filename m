From: akpm@linux-foundation.org
Subject: [merged] hugetlb_file_setup-use-c-not-cpp.patch removed from -mm tree
Date: Fri, 25 Sep 2009 12:53:25 -0700
Message-ID: <200909251953.n8PJrP4S002889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbZIYTyG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 15:54:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agl@us.ibm.com, apw@canonical.com, dhowells@redhat.com, ebmunson@us.ibm.com, eric.whitney@hp.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nacc@us.ibm.comr


The patch titled
     hugetlb_file_setup(): use C, not cpp
has been removed from the -mm tree.  Its filename was
     hugetlb_file_setup-use-c-not-cpp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb_file_setup(): use C, not cpp
From: Andrew Morton <akpm@linux-foundation.org>

why macros are always wrong:

mm/mmap.c: In function 'do_mmap_pgoff':
mm/mmap.c:953: warning: unused variable 'user'

also, move a couple of struct forward-decls outside `#ifdef
CONFIG_HUGETLB_PAGE' - it's pointless and frequently harmful to make these
conditional (eg, this patch needed `struct user_struct').

Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb_file_setup-use-c-not-cpp include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb_file_setup-use-c-not-cpp
+++ a/include/linux/hugetlb.h
@@ -3,15 +3,15 @@
 
 #include <linux/fs.h>
 
+struct ctl_table;
+struct user_struct;
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/mempolicy.h>
 #include <linux/shm.h>
 #include <asm/tlbflush.h>
 
-struct ctl_table;
-struct user_struct;
-
 int PageHuge(struct page *page);
 
 static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
@@ -187,7 +187,11 @@ static inline void set_file_hugepages(st
 
 #define is_file_hugepages(file)			0
 #define set_file_hugepages(file)		BUG()
-#define hugetlb_file_setup(name,size,acct,user,creat)	ERR_PTR(-ENOSYS)
+static inline struct file *hugetlb_file_setup(const char *name, size_t size,
+		int acctflag, struct user_struct **user, int creat_flags)
+{
+	return ERR_PTR(-ENOSYS);
+}
 
 #endif /* !CONFIG_HUGETLBFS */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

