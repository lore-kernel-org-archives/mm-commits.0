From: akpm@linux-foundation.org
Subject: - bttv-uses-input-functions-should-depend-on-input.patch removed from -mm tree
Date: Tue, 30 Oct 2007 13:35:51 -0700
Message-ID: <200710302035.l9UKZp3w026925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbXJ3Ug5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dtor@mail.ru, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     bttv: uses input functions, should depend on INPUT
has been removed from the -mm tree.  Its filename was
     bttv-uses-input-functions-should-depend-on-input.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: bttv: uses input functions, should depend on INPUT
From: Randy Dunlap <randy.dunlap@oracle.com>

Several media drivers use input_(*) functions so they need to depend on
the INPUT config symbol.

drivers/built-in.o: In function `bttv_input_fini':
linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/bttv-input.c:346: undefined reference to `input_unregister_device'
drivers/built-in.o: In function `bttv_input_init':
linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/bttv-input.c:204: undefined reference to `input_allocate_device'
linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/bttv-input.c:335: undefined reference to `input_free_device'
linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/bttv-input.c:321: undefined reference to `input_register_device'
linux-2.6.24-rc1-git4/drivers/media/video/bt8xx/bttv-input.c:335: undefined reference to `input_free_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bt8xx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/bt8xx/Kconfig~bttv-uses-input-functions-should-depend-on-input drivers/media/video/bt8xx/Kconfig
--- a/drivers/media/video/bt8xx/Kconfig~bttv-uses-input-functions-should-depend-on-input
+++ a/drivers/media/video/bt8xx/Kconfig
@@ -22,7 +22,7 @@ config VIDEO_BT848
 
 config VIDEO_BT848_DVB
 	bool "DVB/ATSC Support for bt878 based TV cards"
-	depends on VIDEO_BT848 && DVB_CORE
+	depends on VIDEO_BT848 && DVB_CORE && INPUT
 	select DVB_BT8XX
 	---help---
 	  This adds support for DVB/ATSC cards based on the BT878 chip.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
bttv-uses-input-functions-should-depend-on-input.patch
git-kbuild.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
register_cpu-__devinit-or-__cpuinit.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
