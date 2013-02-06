From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2013 13:34:10 -0800
Message-ID: <20130206213411.172D85A4173@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:34615 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab3BFVeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 16:34:12 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so201905ves.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 13:34:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, lig.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: break circular include from linux/mmzone.h fix fix fix fix
has been removed from the -mm tree.  Its filename was
     mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix.patch

This patch was dropped because it was folded into mm-break-circular-include-from-linux-mmzoneh.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm: break circular include from linux/mmzone.h fix fix fix fix

kernel/jump_label.c: In function `jump_label_module_notify':
kernel/jump_label.c:393:2: error: implicit declaration of function `notifier_from_errno' [-Werror=implicit-function-declaration]
kernel/jump_label.c: At top level:
kernel/jump_label.c:396:8: error: variable `jump_label_module_nb' has initializer but incomplete type
kernel/jump_label.c:397:2: error: unknown field `notifier_call' specified in initializer
kernel/jump_label.c:397:2: warning: excess elements in struct initializer [enabled by default]
kernel/jump_label.c:397:2: warning: (near initialization for `jump_label_module_nb') [enabled by default]
kernel/jump_label.c:398:2: error: unknown field `priority' specified in initializer
kernel/jump_label.c:398:2: warning: excess elements in struct initializer [enabled by default]
kernel/jump_label.c:398:2: warning: (near initialization for `jump_label_module_nb') [enabled by default]

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: liguang <lig.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/jump_label.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/jump_label.c~mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix kernel/jump_label.c
--- a/kernel/jump_label.c~mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix
+++ a/kernel/jump_label.c
@@ -13,6 +13,7 @@
 #include <linux/sort.h>
 #include <linux/err.h>
 #include <linux/static_key.h>
+#include <linux/notifier.h>
 
 #ifdef HAVE_JUMP_LABEL
 
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch
compiler-gcch-add-gcc-recommended-gcc_version-macro.patch
compiler-gcc34h-use-gcc_version-macro.patch
compiler-gcc4h-bugh-remove-duplicate-macros.patch
bugh-fix-build_bug_on-macro-in-__checker__.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-make-build_bug_on-generate-compile-time-error.patch
compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
memory-hotplug-export-the-function-try_offline_node.patch
memory-hotplug-export-the-function-try_offline_node-fix.patch
cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
sched-do-not-use-cpu_to_node-to-find-an-offlined-cpus-node.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
mm-use-numa_no_node.patch
mm-break-circular-include-from-linux-mmzoneh.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

