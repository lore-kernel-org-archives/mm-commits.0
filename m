From: akpm@linux-foundation.org
Subject: [merged]
 config-android-move-device-mapper-options-to-recommended.patch removed from -mm tree
Date: Wed, 12 Oct 2016 12:25:29 -0700
Message-ID: <57fe8e29.BY/ADUjwHL9wCRij%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33425 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755970AbcJLTZa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:25:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robh@kernel.org, amit.pundir@linaro.org, dimitrysh@google.com, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: config: android: move device mapper options to recommended
has been removed from the -mm tree.  Its filename was
     config-android-move-device-mapper-options-to-recommended.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rob Herring <robh@kernel.org>
Subject: config: android: move device mapper options to recommended

CONFIG_MD is in recommended, but other dependent options like DM_CRYPT and
DM_VERITY options are in base.  The result is the options in base don't
get enabled when applying both base and recommended fragments.  Move all
the options to recommended.

Link: http://lkml.kernel.org/r/20160908185934.18098-1-robh@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Amit Pundir <amit.pundir@linaro.org>
Cc: Dmitry Shmidt <dimitrysh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/android-base.config        |    4 ----
 kernel/configs/android-recommended.config |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/configs/android-base.config~config-android-move-device-mapper-options-to-recommended kernel/configs/android-base.config
--- a/kernel/configs/android-base.config~config-android-move-device-mapper-options-to-recommended
+++ a/kernel/configs/android-base.config
@@ -11,7 +11,6 @@ CONFIG_ANDROID_LOW_MEMORY_KILLER=y
 CONFIG_ARMV8_DEPRECATED=y
 CONFIG_ASHMEM=y
 CONFIG_AUDIT=y
-CONFIG_BLK_DEV_DM=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_CPUACCT=y
@@ -19,9 +18,6 @@ CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_CP15_BARRIER_EMULATION=y
-CONFIG_DM_CRYPT=y
-CONFIG_DM_VERITY=y
-CONFIG_DM_VERITY_FEC=y
 CONFIG_EMBEDDED=y
 CONFIG_FB=y
 CONFIG_HIGH_RES_TIMERS=y
diff -puN kernel/configs/android-recommended.config~config-android-move-device-mapper-options-to-recommended kernel/configs/android-recommended.config
--- a/kernel/configs/android-recommended.config~config-android-move-device-mapper-options-to-recommended
+++ a/kernel/configs/android-recommended.config
@@ -6,12 +6,16 @@
 # CONFIG_PM_WAKELOCKS_GC is not set
 # CONFIG_VT is not set
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_BLK_DEV_DM=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=8192
 CONFIG_COMPACTION=y
 CONFIG_DEBUG_RODATA=y
+CONFIG_DM_CRYPT=y
 CONFIG_DM_UEVENT=y
+CONFIG_DM_VERITY=y
+CONFIG_DM_VERITY_FEC=y
 CONFIG_DRAGONRISE_FF=y
 CONFIG_ENABLE_DEFAULT_TRACERS=y
 CONFIG_EXT4_FS=y
_

Patches currently in -mm which might be from robh@kernel.org are


