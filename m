From: akpm@linux-foundation.org
Subject: + viafb-fix-crash-due-to-4k-stack-overflow.patch added to -mm tree
Date: Sun, 09 Nov 2008 14:54:22 -0800
Message-ID: <200811092254.mA9MsMqU031914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755869AbYKIWyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 9 Nov 2008 17:54:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bonbons@linux-vserver.org, JosephChan@via.com.tw, krzysztof.h1@poczta.fm


The patch titled
     viafb: fix crash due to 4k stack overflow
has been added to the -mm tree.  Its filename is
     viafb-fix-crash-due-to-4k-stack-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: viafb: fix crash due to 4k stack overflow
=46rom: Bruno Pr=E9mont <bonbons@linux-vserver.org>

The function viafb_cursor() uses 2 stack-variables of CURSOR_SIZE bits;
CURSOR_SIZE is defined as (8 * 1024).  Using up twice 1k on stack is to=
o
much for 4k-stack (though it works with 8k-stacks).

Make those two variables kzalloc'ed to preserve stack space.

Signed-off-by: Bruno Pr=E9mont <bonbons@linux-vserver.org>
Cc: <JosephChan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-fix-crash-due-to-4k-stack-=
overflow drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-fix-crash-due-to-4k-stack-over=
flow
+++ a/drivers/video/via/viafbdev.c
@@ -1052,10 +1052,8 @@ static void viafb_imageblit(struct fb_in
=20
 static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor=
)
 {
-	u8 data[CURSOR_SIZE / 8];
-	u32 data_bak[CURSOR_SIZE / 32];
 	u32 temp, xx, yy, bg_col =3D 0, fg_col =3D 0;
-	int size, i, j =3D 0;
+	int i, j =3D 0;
 	static int hw_cursor;
 	struct viafb_par *p_viafb_par;
=20
@@ -1178,10 +1176,15 @@ static int viafb_cursor(struct fb_info *
 	}
=20
 	if (cursor->set & FB_CUR_SETSHAPE) {
-		size =3D
+		u8 *data =3D kzalloc(CURSOR_SIZE / 8, GFP_ATOMIC);
+		u32 *data_bak =3D kzalloc(CURSOR_SIZE / 32, GFP_ATOMIC);
+		int size =3D
 		    ((viacursor.image.width + 7) >> 3) *
 		    viacursor.image.height;
=20
+		if (data =3D=3D NULL || data_bak =3D=3D NULL)
+			goto out;
+
 		if (MAX_CURS =3D=3D 32) {
 			for (i =3D 0; i < (CURSOR_SIZE / 32); i++) {
 				data_bak[i] =3D 0x0;
@@ -1231,6 +1234,9 @@ static int viafb_cursor(struct fb_info *
 		memcpy(((struct viafb_par *)(info->par))->fbmem_virt +
 		       ((struct viafb_par *)(info->par))->cursor_start,
 		       data_bak, CURSOR_SIZE);
+out:
+		kfree(data);
+		kfree(data_bak);
 	}
=20
 	if (viacursor.enable)
_

Patches currently in -mm which might be from bonbons@linux-vserver.org =
are

viafb-fix-crash-due-to-4k-stack-overflow.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
