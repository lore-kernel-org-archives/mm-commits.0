From: akpm@linux-foundation.org
Subject: [merged]
 radix-tree-remove-unneeded-include-linux-bugh.patch removed from -mm tree
Date: Mon, 20 Nov 2017 13:23:59 -0800
Message-ID: <20171120212359.dLY9q46VA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40202 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbdKTVYA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:24:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrism@mellanox.com, hannes@cmpxchg.org, jack@suse.cz, mawilcox@microsoft.com, mm-commits@vger.kernel.org, yamada.masahiro@socionext.com


The patch titled
     Subject: include/linux/radix-tree.h: remove unneeded #include <linux/bug.h>
has been removed from the -mm tree.  Its filename was
     radix-tree-remove-unneeded-include-linux-bugh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yamada.masahiro@socionext.com are


