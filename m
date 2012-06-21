From: akpm@linux-foundation.org
Subject: + fs-jbd2-commitc-use-new-kmap_atomic-api.patch added to -mm tree
Date: Thu, 21 Jun 2012 14:08:47 -0700
Message-ID: <20120621215453.1ED65100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36441 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760417Ab2FUVyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 17:54:54 -0400
Received: by qcsp5 with SMTP id p5so128161qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 14:54:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, tytso@mit.edu


The patch titled
     Subject: fs/jbd2/commit.c: use new kmap_atomic() API
has been added to the -mm tree.  Its filename is
     fs-jbd2-commitc-use-new-kmap_atomic-api.patch

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
Subject: Subject: fs/jbd2/commit.c: use new kmap_atomic() API

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
tmpfs-implement-numa-node-interleaving-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
fs-jbd2-commitc-use-new-kmap_atomic-api.patch

