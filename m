From: akpm@linux-foundation.org
Subject: +
 kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
 added to -mm tree
Date: Mon, 04 Nov 2013 14:36:35 -0800
Message-ID: <52782173.U8U8FUmw4gQTBN2B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KDWgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 17:36:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, hch@infradead.org, axboe@kernel.dk, akpm@linux-foundation.org

Subject: + kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch added to -mm tree
To: akpm@linux-foundation.org,axboe@kernel.dk,hch@infradead.org,hch@lst.de,jack@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 14:36:35 -0800


The patch titled
     Subject: kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix
has been added to the -mm tree.  Its filename is
     kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix

x86_64 allnoconfig:

kernel/up.c:25: error: redefinition of '__smp_call_function_single'
include/linux/smp.h:154: note: previous definition of '__smp_call_function_single' was here

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN include/linux/smp.h~kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix include/linux/smp.h
--- a/include/linux/smp.h~kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix
+++ a/include/linux/smp.h
@@ -49,6 +49,9 @@ void on_each_cpu_cond(bool (*cond_func)(
 		smp_call_func_t func, void *info, bool wait,
 		gfp_t gfp_flags);
 
+void __smp_call_function_single(int cpuid, struct call_single_data *data,
+				int wait);
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
@@ -95,9 +98,6 @@ int smp_call_function(smp_call_func_t fu
 void smp_call_function_many(const struct cpumask *mask,
 			    smp_call_func_t func, void *info, bool wait);
 
-void __smp_call_function_single(int cpuid, struct call_single_data *data,
-				int wait);
-
 int smp_call_function_any(const struct cpumask *mask,
 			  smp_call_func_t func, void *info, int wait);
 
@@ -151,12 +151,6 @@ smp_call_function_any(const struct cpuma
 
 static inline void kick_all_cpus_sync(void) {  }
 
-static inline void __smp_call_function_single(int cpuid,
-		struct call_single_data *data, int wait)
-{
-	on_each_cpu(data->func, data->info, wait);
-}
-
 #endif /* !SMP */
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
kfifo-api-type-safety-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

