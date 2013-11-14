From: akpm@linux-foundation.org
Subject: + cmdline-parser-fix-build.patch added to -mm tree
Date: Thu, 14 Nov 2013 12:35:39 -0800
Message-ID: <5285341b.StZbzJPhDrRvlvG1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab3KNUfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Nov 2013 15:35:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, caizhiyong@huawei.com, alexander.beregalov@intel.com, a.beregalov@gmail.com

Subject: + cmdline-parser-fix-build.patch added to -mm tree
To: a.beregalov@gmail.com,alexander.beregalov@intel.com,caizhiyong@huawei.com
From: akpm@linux-foundation.org
Date: Thu, 14 Nov 2013 12:35:39 -0800


The patch titled
     Subject: cmdline-parser: fix build
has been added to the -mm tree.  Its filename is
     cmdline-parser-fix-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cmdline-parser-fix-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cmdline-parser-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

cmdline-parser-fix-build.patch

