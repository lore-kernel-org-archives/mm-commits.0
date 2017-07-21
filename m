From: akpm@linux-foundation.org
Subject: [alternative-merged]
 kbuild-disable-wformat-truncation-warnings-by-default.patch removed from
 -mm tree
Date: Fri, 21 Jul 2017 14:57:54 -0700
Message-ID: <597278e2.rXNN82jTNf57dpwv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752811AbdGUV5y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 17:57:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: disable -Wformat-truncation warnings by default
has been removed from the -mm tree.  Its filename was
     kbuild-disable-wformat-truncation-warnings-by-default.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kbuild: disable -Wformat-truncation warnings by default

With x86 allmodconfig, we currently get 233 -Wformat-truncation warnings,
which makes the entire warnings rather useless.

This turns off the warning by default, unless we specify W=1 or higher

Link: http://lkml.kernel.org/r/20170714120720.906842-2-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.extrawarn |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/Makefile.extrawarn~kbuild-disable-wformat-truncation-warnings-by-default scripts/Makefile.extrawarn
--- a/scripts/Makefile.extrawarn~kbuild-disable-wformat-truncation-warnings-by-default
+++ a/scripts/Makefile.extrawarn
@@ -67,5 +67,8 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 KBUILD_CFLAGS += $(call cc-disable-warning, sign-compare)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-zero-length)
 KBUILD_CFLAGS += $(call cc-disable-warning, uninitialized)
+else
+# noisy gcc-7 warnings
+KBUILD_CFLAGS += $(call cc-option,-Wformat-truncation=0)
 endif
 endif
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
hwmon-applesmc-fix-format-string-overflow.patch
platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

