From: akpm@linux-foundation.org
Subject: + mm-printk-introduce-new-format-string-for-flags-fix-2.patch
 added to -mm tree
Date: Thu, 10 Dec 2015 14:47:25 -0800
Message-ID: <566a00fd.o+NUSgSDbVpCOiR7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbbLJWr0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Dec 2015 17:47:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@kernel.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-printk-introduce-new-format-string-for-flags-fix-2
has been added to the -mm tree.  Its filename is
     mm-printk-introduce-new-format-string-for-flags-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-printk-introduce-new-format-string-for-flags-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-printk-introduce-new-format-string-for-flags-fix-2.patch

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
Subject: mm-printk-introduce-new-format-string-for-flags-fix-2

move declaration of trace_print_flags arrays into mm/internal.h

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    6 ------
 lib/vsprintf.c          |    3 ++-
 mm/debug.c              |    2 ++
 mm/internal.h           |    7 +++++++
 4 files changed, 11 insertions(+), 7 deletions(-)

diff -puN include/linux/mmdebug.h~mm-printk-introduce-new-format-string-for-flags-fix-2 include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-printk-introduce-new-format-string-for-flags-fix-2
+++ a/include/linux/mmdebug.h
@@ -2,17 +2,11 @@
 #define LINUX_MM_DEBUG_H 1
 
 #include <linux/stringify.h>
-#include <linux/types.h>
-#include <linux/tracepoint.h>
 
 struct page;
 struct vm_area_struct;
 struct mm_struct;
 
-extern const struct trace_print_flags pageflag_names[];
-extern const struct trace_print_flags vmaflag_names[];
-extern const struct trace_print_flags gfpflag_names[];
-
 extern void dump_page(struct page *page, const char *reason);
 extern void dump_page_badflags(struct page *page, const char *reason,
 			       unsigned long badflags);
diff -puN lib/vsprintf.c~mm-printk-introduce-new-format-string-for-flags-fix-2 lib/vsprintf.c
--- a/lib/vsprintf.c~mm-printk-introduce-new-format-string-for-flags-fix-2
+++ a/lib/vsprintf.c
@@ -31,7 +31,8 @@
 #include <linux/dcache.h>
 #include <linux/cred.h>
 #include <net/addrconf.h>
-#include <linux/mmdebug.h>
+
+#include "../mm/internal.h"	/* For the trace_print_flags arrays */
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
diff -puN mm/debug.c~mm-printk-introduce-new-format-string-for-flags-fix-2 mm/debug.c
--- a/mm/debug.c~mm-printk-introduce-new-format-string-for-flags-fix-2
+++ a/mm/debug.c
@@ -13,6 +13,8 @@
 #include <trace/events/gfpflags.h>
 #include <linux/page_owner.h>
 
+#include "internal.h"
+
 char *migrate_reason_names[MR_TYPES] = {
 	"compaction",
 	"memory_failure",
diff -puN mm/internal.h~mm-printk-introduce-new-format-string-for-flags-fix-2 mm/internal.h
--- a/mm/internal.h~mm-printk-introduce-new-format-string-for-flags-fix-2
+++ a/mm/internal.h
@@ -11,9 +11,11 @@
 #ifndef __MM_INTERNAL_H
 #define __MM_INTERNAL_H
 
+#include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
+#include <linux/tracepoint.h>
 
 /*
  * The set of flags that only affect watermark checking and reclaim
@@ -441,4 +443,9 @@ static inline void try_to_unmap_flush_di
 }
 
 #endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
+
+extern const struct trace_print_flags pageflag_names[];
+extern const struct trace_print_flags vmaflag_names[];
+extern const struct trace_print_flags gfpflag_names[];
+
 #endif	/* __MM_INTERNAL_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
oom-kill-init-lead-panic-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-printk-introduce-new-format-string-for-flags-fix-2.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

