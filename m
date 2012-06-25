From: akpm@linux-foundation.org
Subject: [merged] fs-jbd2-commitc-use-new-kmap_atomic-api.patch removed from -mm tree
Date: Mon, 25 Jun 2012 14:06:11 -0700
Message-ID: <20120625210611.56132A02C5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:53816 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab2FYVGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jun 2012 17:06:14 -0400
Received: by lbbgp10 with SMTP id gp10so329840lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Jun 2012 14:06:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/jbd2/commit.c: use new kmap_atomic() API
has been removed from the -mm tree.  Its filename was
     fs-jbd2-commitc-use-new-kmap_atomic-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/jbd2/commit.c: use new kmap_atomic() API

fs/jbd2/commit.c:352: warning: 'kmap_atomic_deprecated' is deprecated (declared at include/linux/highmem.h:125)
fs/jbd2/commit.c:357: warning: '__kunmap_atomic_deprecated' is deprecated (declared at include/linux/highmem.h:135)

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/commit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/jbd2/commit.c~fs-jbd2-commitc-use-new-kmap_atomic-api fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~fs-jbd2-commitc-use-new-kmap_atomic-api
+++ a/fs/jbd2/commit.c
@@ -349,12 +349,12 @@ static void jbd2_block_tag_csum_set(jour
 		return;
 
 	sequence = cpu_to_be32(sequence);
-	addr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic(page);
 	csum = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&sequence,
 			  sizeof(sequence));
 	csum = jbd2_chksum(j, csum, addr + offset_in_page(bh->b_data),
 			  bh->b_size);
-	kunmap_atomic(addr, KM_USER0);
+	kunmap_atomic(addr);
 
 	tag->t_checksum = cpu_to_be32(csum);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
include-linux-timeh-make-nsec_per_sec-64-bit-on-32-bit-architectures.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
tmpfs-implement-numa-node-interleaving-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
x86-mce-use-new-printk-recursion-disabling-interface-fix.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
fs-introduce-pipe-only-dump-mode-suid_dumpable=3-fix.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

