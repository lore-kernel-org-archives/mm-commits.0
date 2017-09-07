From: akpm@linux-foundation.org
Subject: [merged]
 mm-huge_memory-constify-attribute_group-structures.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:39:31 -0700
Message-ID: <20170907183931.pK3NMwnNN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56642 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755802AbdIGSjc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:39:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: constify attribute_group structures
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-constify-attribute_group-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: mm/huge_memory.c: constify attribute_group structures

attribute_group are not supposed to change at runtime.  All functions
working with attribute_group provided by <linux/sysfs.h> work with const
attribute_group.  So mark the non-const structs as const.

Link: http://lkml.kernel.org/r/1501157240-3876-1-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-huge_memory-constify-attribute_group-structures mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-constify-attribute_group-structures
+++ a/mm/huge_memory.c
@@ -328,7 +328,7 @@ static struct attribute *hugepage_attr[]
 	NULL,
 };
 
-static struct attribute_group hugepage_attr_group = {
+static const struct attribute_group hugepage_attr_group = {
 	.attrs = hugepage_attr,
 };
 
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are


