From: akpm@linux-foundation.org
Subject: - resources-tidy-__request_region.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:29 -0700
Message-ID: <200810182320.m9INKTxm029772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916AbYJRXUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     resources: tidy __request_region()
has been removed from the -mm tree.  Its filename was
     resources-tidy-__request_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: resources: tidy __request_region()
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

No functional change.  Just return NULL for kzalloc failure immediately,
rather than wrapping the whole function body in the body of an "if".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN kernel/resource.c~resources-tidy-__request_region kernel/resource.c
--- a/kernel/resource.c~resources-tidy-__request_region
+++ a/kernel/resource.c
@@ -630,33 +630,34 @@ struct resource * __request_region(struc
 {
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 
-	if (res) {
-		res->name = name;
-		res->start = start;
-		res->end = start + n - 1;
-		res->flags = IORESOURCE_BUSY;
+	if (!res)
+		return NULL;
 
-		write_lock(&resource_lock);
+	res->name = name;
+	res->start = start;
+	res->end = start + n - 1;
+	res->flags = IORESOURCE_BUSY;
 
-		for (;;) {
-			struct resource *conflict;
+	write_lock(&resource_lock);
 
-			conflict = __request_resource(parent, res);
-			if (!conflict)
-				break;
-			if (conflict != parent) {
-				parent = conflict;
-				if (!(conflict->flags & IORESOURCE_BUSY))
-					continue;
-			}
+	for (;;) {
+		struct resource *conflict;
 
-			/* Uhhuh, that didn't work out.. */
-			kfree(res);
-			res = NULL;
+		conflict = __request_resource(parent, res);
+		if (!conflict)
 			break;
+		if (conflict != parent) {
+			parent = conflict;
+			if (!(conflict->flags & IORESOURCE_BUSY))
+				continue;
 		}
-		write_unlock(&resource_lock);
+
+		/* Uhhuh, that didn't work out.. */
+		kfree(res);
+		res = NULL;
+		break;
 	}
+	write_unlock(&resource_lock);
 	return res;
 }
 EXPORT_SYMBOL(__request_region);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
rtc-cmos-export-second-nvram-bank.patch

