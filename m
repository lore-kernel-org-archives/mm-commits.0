From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch added to -mm tree
Date: Mon, 22 Oct 2012 15:30:49 -0700
Message-ID: <20121022223050.8F80E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:34676 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab2JVWax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 18:30:53 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so190252wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 15:30:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Milo.Kim@ti.com, bryan.wu@canonical.com, milo.kim@ti.com, rpurdie@rpsys.net, thierry.reding@avionic-design.de


The patch titled
     Subject: drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch

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
Subject: drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix

coding-style simplification, per Thierry

Cc: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
Cc: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -139,7 +139,10 @@ static void lp855x_pwm_ctrl(struct lp855
 	}
 
 	pwm_config(lp->pwm, duty, period);
-	duty == 0 ? pwm_disable(lp->pwm) : pwm_enable(lp->pwm);
+	if (duty)
+		pwm_enable(lp->pwm);
+	else
+		pwm_disable(lp->pwm);
 }
 
 static int lp855x_bl_update_status(struct backlight_device *bl)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

