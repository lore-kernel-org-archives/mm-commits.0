From: akpm@linux-foundation.org
Subject: + drivers-media-video-videobuf-dma-sgc-avoid-clearing-memory-twice.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:16:06 -0700
Message-ID: <200806302116.m5ULG9MY025778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbYF3VQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaillet.christophe@wanadoo.fr, mchehab@infradead.org


The patch titled
     drivers/media/video/videobuf-dma-sg.c: avoid clearing memory twice
has been added to the -mm tree.  Its filename is
     drivers-media-video-videobuf-dma-sgc-avoid-clearing-memory-twice.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/media/video/videobuf-dma-sg.c: avoid clearing memory t=
wice
=46rom: Christophe Jaillet <jaillet.christophe@wanadoo.fr>

1) Remove a useless initialisation of 'i'

2) Avoid clearing the memory allocated twice (once in 'kcalloc', once
   in 'sg_init_table')

3) Remove a test that can never trigger.  The function returns NULL in
   such a case, so we know that at this point '=EF=BB=BFpages[0]' !=3D =
NULL

Signed-off-by: Christophe Jaillet <jaillet.christophe@wanadoo.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/videobuf-dma-sg.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/videobuf-dma-sg.c~drivers-media-video-vid=
eobuf-dma-sgc-avoid-clearing-memory-twice drivers/media/video/videobuf-=
dma-sg.c
--- a/drivers/media/video/videobuf-dma-sg.c~drivers-media-video-videobu=
f-dma-sgc-avoid-clearing-memory-twice
+++ a/drivers/media/video/videobuf-dma-sg.c
@@ -80,17 +80,15 @@ struct scatterlist*
 videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
 {
 	struct scatterlist *sglist;
-	int i =3D 0;
+	int i;
=20
 	if (NULL =3D=3D pages[0])
 		return NULL;
-	sglist =3D kcalloc(nr_pages, sizeof(*sglist), GFP_KERNEL);
+	sglist =3D kmalloc(nr_pages * sizeof(*sglist), GFP_KERNEL);
 	if (NULL =3D=3D sglist)
 		return NULL;
 	sg_init_table(sglist, nr_pages);
=20
-	if (NULL =3D=3D pages[0])
-		goto nopage;
 	if (PageHighMem(pages[0]))
 		/* DMA to highmem pages might not work */
 		goto highmem;
_

Patches currently in -mm which might be from jaillet.christophe@wanadoo=
=2Efr are

drivers-media-video-videobuf-dma-sgc-avoid-clearing-memory-twice.patch
drivers-block-pktcdvdc-avoid-useless-memset.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
