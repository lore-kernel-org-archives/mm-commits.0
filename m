From: akpm@linux-foundation.org
Subject: - leds-fix-unsigned-value-overflow-in-for-loop.patch removed from -mm tree
Date: Mon, 02 Jun 2008 13:00:56 -0700
Message-ID: <200806022000.m52K0uXF030114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945AbYFBUBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 16:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     leds: fix unsigned value overflow in for loop
has been removed from the -mm tree.  Its filename was
     leds-fix-unsigned-value-overflow-in-for-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: fix unsigned value overflow in for loop
From: Li Zefan <lizf@cn.fujitsu.com>

Fix the following unsigned variable overflow:
	unsigned i;
	for (i = n; i >= 0; i--)
	...

It won't break anything to use type 'int'.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-atmel-pwm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-atmel-pwm.c~leds-fix-unsigned-value-overflow-in-for-loop drivers/leds/leds-atmel-pwm.c
--- a/drivers/leds/leds-atmel-pwm.c~leds-fix-unsigned-value-overflow-in-for-loop
+++ a/drivers/leds/leds-atmel-pwm.c
@@ -37,7 +37,7 @@ static int __init pwmled_probe(struct pl
 {
 	const struct gpio_led_platform_data	*pdata;
 	struct pwmled				*leds;
-	unsigned				i;
+	int					i;
 	int					status;
 
 	pdata = pdev->dev.platform_data;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
git-leds.patch
scsi-libiscsic-return-errno-rather-than-errno.patch
call_usermodehelper-increase-reliability.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch

