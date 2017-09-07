From: akpm@linux-foundation.org
Subject: [merged] mm-slub-constify-attribute_group-structures.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:39:25 -0700
Message-ID: <20170907183925.sIo-SWmBC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755616AbdIGSj0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:39:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: constify attribute_group structures
has been removed from the -mm tree.  Its filename was
     mm-slub-constify-attribute_group-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: mm/slub.c: constify attribute_group structures

attribute_group are not supposed to change at runtime.  All functions
working with attribute_group provided by <linux/sysfs.h> work with const
attribute_group.  So mark the non-const structs as const.

Link: http://lkml.kernel.org/r/1501157186-3749-1-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~mm-slub-constify-attribute_group-structures mm/slub.c
--- a/mm/slub.c~mm-slub-constify-attribute_group-structures
+++ a/mm/slub.c
@@ -5459,7 +5459,7 @@ static struct attribute *slab_attrs[] =
 	NULL
 };
 
-static struct attribute_group slab_attr_group = {
+static const struct attribute_group slab_attr_group = {
 	.attrs = slab_attrs,
 };
 
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are


