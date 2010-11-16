From: akpm@linux-foundation.org
Subject: [merged] drivers-macintosh-adb-iopc-flags-should-be-unsigned-long.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:29:55 -0800
Message-ID: <201011161933.oAGJX7UU003075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756322Ab0KPTdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     drivers/macintosh/adb-iop.c: flags should be unsigned long
has been removed from the -mm tree.  Its filename was
     drivers-macintosh-adb-iopc-flags-should-be-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/macintosh/adb-iop.c: flags should be unsigned long
=46rom: Geert Uytterhoeven <geert@linux-m68k.org>

drivers/macintosh/adb-iop.c: In function `adb_iop_complete':
drivers/macintosh/adb-iop.c:85: warning: comparison of distinct pointer=
 types lacks a cast
drivers/macintosh/adb-iop.c:92: warning: comparison of distinct pointer=
 types lacks a cast
drivers/macintosh/adb-iop.c: In function =A1adb_iop_listen=A2:
drivers/macintosh/adb-iop.c:111: warning: comparison of distinct pointe=
r types lacks a cast
drivers/macintosh/adb-iop.c:151: warning: comparison of distinct pointe=
r types lacks a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/adb-iop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/macintosh/adb-iop.c~drivers-macintosh-adb-iopc-flags-=
should-be-unsigned-long drivers/macintosh/adb-iop.c
--- a/drivers/macintosh/adb-iop.c~drivers-macintosh-adb-iopc-flags-shou=
ld-be-unsigned-long
+++ a/drivers/macintosh/adb-iop.c
@@ -80,7 +80,7 @@ static void adb_iop_end_req(struct adb_r
 static void adb_iop_complete(struct iop_msg *msg)
 {
 	struct adb_request *req;
-	uint flags;
+	unsigned long flags;
=20
 	local_irq_save(flags);
=20
@@ -103,7 +103,7 @@ static void adb_iop_listen(struct iop_ms
 {
 	struct adb_iopmsg *amsg =3D (struct adb_iopmsg *) msg->message;
 	struct adb_request *req;
-	uint flags;
+	unsigned long flags;
 #ifdef DEBUG_ADB_IOP
 	int i;
 #endif
_

Patches currently in -mm which might be from geert@linux-m68k.org are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
