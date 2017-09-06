From: akpm@linux-foundation.org
Subject: [patch 064/119] mm/hugetlb.c: constify attribute_group
 structures
Date: Wed, 06 Sep 2017 16:22:06 -0700
Message-ID: <20170906232206.bhYclslHD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50116 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdIFXWH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:22:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arvind.yadav.cs@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
