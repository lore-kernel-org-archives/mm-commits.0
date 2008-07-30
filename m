From: akpm@linux-foundation.org
Subject: + resources-tidy-__request_region.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:33:15 -0700
Message-ID: <200807300033.m6U0XFaL030257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489AbYG3Ad3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com


The patch titled
     resources: tidy __request_region()
has been added to the -mm tree.  Its filename is
     resources-tidy-__request_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -524,33 +524,34 @@ struct resource * __request_region(struc
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

mm-only-enforce-acpi-resource-conflict-checks.patch
resources-tidy-__request_region.patch

