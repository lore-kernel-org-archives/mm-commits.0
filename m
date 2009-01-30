From: akpm@linux-foundation.org
Subject: + input-bcm5974-declare-alignment-usage.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:19:21 -0800
Message-ID: <200901302119.n0ULJM5H020744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160AbZA3VTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:19:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, dtor@mail.ru


The patch titled
     input: bcm5974: declare alignment usage
has been added to the -mm tree.  Its filename is
     input-bcm5974-declare-alignment-usage.patch

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
Subject: input: bcm5974: declare alignment usage
From: "Henrik Rydberg" <rydberg@euromail.se>

Add struct alignment information and add comments to ensure all access of
finger data is two-byte aligned.

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
+} __attribute__((packed,aligned(2)));
 
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

origin.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
input-bcm5974-prepare-for-a-new-trackpad-header-type.patch
input-bcm5974-add-quad-finger-tapping.patch
input-bcm5974-add-support-for-the-macbook-5-unibody.patch
input-bcm5974-augmented-debug-information.patch
input-bcm5974-declare-alignment-usage.patch
input-allow-certain-ev_abs-events-to-bypass-all-filtering.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-add-a-detailed-multi-touch-finger-data-report-protocol-rev2.patch

