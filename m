From: akpm@linux-foundation.org
Subject: + misdn-indentation-braces-disagree-add-braces.patch added to -mm tree
Date: Tue, 04 Nov 2008 12:27:15 -0800
Message-ID: <200811042027.mA4KRFTQ010170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182AbYKDU1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 15:27:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi, kkeil@suse.de


The patch titled
     misdn: indentation & braces disagree - add braces
has been added to the -mm tree.  Its filename is
     misdn-indentation-braces-disagree-add-braces.patch

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
@@ -1855,7 +1855,7 @@ dsp_cmx_hdlc(struct dsp *dsp, struct sk_
 		/* in case of hardware (echo) */
 		if (dsp->pcm_slot_tx >=3D 0)
 			return;
-		if (dsp->echo)
+		if (dsp->echo) {
 			nskb =3D skb_clone(skb, GFP_ATOMIC);
 			if (nskb) {
 				hh =3D mISDN_HEAD_P(nskb);
@@ -1864,6 +1864,7 @@ dsp_cmx_hdlc(struct dsp *dsp, struct sk_
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

linux-next.patch
consolemap-indentation-braces-disagree-reindent.patch
misdn-indentation-braces-disagree-add-braces.patch
misdn-one-handmade-array_size-converted.patch
misdn-indentation-and-braces-disagree-add-braces.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
