From: akpm@linux-foundation.org
Subject: + drivers-scsi-aacraid-eliminate-use-after-free.patch added to -mm tree
Date: Wed, 19 May 2010 12:54:35 -0700
Message-ID: <201005191954.o4JJsZKr002450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772Ab0ESTym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 15:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@HansenPartnership.com


The patch titled
     drivers/scsi/aacraid: aliminate use after free
has been added to the -mm tree.  Its filename is
     drivers-scsi-aacraid-eliminate-use-after-free.patch

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
Subject: drivers/scsi/aacraid: aliminate use after free
From: Julia Lawall <julia@diku.dk>

The debugging code using the freed structure is moved before the kfree.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@free@
expression E;
position p;
@@
kfree@p(E)

@@
expression free.E, subE<=free.E, E1;
position free.p;
@@

  kfree@p(E)
  ...
(
  subE = E1
|
* E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/commctrl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/commctrl.c~drivers-scsi-aacraid-eliminate-use-after-free drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c~drivers-scsi-aacraid-eliminate-use-after-free
+++ a/drivers/scsi/aacraid/commctrl.c
@@ -655,9 +655,9 @@ static int aac_send_raw_srb(struct aac_d
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
 				if(!p) {
-					kfree (usg);
-					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
+					dprintk((KERN_DEBUG "aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  usg->sg[i].count,i,usg->count));
+					kfree(usg);
 					rcode = -ENOMEM;
 					goto cleanup;
 				}
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-scsi-aacraid-eliminate-use-after-free.patch
arch-x86-pci-use-kasprintf.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-char-ppdevc-use-kasprintf.patch

