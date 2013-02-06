From: akpm@linux-foundation.org
Subject: + mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix.patch added to -mm tree
Date: Wed, 06 Feb 2013 12:28:22 -0800
Message-ID: <20130206202822.9B17931C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59778 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab3BFU2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 15:28:23 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so206286qaj.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 12:28:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, lig.fnst@cn.fujitsu.com


The patch titled
     Subject: mm: break circular include from linux/mmzone.h fix fix fix fix
has been added to the -mm tree.  Its filename is
     mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

