From: akpm@linux-foundation.org
Subject: - drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:58:32 -0800
Message-ID: <200901121958.n0CJwW3m027659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755865AbZALT7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 14:59:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn/hardware/mISDN: move a dereference below a NULL test
has been removed from the -mm tree.  Its filename was
     drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/isdn/hardware/mISDN: move a dereference below a NULL test
From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/mISDN/hfcmulti.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/hardware/mISDN/hfcmulti.c~drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test drivers/isdn/hardware/mISDN/hfcmulti.c
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c~drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test
+++ a/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3610,7 +3610,7 @@ hfcm_bctrl(struct mISDNchannel *ch, u_in
 static void
 ph_state_change(struct dchannel *dch)
 {
-	struct hfc_multi *hc = dch->hw;
+	struct hfc_multi *hc;
 	int ch, i;
 
 	if (!dch) {
@@ -3618,6 +3618,7 @@ ph_state_change(struct dchannel *dch)
 		    __func__);
 		return;
 	}
+	hc = dch->hw;
 	ch = dch->slot;
 
 	if (hc->type == 1) {
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch

