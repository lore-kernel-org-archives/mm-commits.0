From: akpm@linux-foundation.org
Subject: [merged] cmdline-parser-fix-build.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:09:35 -0800
Message-ID: <52867f7f.iQk4GBDg2aKLJG33%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3KOUJf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, caizhiyong@huawei.com, alexander.beregalov@intel.com, a.beregalov@gmail.com

Subject: [merged] cmdline-parser-fix-build.patch removed from -mm tree
To: a.beregalov@gmail.com,alexander.beregalov@intel.com,caizhiyong@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:35 -0800


The patch titled
     Subject: cmdline-parser: fix build
has been removed from the -mm tree.  Its filename was
     cmdline-parser-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: cmdline-parser: fix build

Fix following errors:
include/linux/cmdline-parser.h:17:12: error: 'BDEVNAME_SIZE' undeclared here
block/cmdline-parser.c:17:2: error: implicit declaration of function 'kzalloc'

Signed-off-by: Alexander Beregalov <alexander.beregalov@intel.com>
Cc: CaiZhiyong <caizhiyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cmdline-parser.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/cmdline-parser.h~cmdline-parser-fix-build include/linux/cmdline-parser.h
--- a/include/linux/cmdline-parser.h~cmdline-parser-fix-build
+++ a/include/linux/cmdline-parser.h
@@ -8,6 +8,8 @@
 #define CMDLINEPARSEH
 
 #include <linux/blkdev.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
 
 /* partition flags */
 #define PF_RDONLY                   0x01 /* Device is read only */
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch

