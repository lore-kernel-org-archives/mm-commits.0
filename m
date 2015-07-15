From: akpm@linux-foundation.org
Subject: +
 define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix.patch added to -mm tree
Date: Wed, 15 Jul 2015 14:41:38 -0700
Message-ID: <55a6d392.0TzdWT5zK99zm+Sj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbbGOVlj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 17:41:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mnfhuang@gmail.com, namhyung@kernel.org, rob.jones@codethink.co.uk, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix
has been added to the -mm tree.  Its filename is
     define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix.patch

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
Subject: define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix

fix CONFIG_MODULES=n build

Cc: Minfei Huang <mnfhuang@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Rob Jones <rob.jones@codethink.co.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/module.h~define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix include/linux/module.h
--- a/include/linux/module.h~define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix
+++ a/include/linux/module.h
@@ -189,6 +189,9 @@ const struct exception_table_entry *sear
 
 struct notifier_block;
 
+typedef int (*kallsyms_cmp_symbol_t)(void *, const char *,
+		struct module *, unsigned long);
+
 #ifdef CONFIG_MODULES
 
 extern int modules_disabled; /* for sysctl */
@@ -479,9 +482,6 @@ int module_get_kallsym(unsigned int symn
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
 
-typedef int (*kallsyms_cmp_symbol_t)(void *, const char *,
-		struct module *, unsigned long);
-
 int module_kallsyms_on_each_symbol(kallsyms_cmp_symbol_t fn, void *data);
 
 extern void __module_put_and_exit(struct module *mod, long code)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
openrisc-fix-config_uid16-setting.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
mm-page-refine-the-calculation-of-highest-possible-node-id.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

