From: akpm@linux-foundation.org
Subject: - include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:55:37 -0700
Message-ID: <200809182055.m8IKtbaB019111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756637AbYIRUzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Hiroshi.DOYU@nokia.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/ioport.h: add missing macro argument for devm_release_* family
has been removed from the -mm tree.  Its filename was
     include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/ioport.h: add missing macro argument for devm_release_* family
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

akpm: these have no callers at this time, but they shall soon, so let's
get them right.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ioport.h~include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family include/linux/ioport.h
--- a/include/linux/ioport.h~include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family
+++ a/include/linux/ioport.h
@@ -159,9 +159,9 @@ extern struct resource * __devm_request_
 				struct resource *parent, resource_size_t start,
 				resource_size_t n, const char *name);
 
-#define devm_release_region(start,n) \
+#define devm_release_region(dev, start, n) \
 	__devm_release_region(dev, &ioport_resource, (start), (n))
-#define devm_release_mem_region(start,n) \
+#define devm_release_mem_region(dev, start, n) \
 	__devm_release_region(dev, &iomem_resource, (start), (n))
 
 extern void __devm_release_region(struct device *dev, struct resource *parent,
_

Patches currently in -mm which might be from Hiroshi.DOYU@nokia.com are

origin.patch

