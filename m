From: akpm@linux-foundation.org
Subject: [merged] bttv-add-another-id-for-ivc-200.patch removed from -mm tree
Date: Thu, 06 May 2010 12:09:08 -0400
Message-ID: <201005061910.o46JAcCl008542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027Ab0EFTLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirr@mns.spb.ru, hverkuil@xs4all.nl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     bttv: add another ID for IVC-200
has been removed from the -mm tree.  Its filename was
     bttv-add-another-id-for-ivc-200.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bttv: add another ID for IVC-200
From: Kirill Smelkov <kirr@mns.spb.ru>

I have 3 IVC-200 cards (with 4 video channels on each).

2 of the cards identify theirselves as 000[0-3]:a155 (ids already in
cardlist) and another one identifies itself as 080[0-3]:a155, which ids
were unknown so far.

Note - it's IVC-200, not IVC-200G.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/video4linux/CARDLIST.bttv |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c  |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN Documentation/video4linux/CARDLIST.bttv~bttv-add-another-id-for-ivc-200 Documentation/video4linux/CARDLIST.bttv
--- a/Documentation/video4linux/CARDLIST.bttv~bttv-add-another-id-for-ivc-200
+++ a/Documentation/video4linux/CARDLIST.bttv
@@ -100,7 +100,7 @@
  99 -> AD-TVK503
 100 -> Hercules Smart TV Stereo
 101 -> Pace TV & Radio Card
-102 -> IVC-200                                             [0000:a155,0001:a155,0002:a155,0003:a155,0100:a155,0101:a155,0102:a155,0103:a155]
+102 -> IVC-200                                             [0000:a155,0001:a155,0002:a155,0003:a155,0100:a155,0101:a155,0102:a155,0103:a155,0800:a155,0801:a155,0802:a155,0803:a155]
 103 -> Grand X-Guard / Trust 814PCI                        [0304:0102]
 104 -> Nebula Electronics DigiTV                           [0071:0101]
 105 -> ProVideo PV143                                      [aa00:1430,aa00:1431,aa00:1432,aa00:1433,aa03:1433]
diff -puN drivers/media/video/bt8xx/bttv-cards.c~bttv-add-another-id-for-ivc-200 drivers/media/video/bt8xx/bttv-cards.c
--- a/drivers/media/video/bt8xx/bttv-cards.c~bttv-add-another-id-for-ivc-200
+++ a/drivers/media/video/bt8xx/bttv-cards.c
@@ -241,6 +241,10 @@ static struct CARD {
 	{ 0xa1550101, BTTV_BOARD_IVC200,        "IVC-200G" },
 	{ 0xa1550102, BTTV_BOARD_IVC200,        "IVC-200G" },
 	{ 0xa1550103, BTTV_BOARD_IVC200,        "IVC-200G" },
+	{ 0xa1550800, BTTV_BOARD_IVC200,        "IVC-200"  },
+	{ 0xa1550801, BTTV_BOARD_IVC200,        "IVC-200"  },
+	{ 0xa1550802, BTTV_BOARD_IVC200,        "IVC-200"  },
+	{ 0xa1550803, BTTV_BOARD_IVC200,        "IVC-200"  },
 	{ 0xa182ff00, BTTV_BOARD_IVC120,        "IVC-120G" },
 	{ 0xa182ff01, BTTV_BOARD_IVC120,        "IVC-120G" },
 	{ 0xa182ff02, BTTV_BOARD_IVC120,        "IVC-120G" },
_

Patches currently in -mm which might be from kirr@mns.spb.ru are

linux-next.patch

