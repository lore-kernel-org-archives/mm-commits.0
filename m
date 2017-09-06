From: akpm@linux-foundation.org
Subject: [patch 060/119] mm/ksm.c: constify attribute_group
 structures
Date: Wed, 06 Sep 2017 16:21:53 -0700
Message-ID: <20170906232153.F_3hCSUVy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50058 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753778AbdIFXVy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:21:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arvind.yadav.cs@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
