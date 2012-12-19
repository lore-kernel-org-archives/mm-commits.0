From: akpm@linux-foundation.org
Subject: + mm-page_allocc-__alloc_contig_migrate_range-cleanup.patch added to -mm tree
Date: Wed, 19 Dec 2012 15:27:53 -0800
Message-ID: <20121219232754.AF6A2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:38887 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2LSX15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 18:27:57 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so139334eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 15:27:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, b.zolnierkie@samsung.com, m.szyprowski@samsung.com, mina86@mina86.com


The patch titled
     Subject: mm/page_alloc.c:__alloc_contig_migrate_range(): cleanup
has been added to the -mm tree.  Its filename is
     mm-page_allocc-__alloc_contig_migrate_range-cleanup.patch

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
Subject: mm/page_alloc.c:__alloc_contig_migrate_range(): cleanup

- `ret' is always zero in the we-timed-out case

- remove a test-n-branch in the wrapup code

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-__alloc_contig_migrate_range-cleanup mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-__alloc_contig_migrate_range-cleanup
+++ a/mm/page_alloc.c
@@ -5804,7 +5804,6 @@ static int __alloc_contig_migrate_range(
 			}
 			tries = 0;
 		} else if (++tries == 5) {
-			ret = ret < 0 ? ret : -EBUSY;
 			break;
 		}
 
@@ -5817,9 +5816,11 @@ static int __alloc_contig_migrate_range(
 				    0, false, MIGRATE_SYNC,
 				    MR_CMA);
 	}
-	if (ret < 0)
+	if (ret < 0) {
 		putback_movable_pages(&cc->migratepages);
-	return ret > 0 ? 0 : ret;
+		return ret;
+	}
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
revert-rtc-recycle-id-when-unloading-a-rtc-driver.patch
sgi-xp-handle-non-fatal-traps-fix.patch
sendfile-allows-bypassing-of-notifier-events.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
mm-page_allocc-__alloc_contig_migrate_range-cleanup.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

