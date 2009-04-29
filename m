From: akpm@linux-foundation.org
Subject: [merged] input-bcm5974-declare-alignment-usage.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:17:43 -0700
Message-ID: <200904291917.n3TJHhXQ030673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbZD2T1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:27:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: bcm5974: declare alignment usage
has been removed from the -mm tree.  Its filename was
     input-bcm5974-declare-alignment-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: bcm5974: declare alignment usage
From: "Henrik Rydberg" <rydberg@euromail.se>

Add struct alignment information and add comments to ensure all access of
finger data is two-byte aligned.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/bcm5974.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/input/mouse/bcm5974.c~input-bcm5974-declare-alignment-usage drivers/input/mouse/bcm5974.c
--- a/drivers/input/mouse/bcm5974.c~input-bcm5974-declare-alignment-usage
+++ a/drivers/input/mouse/bcm5974.c
@@ -110,17 +110,17 @@ enum tp_type {
 	TYPE2			/* button integrated in trackpad */
 };
 
-/* trackpad finger data offsets */
-#define FINGER_TYPE1		26
-#define FINGER_TYPE2		30
+/* trackpad finger data offsets, le16-aligned */
+#define FINGER_TYPE1		(13 * sizeof(__le16))
+#define FINGER_TYPE2		(15 * sizeof(__le16))
 
-/* trackpad button data offsets */
+/* trackpad button data offsets, u8-aligned */
 #define BUTTON_TYPE2		15
 
 /* integrated button capability by configuration */
 #define HAS_INTEGRATED_BUTTON(c)	(c->tp_type == TYPE2)
 
-/* trackpad finger structure */
+/* trackpad finger structure, le16-aligned */
 struct tp_finger {
 	__le16 origin;		/* zero when switching track finger */
 	__le16 abs_x;		/* absolute x coodinate */
@@ -134,7 +134,7 @@ struct tp_finger {
 	__le16 force_minor;	/* trackpad force, minor axis? */
 	__le16 unused[3];	/* zeros */
 	__le16 multi;		/* one finger: varies, more fingers: constant */
-};
+} __attribute__((packed, aligned(2)));
 
 /* trackpad finger data size, empirically at least ten fingers */
 #define SIZEOF_FINGER		sizeof(struct tp_finger)
@@ -321,6 +321,7 @@ static int report_tp_state(struct bcm597
 	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
 		return -EIO;
 
+	/* finger data, le16-aligned */
 	f = (const struct tp_finger *)(dev->tp_data + c->tp_offset);
 	raw_n = (size - c->tp_offset) / SIZEOF_FINGER;
 
_

Patches currently in -mm which might be from rydberg@euromail.se are

linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

