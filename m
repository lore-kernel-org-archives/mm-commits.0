From: akpm@linux-foundation.org
Subject: + slow-down-printk-during-boot-fix-4.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:56:33 -0700
Message-ID: <200708012256.l71MuXWB021682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbXHAW46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, davej@redhat.com, rdunlap@xenotime.net, schwidefsky@de.ibm.com


The patch titled
     fix slown down printk on boot compile error
has been added to the -mm tree.  Its filename is
     slow-down-printk-during-boot-fix-4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix slown down printk on boot compile error
From: Heiko Carstens <heiko.carstens@de.ibm.com>

The slow-down-printk-during-boot patch depends on preset_lpj being
available.  That's not the case for architectures that have it's own
calibrate_delay() function.

kernel/sched.c:3840: undefined reference to `preset_lpj'

Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dave Jones <davej@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~slow-down-printk-during-boot-fix-4 lib/Kconfig.debug
--- a/lib/Kconfig.debug~slow-down-printk-during-boot-fix-4
+++ a/lib/Kconfig.debug
@@ -413,7 +413,7 @@ config FORCED_INLINING
 
 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
-	depends on DEBUG_KERNEL && PRINTK
+	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
 	help
 	  This build option allows you to read kernel boot messages
 	  by inserting a short delay after each one.  The delay is
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
fix-warn_on-on-bitfield-ops-for-all-other-archs.patch
slow-down-printk-during-boot-fix-4.patch
git-wireless.patch
avoid-ssb-compililation-on-s390.patch
prevent-ssb-compilation-on-s390-part-2.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
