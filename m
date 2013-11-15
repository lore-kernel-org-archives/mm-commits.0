From: akpm@linux-foundation.org
Subject: [merged]
 kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:09:19 -0800
Message-ID: <52867f6f.upn4zFd0ak0REAvF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3KOUJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, hch@infradead.org, axboe@kernel.dk, akpm@linux-foundation.org

Subject: [merged] kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,axboe@kernel.dk,hch@infradead.org,hch@lst.de,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:19 -0800


The patch titled
     Subject: kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix
has been removed from the -mm tree.  Its filename was
     kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

