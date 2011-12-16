From: akpm@linux-foundation.org
Subject: + radix_tree-remove-radix_tree_indirect_to_ptr.patch added to -mm tree
Date: Fri, 16 Dec 2011 12:32:56 -0800
Message-ID: <20111216203257.7D75620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:52903 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab1LPUdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 15:33:00 -0500
Received: by faar15 with SMTP id r15so134621faa.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 12:32:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, hughd@google.com


The patch titled
     Subject: radix_tree: remove radix_tree_indirect_to_ptr()
has been added to the -mm tree.  Its filename is
     radix_tree-remove-radix_tree_indirect_to_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: radix_tree: remove radix_tree_indirect_to_ptr()

It is not used anymore, remove it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/radix-tree.h~radix_tree-remove-radix_tree_indirect_to_ptr include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix_tree-remove-radix_tree_indirect_to_ptr
+++ a/include/linux/radix-tree.h
@@ -49,9 +49,6 @@
 #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
 #define RADIX_TREE_EXCEPTIONAL_SHIFT	2
 
-#define radix_tree_indirect_to_ptr(ptr) \
-	radix_tree_indirect_to_ptr((void __force *)(ptr))
