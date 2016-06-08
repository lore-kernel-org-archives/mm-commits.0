From: akpm@linux-foundation.org
Subject: +
 mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch added to -mm tree
Date: Wed, 08 Jun 2016 13:19:29 -0700
Message-ID: <57587dd1.lmfOfDhqG1m1+Wp4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850AbcFHUTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 16:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, glider@google.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix
has been added to the -mm tree.  Its filename is
     mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch

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
Subject: mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix

make calculate_sizes():size a size_t

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix mm/slub.c
--- a/mm/slub.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix
+++ a/mm/slub.c
@@ -3387,7 +3387,7 @@ static void set_min_partial(struct kmem_
 static int calculate_sizes(struct kmem_cache *s, int forced_order)
 {
 	unsigned long flags = s->flags;
-	unsigned long size = s->object_size;
+	size_t size = s->object_size;
 	int order;
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

