From: akpm@linux-foundation.org
Subject: + printk-add-generic-functions-to-find-kern_level-headers-fix.patch added to -mm tree
Date: Thu, 21 Jun 2012 14:17:31 -0700
Message-ID: <20120621211731.A81FEA02DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:58337 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760311Ab2FUVRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 17:17:33 -0400
Received: by vcbfl13 with SMTP id fl13so119732vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 14:17:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com, kay.sievers@vrfy.org, wfg@linux.intel.com


The patch titled
     Subject: printk-add-generic-functions-to-find-kern_level-headers-fix
has been added to the -mm tree.  Its filename is
     printk-add-generic-functions-to-find-kern_level-headers-fix.patch

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
Subject: printk-add-generic-functions-to-find-kern_level-headers-fix

fix build error and warning

kernel/printk.c:1357: error: label at end of compound statement
kernel/printk.c:1360: warning: assignment discards qualifiers from pointer target type

Cc: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/printk.h~printk-add-generic-functions-to-find-kern_level-headers-fix include/linux/printk.h
diff -puN kernel/printk.c~printk-add-generic-functions-to-find-kern_level-headers-fix kernel/printk.c
--- a/kernel/printk.c~printk-add-generic-functions-to-find-kern_level-headers-fix
+++ a/kernel/printk.c
@@ -1355,9 +1355,10 @@ asmlinkage int vprintk_emit(int facility
 		case 'd':	/* KERN_DEFAULT */
 			prefix = true;
 		case 'c':	/* KERN_CONT */
+			break;
 		}
-		text_len -=  end_of_header - text;
-		text = end_of_header;
+		text_len -= end_of_header - text;
+		text = (char *)end_of_header;
 	}
 
 	if (level == -1)
_
Subject: Subject: printk-add-generic-functions-to-find-kern_level-headers-fix

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

