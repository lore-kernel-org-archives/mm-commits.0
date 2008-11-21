From: akpm@linux-foundation.org
Subject: + autodetect_raid-add-missing-__init-marking.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:35:14 -0800
Message-ID: <200811212035.mALKZEOq030159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751AbYKUUfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:35:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     autodetect_raid: add missing __init marking
has been added to the -mm tree.  Its filename is
     autodetect_raid-add-missing-__init-marking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autodetect_raid: add missing __init marking
From: Mike Frysinger <vapier@gentoo.org>

The function autodetect_raid is only used by __init functions, and it refers
to __initdata, so it needs __init markings.  Fixes this error:
The function autodetect_raid() references
the variable __initdata raid_noautodetect.
This is often because autodetect_raid lacks a __initdata
annotation or the annotation of raid_noautodetect is wrong.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/do_mounts_md.c~autodetect_raid-add-missing-__init-marking init/do_mounts_md.c
--- a/init/do_mounts_md.c~autodetect_raid-add-missing-__init-marking
+++ a/init/do_mounts_md.c
@@ -271,7 +271,7 @@ static int __init raid_setup(char *str)
 __setup("raid=", raid_setup);
 __setup("md=", md_setup);
 
-static void autodetect_raid(void)
+static void __init autodetect_raid(void)
 {
 	int fd;
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
linux-timexh-cleanup-for-userspace.patch
mtd-physmap-make-physmap-compat-explicit.patch
m25p80-fix-detection-of-spi-parts.patch
m25p80-fix-detection-of-m25p16-flashes.patch
linux-serialh-touchup-for-userspace.patch
autodetect_raid-add-missing-__init-marking.patch

