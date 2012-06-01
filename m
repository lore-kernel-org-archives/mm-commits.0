From: akpm@linux-foundation.org
Subject: [merged] kernel-resourcec-correct-the-comment-of-allocate_resource.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:32:53 -0700
Message-ID: <20120601193253.6AF56A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57700 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab2FATcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:32:54 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so248161yen.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:32:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource.c: correct the comment of allocate_resource()
has been removed from the -mm tree.  Its filename was
     kernel-resourcec-correct-the-comment-of-allocate_resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: kernel/resource.c: correct the comment of allocate_resource()

In the comment of allocate_resource(), the explanation of parameter max
and min is not correct.

Actually, these two parameters are used to specify the range of the
resource that will be allocated, not the min/max size that will be
allocated.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/resource.c~kernel-resourcec-correct-the-comment-of-allocate_resource kernel/resource.c
--- a/kernel/resource.c~kernel-resourcec-correct-the-comment-of-allocate_resource
+++ a/kernel/resource.c
@@ -515,8 +515,8 @@ out:
  * @root: root resource descriptor
  * @new: resource descriptor desired by caller
  * @size: requested resource region size
- * @min: minimum size to allocate
- * @max: maximum size to allocate
+ * @min: minimum boundary to allocate
+ * @max: maximum boundary to allocate
  * @align: alignment requested, in bytes
  * @alignf: alignment function, optional, called if not NULL
  * @alignf_data: arbitrary data to pass to the @alignf function
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are

origin.patch

