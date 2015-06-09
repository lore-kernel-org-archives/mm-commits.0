From: akpm@linux-foundation.org
Subject: + ipcsysv-return-einval-upon-incorrect-id-seqnum.patch added to
 -mm tree
Date: Tue, 09 Jun 2015 15:24:27 -0700
Message-ID: <5577679b.bAsdO+KaXD5kdhdI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbbFIWY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 18:24:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sysv: return -EINVAL upon incorrect id/seqnum
has been added to the -mm tree.  Its filename is
     ipcsysv-return-einval-upon-incorrect-id-seqnum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcsysv-return-einval-upon-incorrect-id-seqnum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcsysv-return-einval-upon-incorrect-id-seqnum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-document-the-reserve-map-region-tracking-routines.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch
ipcshm-move-bug_on-check-into-shm_lock.patch
ipcmsg-provide-barrier-pairings-for-lockless-receive.patch
ipc-rename-ipc_obtain_object.patch
ipcsysv-make-return-eidrm-when-racing-with-rmid-consistent.patch
ipcsysv-return-einval-upon-incorrect-id-seqnum.patch
linux-next.patch

