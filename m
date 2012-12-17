From: akpm@linux-foundation.org
Subject: [folded-merged] backlight-add-of_find_backlight_by_node-function-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:43:16 -0800
Message-ID: <20121217234316.A98F0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:33521 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2LQXnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:43:17 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so713673qcq.5
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:43:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jg1.han@samsung.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-of_find_backlight_by_node-function-fix
has been removed from the -mm tree.  Its filename was
     backlight-add-of_find_backlight_by_node-function-fix.patch

This patch was dropped because it was folded into backlight-add-of_find_backlight_by_node-function.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-add-of_find_backlight_by_node-function-fix

Don't use IS_ENABLED(CONFIG_OF)

Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    2 +-
 include/linux/backlight.h           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-add-of_find_backlight_by_node-function-fix drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-add-of_find_backlight_by_node-function-fix
+++ a/drivers/video/backlight/backlight.c
@@ -370,7 +370,7 @@ void backlight_device_unregister(struct 
 }
 EXPORT_SYMBOL(backlight_device_unregister);
 
-#if IS_ENABLED(CONFIG_OF)
+#ifdef CONFIG_OF
 static int of_parent_match(struct device *dev, void *data)
 {
 	return dev->parent && dev->parent->of_node == data;
diff -puN include/linux/backlight.h~backlight-add-of_find_backlight_by_node-function-fix include/linux/backlight.h
--- a/include/linux/backlight.h~backlight-add-of_find_backlight_by_node-function-fix
+++ a/include/linux/backlight.h
@@ -134,7 +134,7 @@ struct generic_bl_info {
 	void (*kick_battery)(void);
 };
 
-#if IS_ENABLED(CONFIG_OF)
+#ifdef CONFIG_OF
 struct backlight_device *of_find_backlight_by_node(struct device_node *node);
 #else
 static inline struct backlight_device *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
create-non-empty-arch-x86-include-uapi-asm-files.patch
mm-memoryc-suppress-warning.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch

