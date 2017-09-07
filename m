From: akpm@linux-foundation.org
Subject: [merged] mm-ksm-constify-attribute_group-structures.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:39:22 -0700
Message-ID: <20170907183922.zTvPn-fQK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755904AbdIGSjX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm.c: constify attribute_group structures
has been removed from the -mm tree.  Its filename was
     mm-ksm-constify-attribute_group-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: mm/ksm.c: constify attribute_group structures

attribute_group are not supposed to change at runtime.  All functions
working with attribute_group provided by <linux/sysfs.h> work with const
attribute_group.  So mark the non-const structs as const.

Link: http://lkml.kernel.org/r/1501157167-3706-2-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/ksm.c~mm-ksm-constify-attribute_group-structures mm/ksm.c
--- a/mm/ksm.c~mm-ksm-constify-attribute_group-structures
+++ a/mm/ksm.c
@@ -3043,7 +3043,7 @@ static struct attribute *ksm_attrs[] = {
 	NULL,
 };
 
-static struct attribute_group ksm_attr_group = {
+static const struct attribute_group ksm_attr_group = {
 	.attrs = ksm_attrs,
 	.name = "ksm",
 };
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are


