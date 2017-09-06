From: akpm@linux-foundation.org
Subject: [patch 063/119] mm/huge_memory.c: constify attribute_group
 structures
Date: Wed, 06 Sep 2017 16:22:03 -0700
Message-ID: <20170906232203.o6BncW22w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50102 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdIFXWE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:22:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arvind.yadav.cs@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
