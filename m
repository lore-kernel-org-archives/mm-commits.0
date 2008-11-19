From: akpm@linux-foundation.org
Subject: + w1-omap-fix-omap-ldp-boot-crash.patch added to -mm tree
Date: Wed, 19 Nov 2008 11:25:00 -0800
Message-ID: <200811191925.mAJJP0C9028872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632AbYKSTZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 14:25:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stanley.miao@windriver.com, zbr@ioremap.net


The patch titled
     W1 OMAP: Fix OMAP LDP boot crash
has been added to the -mm tree.  Its filename is
     w1-omap-fix-omap-ldp-boot-crash.patch

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
Subject: W1 OMAP: Fix OMAP LDP boot crash
From: "Stanley.Miao" <stanley.miao@windriver.com>

OMAP LDP boot crash.  This is because w1 subsystem changed the search
interface, so update omap_hdq's search interface to follow the change.

Signed-off-by: Stanley.Miao <stanley.miao@windriver.com>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/w1/masters/omap_hdq.c~w1-omap-fix-omap-ldp-boot-crash drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-omap-fix-omap-ldp-boot-crash
+++ a/drivers/w1/masters/omap_hdq.c
@@ -86,8 +86,8 @@ static struct platform_driver omap_hdq_d
 static u8 omap_w1_read_byte(void *_hdq);
 static void omap_w1_write_byte(void *_hdq, u8 byte);
 static u8 omap_w1_reset_bus(void *_hdq);
-static void omap_w1_search_bus(void *_hdq, u8 search_type,
-	w1_slave_found_callback slave_found);
+static void omap_w1_search_bus(void *_hdq, struct w1_master *master_dev,
+		u8 search_type,	w1_slave_found_callback slave_found);
 
 
 static struct w1_bus_master omap_w1_master = {
@@ -231,8 +231,8 @@ static u8 omap_w1_reset_bus(void *_hdq)
 }
 
 /* W1 search callback function */
-static void omap_w1_search_bus(void *_hdq, u8 search_type,
-	w1_slave_found_callback slave_found)
+static void omap_w1_search_bus(void *_hdq, struct w1_master *master_dev,
+		u8 search_type, w1_slave_found_callback slave_found)
 {
 	u64 module_id, rn_le, cs, id;
 
@@ -249,7 +249,7 @@ static void omap_w1_search_bus(void *_hd
 	cs = w1_calc_crc8((u8 *)&rn_le, 7);
 	id = (cs << 56) | module_id;
 
-	slave_found(_hdq, id);
+	slave_found(master_dev, id);
 }
 
 static int _omap_hdq_reset(struct hdq_data *hdq_data)
_

Patches currently in -mm which might be from stanley.miao@windriver.com are

w1-omap-fix-omap-ldp-boot-crash.patch

