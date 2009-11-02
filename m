From: akpm@linux-foundation.org
Subject: + resources-when-allocate_resource-fails-leave-resource-untouched.patch added to -mm tree
Date: Mon, 02 Nov 2009 14:15:10 -0800
Message-ID: <200911022215.nA2MFA50017836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899AbZKBWPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 17:15:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org, torvalds@linux-foundation.org


The patch titled
     resources: when allocate_resource() fails, leave resource untouched
has been added to the -mm tree.  Its filename is
     resources-when-allocate_resource-fails-leave-resource-untouched.patch

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
Subject: resources: when allocate_resource() fails, leave resource untouched
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

When "allocate_resource(root, new, size, ...)" fails, we currently clobber
"new".  This is inconvenient for the caller, who might care about the
original contents of the resource.

For example, when pci_bus_alloc_resource() fails, the "can't allocate mem
resource %pR" message from pci_assign_resources() currently contains junk
for the resource start/end.

This patch delays the "new" update until we're about to return success.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/resource.c~resources-when-allocate_resource-fails-leave-resource-untouched kernel/resource.c
--- a/kernel/resource.c~resources-when-allocate_resource-fails-leave-resource-untouched
+++ a/kernel/resource.c
@@ -308,35 +308,37 @@ static int find_resource(struct resource
 			 void *alignf_data)
 {
 	struct resource *this = root->child;
+	resource_size_t start, end;
 
-	new->start = root->start;
+	start = root->start;
 	/*
 	 * Skip past an allocated resource that starts at 0, since the assignment
 	 * of this->start - 1 to new->end below would cause an underflow.
 	 */
 	if (this && this->start == 0) {
-		new->start = this->end + 1;
+		start = this->end + 1;
 		this = this->sibling;
 	}
 	for(;;) {
 		if (this)
-			new->end = this->start - 1;
+			end = this->start - 1;
 		else
-			new->end = root->end;
-		if (new->start < min)
-			new->start = min;
-		if (new->end > max)
-			new->end = max;
-		new->start = ALIGN(new->start, align);
+			end = root->end;
+		if (start < min)
+			start = min;
+		if (end > max)
+			end = max;
+		start = ALIGN(start, align);
 		if (alignf)
 			alignf(alignf_data, new, size, align);
-		if (new->start < new->end && new->end - new->start >= size - 1) {
-			new->end = new->start + size - 1;
+		if (start < end && end - start >= size - 1) {
+			new->start = start;
+			new->end = start + size - 1;
 			return 0;
 		}
 		if (!this)
 			break;
-		new->start = this->end + 1;
+		start = this->end + 1;
 		this = this->sibling;
 	}
 	return -EBUSY;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
acpi-reintroduce-acpi_device_ops-shutdown-method.patch
kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch
resources-when-allocate_resource-fails-leave-resource-untouched.patch

