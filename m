From: akpm@linux-foundation.org
Subject: + radix-tree-remove-unneeded-include-linux-bugh.patch added to
 -mm tree
Date: Wed, 27 Sep 2017 15:50:50 -0700
Message-ID: <59cc2b4a.LRUcjsWT+bDpTUq9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbdI0Wuv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 18:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, chrism@mellanox.com, hannes@cmpxchg.org, jack@suse.cz, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/radix-tree.h: remove unneeded #include <linux/bug.h>
has been added to the -mm tree.  Its filename is
     radix-tree-remove-unneeded-include-linux-bugh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-remove-unneeded-include-linux-bugh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-remove-unneeded-include-linux-bugh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

bitfieldh-remove-32bit-from-field_get-comment-block.patch
bitfieldh-include-linux-build_bugh-instead-of-linux-bugh.patch
radix-tree-remove-unneeded-include-linux-bugh.patch
init-version-include-linux-exporth-instead-of-linux-moduleh.patch

