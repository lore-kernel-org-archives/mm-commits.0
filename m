From: akpm@linux-foundation.org
Subject: [merged] ipcsysv-return-einval-upon-incorrect-id-seqnum.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:47:29 -0700
Message-ID: <559adb51.pxV11jkhLDJKN+yj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbbGFTr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sysv: return -EINVAL upon incorrect id/seqnum
has been removed from the -mm tree.  Its filename was
     ipcsysv-return-einval-upon-incorrect-id-seqnum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc,sysv: return -EINVAL upon incorrect id/seqnum

In ipc_obtain_object_check we return -EIDRM when a bogus sequence number
is detected via ipc_checkid, while the ipc manpages state the following
return codes for such errors:

   EIDRM  <ID> points to a removed identifier.
   EINVAL Invalid <ID> value, or unaligned, etc.

EIDRM should only be returned upon a RMID call (->deleted check), and thus
return EINVAL for wrong seq.  This difference in semantics has also caused
real bugs, ie: https://bugzilla.redhat.com/show_bug.cgi?id=246509

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/util.c~ipcsysv-return-einval-upon-incorrect-id-seqnum ipc/util.c
--- a/ipc/util.c~ipcsysv-return-einval-upon-incorrect-id-seqnum
+++ a/ipc/util.c
@@ -622,7 +622,7 @@ struct kern_ipc_perm *ipc_obtain_object_
 		goto out;
 
 	if (ipc_checkid(out, id))
-		return ERR_PTR(-EIDRM);
+		return ERR_PTR(-EINVAL);
 out:
 	return out;
 }
_

Patches currently in -mm which might be from dave@stgolabs.net are


