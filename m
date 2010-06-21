From: akpm@linux-foundation.org
Subject: + arch-sh-mm-eliminate-a-double-lock.patch added to -mm tree
Date: Mon, 21 Jun 2010 15:35:12 -0700
Message-ID: <201006212235.o5LMZCNV009093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab0FUWfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 18:35:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, lethal@linux-sh.org, matt@console-pimps.org


The patch titled
     arch/sh/mm: eliminate a double lock
has been added to the -mm tree.  Its filename is
     arch-sh-mm-eliminate-a-double-lock.patch

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
Subject: arch/sh/mm: eliminate a double lock
From: Julia Lawall <julia@diku.dk>

The function begins and ends with a read_lock.  The latter is changed to a
read_unlock.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@locked@
expression E1;
position p;
@@

read_lock(E1@p,...);

@r exists@
expression x <= locked.E1;
expression locked.E1;
expression E2;
identifier lock;
position locked.p,p1,p2;
@@

*lock@p1 (E1@p,...);
... when != E1
    when != \(x = E2\|&x\)
*lock@p2 (E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/pmb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/mm/pmb.c~arch-sh-mm-eliminate-a-double-lock arch/sh/mm/pmb.c
--- a/arch/sh/mm/pmb.c~arch-sh-mm-eliminate-a-double-lock
+++ a/arch/sh/mm/pmb.c
@@ -770,7 +770,7 @@ static void __init pmb_resize(void)
 		spin_unlock_irqrestore(&pmbe->lock, flags);
 	}
 
-	read_lock(&pmb_rwlock);
+	read_unlock(&pmb_rwlock);
 }
 #endif
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-hid-eliminate-a-double-lock.patch
arch-sh-mm-eliminate-a-double-lock.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-dma-eliminate-a-null-pointer-dereference.patch
drivers-media-use-memdup_user.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
arch-sparc-kernel-eliminate-what-looks-like-a-null-pointer-dereference.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch

