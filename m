From: akpm@linux-foundation.org
Subject: [merged] misdn-indentation-braces-disagree-add-braces.patch removed from -mm tree
Date: Tue, 13 Jan 2009 12:13:23 -0800
Message-ID: <200901132013.n0DKDN2X012523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754805AbZAMUNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 15:13:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     misdn: indentation & braces disagree - add braces
has been removed from the -mm tree.  Its filename was
     misdn-indentation-braces-disagree-add-braces.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: misdn: indentation & braces disagree - add braces
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

Nothing is broken because of this - currently.

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/dsp_cmx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/mISDN/dsp_cmx.c~misdn-indentation-braces-disagre=
e-add-braces drivers/isdn/mISDN/dsp_cmx.c
--- a/drivers/isdn/mISDN/dsp_cmx.c~misdn-indentation-braces-disagree-ad=
d-braces
+++ a/drivers/isdn/mISDN/dsp_cmx.c
@@ -1857,7 +1857,7 @@ dsp_cmx_hdlc(struct dsp *dsp, struct sk_
 		/* in case of hardware (echo) */
 		if (dsp->pcm_slot_tx >=3D 0)
 			return;
-		if (dsp->echo)
+		if (dsp->echo) {
 			nskb =3D skb_clone(skb, GFP_ATOMIC);
 			if (nskb) {
 				hh =3D mISDN_HEAD_P(nskb);
@@ -1866,6 +1866,7 @@ dsp_cmx_hdlc(struct dsp *dsp, struct sk_
 				skb_queue_tail(&dsp->sendq, nskb);
 				schedule_work(&dsp->workq);
 			}
+		}
 		return;
 	}
 	/* in case of hardware conference */
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
