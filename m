From: akpm@linux-foundation.org
Subject: + rapidio-dereferencing-an-error-pointer.patch added to -mm tree
Date: Fri, 05 Aug 2016 10:05:17 -0700
Message-ID: <57a4c74d.cUQviiRtbaviPJAE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759759AbcHERFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Aug 2016 13:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: dereferencing an error pointer
has been added to the -mm tree.  Its filename is
     rapidio-dereferencing-an-error-pointer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-dereferencing-an-error-pointer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-dereferencing-an-error-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: rapidio: dereferencing an error pointer

Original patch: https://lkml.org/lkml/2016/8/4/32

If riocm_ch_alloc() fails then we end up dereferencing the error pointer.

The problem is that we're not unwinding in the reverse order from how we
allocate things so it gets confusing.  I've changed this around so now
"ch" is NULL when we are done with it after we call riocm_put_channel(). 
That way we can check if it's NULL and avoid calling riocm_put_channel()
on it twice.

I renamed err_nodev to err_put_new_ch so that it better reflects what the
goto does.

Then because we had flipping things around, it means we don't neeed to
initialize the pointers to NULL and we can remove an if statement and pull
things in an indent level.

Link: http://lkml.kernel.org/r/20160805152406.20713-1-alexandre.bounine@idt.com
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio_cm.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN drivers/rapidio/rio_cm.c~rapidio-dereferencing-an-error-pointer drivers/rapidio/rio_cm.c
--- a/drivers/rapidio/rio_cm.c~rapidio-dereferencing-an-error-pointer
+++ a/drivers/rapidio/rio_cm.c
@@ -1080,8 +1080,8 @@ static int riocm_send_ack(struct rio_cha
 static struct rio_channel *riocm_ch_accept(u16 ch_id, u16 *new_ch_id,
 					   long timeout)
 {
-	struct rio_channel *ch = NULL;
-	struct rio_channel *new_ch = NULL;
+	struct rio_channel *ch;
+	struct rio_channel *new_ch;
 	struct conn_req *req;
 	struct cm_peer *peer;
 	int found = 0;
@@ -1155,6 +1155,7 @@ static struct rio_channel *riocm_ch_acce
 
 	spin_unlock_bh(&ch->lock);
 	riocm_put_channel(ch);
+	ch = NULL;
 	kfree(req);
 
 	down_read(&rdev_sem);
@@ -1172,7 +1173,7 @@ static struct rio_channel *riocm_ch_acce
 	if (!found) {
 		/* If peer device object not found, simply ignore the request */
 		err = -ENODEV;
-		goto err_nodev;
+		goto err_put_new_ch;
 	}
 
 	new_ch->rdev = peer->rdev;
@@ -1184,15 +1185,16 @@ static struct rio_channel *riocm_ch_acce
 
 	*new_ch_id = new_ch->id;
 	return new_ch;
+
+err_put_new_ch:
+	spin_lock_bh(&idr_lock);
+	idr_remove(&ch_idr, new_ch->id);
+	spin_unlock_bh(&idr_lock);
+	riocm_put_channel(new_ch);
+
 err_put:
-	riocm_put_channel(ch);
-err_nodev:
-	if (new_ch) {
-		spin_lock_bh(&idr_lock);
-		idr_remove(&ch_idr, new_ch->id);
-		spin_unlock_bh(&idr_lock);
-		riocm_put_channel(new_ch);
-	}
+	if (ch)
+		riocm_put_channel(ch);
 	*new_ch_id = 0;
 	return ERR_PTR(err);
 }
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

powerpc-fsl_rio-fix-a-missing-error-code.patch
rapidio-dereferencing-an-error-pointer.patch

