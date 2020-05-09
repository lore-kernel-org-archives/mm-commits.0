From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-memory=5Fhotplug-allow-arch-override-of-non-boot-memory-?=
 =?US-ASCII?Q?resource-names-fix.patch?= added to -mm tree
Date: Fri, 08 May 2020 17:45:43 -0700
Message-ID: <20200509004543.9XdMgEBb3%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgEIApo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 20:45:44 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, bhsharma@redhat.com, catalin.marinas@arm.com, david@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, james.morse@arm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, piliu@redhat.com, will@kernel.org


The patch titled
     Subject: mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names-fix
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names-fix

use MEMORY_HOTPLUG_RES_NAME in the debug message as well

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: James Morse <james.morse@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: piliu <piliu@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names-fix
+++ a/mm/memory_hotplug.c
@@ -129,7 +129,8 @@ static struct resource *register_memory_
 			       resource_name, flags);
 
 	if (!res) {
-		pr_debug("Unable to reserve System RAM region: %016llx->%016llx\n",
+		pr_debug("Unable to reserve " MEMORY_HOTPLUG_RES_NAME
+				" region: %016llx->%016llx\n",
 				start, start + size);
 		return ERR_PTR(-EEXIST);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-makefile-use-config_shell.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
