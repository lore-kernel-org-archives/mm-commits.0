From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_idle-constify-attribute_group-structures.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:39:28 -0700
Message-ID: <20170907183928.EFfIl7yAL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755802AbdIGSj3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_idle.c: constify attribute_group structures
has been removed from the -mm tree.  Its filename was
     mm-page_idle-constify-attribute_group-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: mm/page_idle.c: constify attribute_group structures

attribute_group are not supposed to change at runtime.  All functions
working with attribute_group provided by <linux/sysfs.h> work with const
attribute_group.  So mark the non-const structs as const.

Link: http://lkml.kernel.org/r/1501157221-3832-1-git-send-email-arvind.yadav.cs@gmail.com
Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_idle.c~mm-page_idle-constify-attribute_group-structures mm/page_idle.c
--- a/mm/page_idle.c~mm-page_idle-constify-attribute_group-structures
+++ a/mm/page_idle.c
@@ -204,7 +204,7 @@ static struct bin_attribute *page_idle_b
 	NULL,
 };
 
-static struct attribute_group page_idle_attr_group = {
+static const struct attribute_group page_idle_attr_group = {
 	.bin_attrs = page_idle_bin_attrs,
 	.name = "page_idle",
 };
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are


