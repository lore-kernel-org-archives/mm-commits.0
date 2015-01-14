From: akpm@linux-foundation.org
Subject: + rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch added to -mm tree
Date: Wed, 14 Jan 2015 14:53:50 -0800
Message-ID: <54b6f37e./8Otm8hTjUnFKMaR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbANWxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jan 2015 17:53:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, dianders@chromium.org, heiko@sntech.de, sonnyrao@chromium.org, zyw@rock-chips.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-rk808-fix-the-rtc-time-reading-issue-fix
has been added to the -mm tree.  Its filename is
     rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rk808-fix-the-rtc-time=
-reading-issue-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rk808-fix-the-rtc-time=
-reading-issue-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-rk808-fix-the-rtc-time-reading-issue-fix

tweak comment per review discussion

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Chris Zhong <zyw@rock-chips.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Heiko St=FCbner <heiko@sntech.de>
Cc: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rk808.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-rk808.c~rtc-rk808-fix-the-rtc-time-reading-is=
sue-fix drivers/rtc/rtc-rk808.c
--- a/drivers/rtc/rtc-rk808.c~rtc-rk808-fix-the-rtc-time-reading-issue-=
fix
+++ a/drivers/rtc/rtc-rk808.c
@@ -73,10 +73,11 @@ static int rk808_rtc_readtime(struct dev
 		return ret;
 	}
=20
-	/* After we set the GET_TIME bit, the rtc time couldn't be read
-	 * immediately, we should wait up to 31.25 us, about one cycle of
+	/*
+	 * After we set the GET_TIME bit, the rtc time can't be read
+	 * immediately. So we should wait up to 31.25 us, about one cycle of
 	 * 32khz. If we clear the GET_TIME bit here, the time of i2c transfer
-	 * certainly more than 31.25us.
+	 * certainly more than 31.25us: 16 * 2.5us at 400kHz bus frequency.
 	 */
 	ret =3D regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
 				 BIT_RTC_CTRL_REG_RTC_GET_TIME,
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed=
-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpat=
ch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-hand=
ler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-hand=
ler-fix-2.patch
dax-add-dax_zero_page_range-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.p=
atch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.p=
atch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
