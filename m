From: akpm@linux-foundation.org
Subject: [merged] ipcns-remove-useless-get-put-while-clone_newipc.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:36 -0700
Message-ID: <200906182247.n5IMlaqq006661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758091AbZFRW5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, serue@us.ibm.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipcns: remove useless get/put while CLONE_NEWIPC
has been removed from the -mm tree.  Its filename was
     ipcns-remove-useless-get-put-while-clone_newipc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipcns: remove useless get/put while CLONE_NEWIPC
From: Alexey Dobriyan <adobriyan@gmail.com>

copy_ipcs() doesn't actually copy anything. If new ipcns is created, it's
created from scratch, in this case get/put on old ipcns isn't needed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/namespace.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN ipc/namespace.c~ipcns-remove-useless-get-put-while-clone_newipc ipc/namespace.c
--- a/ipc/namespace.c~ipcns-remove-useless-get-put-while-clone_newipc
+++ a/ipc/namespace.c
@@ -50,15 +50,11 @@ struct ipc_namespace *copy_ipcs(unsigned
 {
 	struct ipc_namespace *new_ns;
 
-	BUG_ON(!ns);
-	get_ipc_ns(ns);
