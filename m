From: akpm@linux-foundation.org
Subject: [merged]
 kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:20 -0700
Message-ID: <51db14f0.GPggdcW9nPPEikGf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3GHThU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jbarnes@virtuousgeek.org, bjorn.helgaas@hp.com, haokexin@gmail.com

Subject: [merged] kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource.patch removed from -mm tree
To: haokexin@gmail.com,bjorn.helgaas@hp.com,jbarnes@virtuousgeek.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:20 -0700


The patch titled
     Subject: kernel/resource.c: remove the unneeded assignment in function __find_resource
has been removed from the -mm tree.  Its filename was
     kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kevin Hao <haokexin@gmail.com>
Subject: kernel/resource.c: remove the unneeded assignment in function __find_resource

This line was introduced by fcb11918 ("resources: add arch hook for
preventing allocation in reserved areas").  But the struct tmp was already
assigned to *new in the above line, so this seems superfluous.  Just
remove it.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/resource.c~kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource kernel/resource.c
--- a/kernel/resource.c~kernel-resourcec-remove-the-unneeded-assignment-in-function-__find_resource
+++ a/kernel/resource.c
@@ -449,7 +449,6 @@ static int __find_resource(struct resour
 	struct resource *this = root->child;
 	struct resource tmp = *new, avail, alloc;
 
-	tmp.flags = new->flags;
 	tmp.start = root->start;
 	/*
 	 * Skip past an allocated resource that starts at 0, since the assignment
_

Patches currently in -mm which might be from haokexin@gmail.com are

origin.patch

