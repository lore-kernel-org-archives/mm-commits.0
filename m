From: akpm@linux-foundation.org
Subject: [patch 29/94] include/linux/radix-tree.h: remove unneeded
 #include <linux/bug.h>
Date: Fri, 17 Nov 2017 15:27:53 -0800
Message-ID: <20171117232753.DjT4y33c6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423266AbdKQX1z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chrism@mellanox.com, hannes@cmpxchg.org, jack@suse.cz, mawilcox@microsoft.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: include/linux/radix-tree.h: remove unneeded #include <linux/bug.h>

This include was added by 187f1882b5b0 ("BUG: headers with BUG/BUG_ON etc.
need linux/bug.h") because BUG_ON() was used in this header at that time.

Some time later, 6d75f366b924 ("lib: radix-tree: check accounting of
existing slot replacement users") removed the use of BUG_ON() from this
header.

Since then, there is no reason to include <linux/bug.h>.

Link: http://lkml.kernel.org/r/1505660151-4383-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mi <chrism@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/radix-tree.h~radix-tree-remove-unneeded-include-linux-bugh include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-remove-unneeded-include-linux-bugh
+++ a/include/linux/radix-tree.h
@@ -22,7 +22,6 @@
 #define _LINUX_RADIX_TREE_H
 
 #include <linux/bitops.h>
-#include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/preempt.h>
_
