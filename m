From: akpm@linux-foundation.org
Subject: [merged] serial_cs-oxsemi-quirk-breaks-resume.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:33 -0800
Message-ID: <200912292132.nBTLWXEi008636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772AbZL2Vcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:32:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial_cs: oxsemi quirk breaks resume
has been removed from the -mm tree.  Its filename was
     serial_cs-oxsemi-quirk-breaks-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial_cs: oxsemi quirk breaks resume
From: Pavel Machek <pavel@ucw.cz>

Quirk is applied on all cards with given manfid (is it that correct?). 
Unfortunately, that quirk breaks resume on zaurus with billionton
bluetooth card inserted: c950ctrl is 0 and outb() faults.

I believe it is simply not a multiport card.  (info->multi == 1).  ... 
...  confirmed by printks.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_cs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_cs.c~serial_cs-oxsemi-quirk-breaks-resume drivers/serial/serial_cs.c
--- a/drivers/serial/serial_cs.c~serial_cs-oxsemi-quirk-breaks-resume
+++ a/drivers/serial/serial_cs.c
@@ -146,7 +146,8 @@ static void quirk_wakeup_oxsemi(struct p
 {
 	struct serial_info *info = link->priv;
 
-	outb(12, info->c950ctrl + 1);
+	if (info->c950ctrl)
+		outb(12, info->c950ctrl + 1);
 }
 
 /* request_region? oxsemi branch does no request_region too... */
_

Patches currently in -mm which might be from pavel@ucw.cz are

linux-next.patch

