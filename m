From: akpm@linux-foundation.org
Subject: + mm-hugetlb-constify-attribute_group-structures.patch added to
 -mm tree
Date: Thu, 27 Jul 2017 14:03:19 -0700
Message-ID: <597a5517.kuLSVjPAKOchhMlL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdG0VDU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 17:03:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: constify attribute_group structures
has been added to the -mm tree.  Its filename is
     mm-hugetlb-constify-attribute_group-structures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-constify-attribute_group-structures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-constify-attribute_group-structures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-ksm-constify-attribute_group-structures.patch
mm-slub-constify-attribute_group-structures.patch
mm-page_idle-constify-attribute_group-structures.patch
mm-huge_memory-constify-attribute_group-structures.patch
mm-hugetlb-constify-attribute_group-structures.patch

