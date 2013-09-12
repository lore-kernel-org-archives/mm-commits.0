From: akpm@linux-foundation.org
Subject: [merged] ipc-drop-ipc_lock_check.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:51:07 -0700
Message-ID: <52321b2b.IixBSF6zupwv1N9S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab3ILTvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:51:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: [merged] ipc-drop-ipc_lock_check.patch removed from -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:51:07 -0700


The patch titled
     Subject: ipc: drop ipc_lock_check
has been removed from the -mm tree.  Its filename was
     ipc-drop-ipc_lock_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc: drop ipc_lock_check

No remaining users, we now use ipc_obtain_object_check().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   16 ----------------
 ipc/util.h |    1 -
 2 files changed, 17 deletions(-)

diff -puN ipc/util.c~ipc-drop-ipc_lock_check ipc/util.c
--- a/ipc/util.c~ipc-drop-ipc_lock_check
+++ a/ipc/util.c
@@ -686,22 +686,6 @@ out:
 	return out;
 }
 
-struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id)
-{
-	struct kern_ipc_perm *out;
-
-	out = ipc_lock(ids, id);
-	if (IS_ERR(out))
-		return out;
-
-	if (ipc_checkid(out, id)) {
-		ipc_unlock(out);
-		return ERR_PTR(-EIDRM);
-	}
-
-	return out;
-}
