From: akpm@linux-foundation.org
Subject: + memcg-prevent-from-oom-with-too-many-dirty-pages-fix.patch added to -mm tree
Date: Tue, 19 Jun 2012 15:00:26 -0700
Message-ID: <20120619220027.14CD3A0123@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56252 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab2FSWA2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jun 2012 18:00:28 -0400
Received: by vcbfl13 with SMTP id fl13so601736vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Jun 2012 15:00:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com, gthelen@google.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujtisu.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, yinghan@google.com


The patch titled
     Subject: memcg-prevent-from-oom-with-too-many-dirty-pages-fix
has been added to the -mm tree.  Its filename is
     memcg-prevent-from-oom-with-too-many-dirty-pages-fix.patch

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
Subject: memcg-prevent-from-oom-with-too-many-dirty-pages-fix

Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~memcg-prevent-from-oom-with-too-many-dirty-pages-fix mm/vmscan.c
--- a/mm/vmscan.c~memcg-prevent-from-oom-with-too-many-dirty-pages-fix
+++ a/mm/vmscan.c
@@ -726,8 +726,8 @@ static unsigned long shrink_page_list(st
 			 * writeback from reclaim and there is nothing else to
 			 * reclaim.
 			 */
-			if (PageReclaim(page)
-					&& may_enter_fs && !global_reclaim(sc))
+			if (!global_reclaim(sc) && PageReclaim(page) &&
+					may_enter_fs)
 				wait_on_page_writeback(page);
 			else {
 				nr_writeback++;
_
Subject: Subject: memcg-prevent-from-oom-with-too-many-dirty-pages-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-power-power_supply_corec-partially-fix.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
memcg-prevent-from-oom-with-too-many-dirty-pages-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
backlight-l4f00242t03-use-devm_gpio_request_one-fix.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

