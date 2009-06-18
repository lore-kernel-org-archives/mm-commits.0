From: akpm@linux-foundation.org
Subject: [merged] ipcns-extract-create_ipc_ns.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:38 -0700
Message-ID: <200906182247.n5IMlceD006718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759049AbZFRWsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, serue@us.ibm.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipcns: extract create_ipc_ns()
has been removed from the -mm tree.  Its filename was
     ipcns-extract-create_ipc_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipcns: extract create_ipc_ns()
From: Alexey Dobriyan <adobriyan@gmail.com>

clone_ipc_ns() is misnamed, it doesn't clone anything and doesn't use
passed parameter.  Rename it.

create_ipc_ns() will be used by C/R to create fresh ipcns.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/namespace.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN ipc/namespace.c~ipcns-extract-create_ipc_ns ipc/namespace.c
--- a/ipc/namespace.c~ipcns-extract-create_ipc_ns
+++ a/ipc/namespace.c
@@ -14,7 +14,7 @@
 
 #include "util.h"
 
-static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
+static struct ipc_namespace *create_ipc_ns(void)
 {
 	struct ipc_namespace *ns;
 	int err;
@@ -48,14 +48,9 @@ static struct ipc_namespace *clone_ipc_n
 
 struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
 {
-	struct ipc_namespace *new_ns;
-
 	if (!(flags & CLONE_NEWIPC))
 		return get_ipc_ns(ns);
-
-	new_ns = clone_ipc_ns(ns);
