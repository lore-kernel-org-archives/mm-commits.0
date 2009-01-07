From: akpm@linux-foundation.org
Subject: - autodetect_raid-add-missing-__init-marking.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:35 -0800
Message-ID: <200901072215.n07MFZmb015379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761943AbZAGWPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     autodetect_raid: add missing __init marking
has been removed from the -mm tree.  Its filename was
     autodetect_raid-add-missing-__init-marking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

