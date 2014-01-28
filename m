From: akpm@linux-foundation.org
Subject: [merged] ipc-remove-useless-return-statement.patch removed from
 -mm tree
Date: Tue, 28 Jan 2014 11:09:35 -0800
Message-ID: <52e8006f.T0RuLGs++SPZbvJ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbaA1TJg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: [merged] ipc-remove-useless-return-statement.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:35 -0800


The patch titled
     Subject: ipc: remove useless return statement
has been removed from the -mm tree.  Its filename was
     ipc-remove-useless-return-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc: remove useless return statement

Only found in ipc_rmid().

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN ipc/util.c~ipc-remove-useless-return-statement ipc/util.c
--- a/ipc/util.c~ipc-remove-useless-return-statement
+++ a/ipc/util.c
@@ -439,12 +439,8 @@ void ipc_rmid(struct ipc_ids *ids, struc
 	int lid = ipcid_to_idx(ipcp->id);
 
 	idr_remove(&ids->ipcs_idr, lid);
-
 	ids->in_use--;
-
 	ipcp->deleted = true;
