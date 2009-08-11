From: akpm@linux-foundation.org
Subject: + ibmvscsi-avoid-unnecessary-use-of-kzalloc_pool.patch added to -mm tree
Date: Tue, 11 Aug 2009 14:53:19 -0700
Message-ID: <200908112153.n7BLrKq5026282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983AbZHKVxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 17:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sage@newdream.net, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com


The patch titled
     ibmvscsi: avoid unnecessary use of kzalloc_pool
has been added to the -mm tree.  Its filename is
     ibmvscsi-avoid-unnecessary-use-of-kzalloc_pool.patch

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
Subject: ibmvscsi: avoid unnecessary use of kzalloc_pool
From: Sage Weil <sage@newdream.net>

The allocated struct is manually zeroed after allocation, so avoid using
the (broken) kzalloc mempool (which does not re-zero previously used items
when they are returned to the pool).

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Sage Weil <sage@newdream.net>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvscsi-avoid-unnecessary-use-of-kzalloc_pool drivers/scsi/ibmvscsi/ibmvfc.c
--- a/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvscsi-avoid-unnecessary-use-of-kzalloc_pool
+++ a/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4217,7 +4217,7 @@ static int ibmvfc_alloc_mem(struct ibmvf
 	if (!vhost->trace)
 		goto free_disc_buffer;
 
-	vhost->tgt_pool = mempool_create_kzalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
+	vhost->tgt_pool = mempool_create_kmalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
 						      sizeof(struct ibmvfc_target));
 
 	if (!vhost->tgt_pool) {
_

Patches currently in -mm which might be from sage@newdream.net are

vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
md-avoid-use-of-broken-kzalloc-mempool.patch
ibmvscsi-avoid-unnecessary-use-of-kzalloc_pool.patch
mm-remove-broken-kzalloc-mempool.patch

