From: akpm@linux-foundation.org
Subject: + drivers-scsi-sesc-eliminate-double-free.patch added to -mm tree
Date: Wed, 30 Dec 2009 13:18:44 -0800
Message-ID: <200912302118.nBULIigD002841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbZL3VSv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 16:18:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@HansenPartnership.com


The patch titled
     drivers/scsi/ses.c: eliminate double free
has been added to the -mm tree.  Its filename is
     drivers-scsi-sesc-eliminate-double-free.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ses.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ses.c~drivers-scsi-sesc-eliminate-double-free drivers/scsi/ses.c
--- a/drivers/scsi/ses.c~drivers-scsi-sesc-eliminate-double-free
+++ a/drivers/scsi/ses.c
@@ -591,8 +591,6 @@ static int ses_intf_add(struct device *c
 		ses_dev->page10_len = len;
 		buf = NULL;
 	}
-	kfree(hdr_buf);
-
 	scomp = kzalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
 		goto err_free;
@@ -604,6 +602,8 @@ static int ses_intf_add(struct device *c
 		goto err_free;
 	}
 
+	kfree(hdr_buf);
+
 	edev->scratch = ses_dev;
 	for (i = 0; i < components; i++)
 		edev->component[i].scratch = scomp + i;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
drivers-media-video-move-dereference-after-null-test.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-edac-introduce-missing-kfree.patch

