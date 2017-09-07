From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-constify-attribute_group-structures.patch removed from -mm tree
Date: Thu, 07 Sep 2017 11:39:34 -0700
Message-ID: <20170907183934.wlBhbMKkF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56710 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755873AbdIGSjf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:39:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: constify attribute_group structures
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-constify-attribute_group-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: mm/hugetlb.c: constify attribute_group structures

attribute_group are not supposed to change at runtime.  All functions
working with attribute_group provided by <linux/sysfs.h> work with const
attribute_group.  So mark the non-const structs as const.

Link: http://lkml.kernel.org/r/1501157260-3922-1-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-constify-attribute_group-structures mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-constify-attribute_group-structures
+++ a/mm/hugetlb.c
@@ -2569,13 +2569,13 @@ static struct attribute *hstate_attrs[]
 	NULL,
 };
 
-static struct attribute_group hstate_attr_group = {
+static const struct attribute_group hstate_attr_group = {
 	.attrs = hstate_attrs,
 };
 
 static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
 				    struct kobject **hstate_kobjs,
-				    struct attribute_group *hstate_attr_group)
+				    const struct attribute_group *hstate_attr_group)
 {
 	int retval;
 	int hi = hstate_index(h);
@@ -2633,7 +2633,7 @@ static struct attribute *per_node_hstate
 	NULL,
 };
 
-static struct attribute_group per_node_hstate_attr_group = {
+static const struct attribute_group per_node_hstate_attr_group = {
 	.attrs = per_node_hstate_attrs,
 };
 
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are


