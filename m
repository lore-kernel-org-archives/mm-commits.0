From: akpm@linux-foundation.org
Subject: + radix-tree-tests-properly-initialize-mutex.patch added to -mm
 tree
Date: Mon, 15 Aug 2016 14:51:31 -0700
Message-ID: <57b23963.8DvP53dnoEQOKQvd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221AbcHOVvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 17:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, aryabinin@virtuozzo.com, dvyukov@google.com, koct9i@gmail.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree tests: properly initialize mutex
has been added to the -mm tree.  Its filename is
     radix-tree-tests-properly-initialize-mutex.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-tests-properly-initialize-mutex.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-tests-properly-initialize-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

radix-tree-slot-can-be-null-in-radix_tree_next_slot.patch
radix-tree-tests-add-iteration-test.patch
radix-tree-tests-properly-initialize-mutex.patch

