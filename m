From: akpm@linux-foundation.org
Subject: + mm-slub-constify-attribute_group-structures.patch added to -mm
 tree
Date: Thu, 27 Jul 2017 14:03:13 -0700
Message-ID: <597a5511.MyHBUmYB6X2ceeYQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50136 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdG0VDO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 17:03:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvind.yadav.cs@gmail.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: constify attribute_group structures
has been added to the -mm tree.  Its filename is
     mm-slub-constify-attribute_group-structures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-constify-attribute_group-structures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-constify-attribute_group-structures.patch

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
@@ -5423,7 +5423,7 @@ static struct attribute *slab_attrs[] =
 	NULL
 };
 
-static struct attribute_group slab_attr_group = {
+static const struct attribute_group slab_attr_group = {
 	.attrs = slab_attrs,
 };
 
_

Patches currently in -mm which might be from arvind.yadav.cs@gmail.com are

mm-ksm-constify-attribute_group-structures.patch
mm-slub-constify-attribute_group-structures.patch
mm-page_idle-constify-attribute_group-structures.patch
mm-huge_memory-constify-attribute_group-structures.patch
mm-hugetlb-constify-attribute_group-structures.patch

