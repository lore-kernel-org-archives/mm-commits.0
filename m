From: akpm@linux-foundation.org
Subject: - pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch removed from -mm tree
Date: Sun, 20 Jan 2008 11:41:55 -0800
Message-ID: <200801201941.m0KJfajP032528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbYATTmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 14:42:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia/3c574_cs: fix dubious bitfield warning
has been removed from the -mm tree.  Its filename was
     pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia/3c574_cs: fix dubious bitfield warning
From: Richard Knutsson <ricknu-0@student.ltu.se>

Fixing:
  CHECK   drivers/net/pcmcia/3c574_cs.c
drivers/net/pcmcia/3c574_cs.c:194:13: warning: dubious bitfield without explicit `signed' or `unsigned'
drivers/net/pcmcia/3c574_cs.c:196:14: warning: dubious bitfield without explicit `signed' or `unsigned'

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pcmcia/3c574_cs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/pcmcia/3c574_cs.c~pcmcia-3c574_cs-fix-dubious-bitfield-warning drivers/net/pcmcia/3c574_cs.c
--- a/drivers/net/pcmcia/3c574_cs.c~pcmcia-3c574_cs-fix-dubious-bitfield-warning
+++ a/drivers/net/pcmcia/3c574_cs.c
@@ -190,10 +190,10 @@ enum Window3 {			/* Window 3: MAC/config
 union wn3_config {
 	int i;
 	struct w3_config_fields {
-		unsigned int ram_size:3, ram_width:1, ram_speed:2, rom_size:2;
-		int pad8:8;
-		unsigned int ram_split:2, pad18:2, xcvr:3, pad21:1, autoselect:1;
-		int pad24:7;
+		u32 ram_size:3, ram_width:1, ram_speed:2, rom_size:2,
+		    pad8:8,
+		    ram_split:2, pad18:2, xcvr:3, pad21:1,
+		    autoselect:1, pad24:7;
 	} u;
 };
 
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

git-audit-master.patch
git-dvb.patch
pcmcia-3c574_cs-fix-dubious-bitfield-warning.patch
pcmcia-3c574_cs-fix-shadow-variable-warning.patch
pcmcia-axnet_cs-make-functions-static.patch
pcmcia-axnet_cs-make-use-of-max-instead-of-handcrafted-one.patch
pcmcia-fmvj18x_cs-fix-shadow-variable-warning.patch
pcmcia-pcnet_cs-fix-shadow-variable-warning.patch
git-selinux.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
reiserfs-complement-va_start-with-va_end.patch
kernel-paramsc-remove-sparse-warning-different-signedness.patch
