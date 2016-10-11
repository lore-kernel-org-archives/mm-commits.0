From: akpm@linux-foundation.org
Subject: [patch 008/102] radix-tree tests: properly initialize mutex
Date: Tue, 11 Oct 2016 13:51:24 -0700
Message-ID: <57fd50cc.ZAEUwUfyF1qvmryj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37873 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbcJKUwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, aryabinin@virtuozzo.com, dvyukov@google.com, koct9i@gmail.com, shuahkh@osg.samsung.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree tests: properly initialize mutex

The pthread_mutex_t in regression1.c wasn't being initialized properly.

Link: http://lkml.kernel.org/r/20160815194237.25967-4-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/regression1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/radix-tree/regression1.c~radix-tree-tests-properly-initialize-mutex tools/testing/radix-tree/regression1.c
--- a/tools/testing/radix-tree/regression1.c~radix-tree-tests-properly-initialize-mutex
+++ a/tools/testing/radix-tree/regression1.c
@@ -43,7 +43,7 @@
 #include "regression.h"
 
 static RADIX_TREE(mt_tree, GFP_KERNEL);
-static pthread_mutex_t mt_lock;
+static pthread_mutex_t mt_lock = PTHREAD_MUTEX_INITIALIZER;
 
 struct page {
 	pthread_mutex_t lock;
_
