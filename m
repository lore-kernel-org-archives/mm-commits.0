From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch added to -mm tree
Date: Tue, 09 May 2017 13:34:39 -0700
Message-ID: <591227df.Hc5/RikdRAQRbI8/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54128 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdEIUek (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 16:34:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch

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
Subject: mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#4: 
1f5307b1e094 ("mm, vmalloc: properly track vmalloc users") has pulled

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#12: 
>> arch/m68k/include/asm/mcf_pgtable.h:339:43: error: 'init_mm' undeclared (first use in this function)

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#36: 
This patch reverts 1f5307b1e094 and reimplements the original fix in a

WARNING: line over 80 characters
#71: FILE: include/linux/vmalloc.h:85:
+static inline void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags, void* caller)

ERROR: "foo* bar" should be "foo *bar"
#71: FILE: include/linux/vmalloc.h:85:
+static inline void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags, void* caller)

ERROR: "foo* bar" should be "foo *bar"
#92: FILE: include/linux/vmalloc.h:96:
+					int node, gfp_t flags, void* caller);

WARNING: line over 80 characters
#143: FILE: mm/vmalloc.c:1820:
+void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags, void *caller)

total: 4 errors, 3 warnings, 80 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-vmalloc-fix-vmalloc-users-tracking-properly.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    5 +++--
 mm/vmalloc.c            |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/vmalloc.h~mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes
+++ a/include/linux/vmalloc.h
@@ -82,7 +82,8 @@ extern void *__vmalloc_node_range(unsign
 			const void *caller);
 #ifndef CONFIG_MMU
 extern void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags);
-static inline void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags, void* caller)
+static inline void *__vmalloc_node_flags_caller(unsigned long size, int node,
+						gfp_t flags, void *caller)
 {
 	return __vmalloc_node_flags(size, node, flags);
 }
@@ -93,7 +94,7 @@ static inline void *__vmalloc_node_flags
  * their callers and inlining will achieve that.
  */
 extern void *__vmalloc_node_flags_caller(unsigned long size,
-					int node, gfp_t flags, void* caller);
+					 int node, gfp_t flags, void *caller);
 #endif
 
 extern void vfree(const void *addr);
diff -puN mm/vmalloc.c~mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes
+++ a/mm/vmalloc.c
@@ -1817,7 +1817,8 @@ static inline void *__vmalloc_node_flags
 }
 
 
-void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags, void *caller)
+void *__vmalloc_node_flags_caller(unsigned long size, int node, gfp_t flags,
+				  void *caller)
 {
 	return __vmalloc_node(size, 1, flags, PAGE_KERNEL, node, caller);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
gcov-support-gcc-71-v2-checkpatch-fixes.patch
mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

