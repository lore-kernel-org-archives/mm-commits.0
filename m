From: akpm@linux-foundation.org
Subject: + make-swapin-readahead-skip-over-holes-fix.patch added to -mm tree
Date: Wed, 25 Jan 2012 17:23:33 -0800
Message-ID: <20120126012333.DCD10A0245@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:35245 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2AZBXe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2012 20:23:34 -0500
Received: by mail-qy0-f202.google.com with SMTP id d17so9297qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2012 17:23:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, kosaki.motohiro@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, z@drze.net


The patch titled
     Subject: make-swapin-readahead-skip-over-holes-fix
has been added to the -mm tree.  Its filename is
     make-swapin-readahead-skip-over-holes-fix.patch

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
Subject: make-swapin-readahead-skip-over-holes-fix

fix it for page_cluster >= 32

Cc: Adrian Drzewieki <z@drze.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_state.c~make-swapin-readahead-skip-over-holes-fix mm/swap_state.c
--- a/mm/swap_state.c~make-swapin-readahead-skip-over-holes-fix
+++ a/mm/swap_state.c
@@ -385,7 +385,7 @@ struct page *swapin_readahead(swp_entry_
 	struct page *page;
 	unsigned long offset = swp_offset(entry);
 	unsigned long start_offset, end_offset;
-	unsigned long mask = (1 << page_cluster) - 1;
+	unsigned long mask = (1UL << page_cluster) - 1;
 
 	/* Read a page_cluster sized and aligned cluster around offset. */
 	start_offset = offset & ~mask;
_
Subject: Subject: make-swapin-readahead-skip-over-holes-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

