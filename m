From: akpm@linux-foundation.org
Subject: [merged] ipc-simplify-sysvipc_proc_open-return.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:37 -0800
Message-ID: <52e80071.lEcR3dP6AxdTlNpI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbaA1TJi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: [merged] ipc-simplify-sysvipc_proc_open-return.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:37 -0800


The patch titled
     Subject: ipc: simplify sysvipc_proc_open() return
has been removed from the -mm tree.  Its filename was
     ipc-simplify-sysvipc_proc_open-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc: simplify sysvipc_proc_open() return

Get rid of silly/useless label jumping.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN ipc/util.c~ipc-simplify-sysvipc_proc_open-return ipc/util.c
--- a/ipc/util.c~ipc-simplify-sysvipc_proc_open-return
+++ a/ipc/util.c
@@ -911,8 +911,10 @@ static int sysvipc_proc_open(struct inod
 		goto out;
 
 	ret = seq_open(file, &sysvipc_proc_seqops);
-	if (ret)
-		goto out_kfree;
+	if (ret) {
+		kfree(iter);
+		goto out;
+	}
 
 	seq = file->private_data;
 	seq->private = iter;
@@ -921,9 +923,6 @@ static int sysvipc_proc_open(struct inod
 	iter->ns    = get_ipc_ns(current->nsproxy->ipc_ns);
 out:
 	return ret;
-out_kfree:
-	kfree(iter);
-	goto out;
 }
 
 static int sysvipc_proc_release(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
linux-next.patch

