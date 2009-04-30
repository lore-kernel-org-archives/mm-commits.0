From: akpm@linux-foundation.org
Subject: [merged] uvcvideo-prevent-information-loss-with-removing-implicit-casting.patch removed from -mm tree
Date: Thu, 30 Apr 2009 11:44:13 -0700
Message-ID: <200904301844.n3UIiDsc002337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763357AbZD3Sr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 14:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nm127@freemail.hu, laurent.pinchart@skynet.be, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     uvcvideo: prevent information loss with removing implicit casting
has been removed from the -mm tree.  Its filename was
     uvcvideo-prevent-information-loss-with-removing-implicit-casting.p=
atch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: uvcvideo: prevent information loss with removing implicit cast=
ing
=46rom: N=E9meth M=E1rton <nm127@freemail.hu>

The uvcvideo driver supports only one input, which is input 0.  For all
other input index the return value shall be EINVAL.  This patch fixes t=
he
problem when the value 0x80000000 was incorrectly casted and treated as=
 a
zero value.

The patch was tested with v4l-test 0.10 [2] with CNF7129 webcam found o=
n
EeePC 901.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/r11217.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: N=E9meth M=E1rton <nm127@freemail.hu>
Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/uvc/uvc_v4l2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/uvc/uvc_v4l2.c~uvcvideo-prevent-informati=
on-loss-with-removing-implicit-casting drivers/media/video/uvc/uvc_v4l2=
=2Ec
--- a/drivers/media/video/uvc/uvc_v4l2.c~uvcvideo-prevent-information-l=
oss-with-removing-implicit-casting
+++ a/drivers/media/video/uvc/uvc_v4l2.c
@@ -648,7 +648,7 @@ static long uvc_v4l2_do_ioctl(struct fil
=20
 	case VIDIOC_S_INPUT:
 	{
-		u8 input =3D *(u32 *)arg + 1;
+		u32 input =3D *(u32 *)arg + 1;
=20
 		if ((ret =3D uvc_acquire_privileges(handle)) < 0)
 			return ret;
_

Patches currently in -mm which might be from nm127@freemail.hu are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
