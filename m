From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-sesc-eliminate-double-free.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:52:55 -0400
Message-ID: <201003150653.o2F6rS50015998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COGxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:53:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, James.Bottomley@HansenPartnership.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/ses.c: eliminate double free
has been removed from the -mm tree.  Its filename was
     drivers-scsi-sesc-eliminate-double-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/ses.c: eliminate double free
From: Julia Lawall <julia@diku.dk>

The few lines below the kfree of hdr_buf may go to the label err_free
which will also free hdr_buf.  The most straightforward solution seems to
be to just move the kfree of hdr_buf after these gotos.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier E;
expression E1;
iterator I;
statement S;
@@

*kfree(E);
... when != E = E1
    when != I(E,...) S
    when != &E
*kfree(E);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ses.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ses.c~drivers-scsi-sesc-eliminate-double-free drivers/scsi/ses.c
--- a/drivers/scsi/ses.c~drivers-scsi-sesc-eliminate-double-free
+++ a/drivers/scsi/ses.c
@@ -595,8 +595,6 @@ static int ses_intf_add(struct device *c
 		ses_dev->page10_len = len;
 		buf = NULL;
 	}
-	kfree(hdr_buf);
-
 	scomp = kzalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
 		goto err_free;
@@ -608,6 +606,8 @@ static int ses_intf_add(struct device *c
 		goto err_free;
 	}
 
+	kfree(hdr_buf);
+
 	edev->scratch = ses_dev;
 	for (i = 0; i < components; i++)
 		edev->component[i].scratch = scomp + i;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-edac-introduce-missing-kfree.patch

