From: akpm@linux-foundation.org
Subject: + lib-generic-radix-treec-remove-unneeded-__rcu.patch added
 to -mm tree
Date: Thu, 25 Jun 2020 16:12:06 -0700
Message-ID: <20200625231206.4SCys%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403984AbgFYXMH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 19:12:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kent.overstreet@gmail.com, luc.vanoostenryck@gmail.com


The patch titled
     Subject: lib/generic-radix-tree.c: remove unneeded __rcu
has been added to the -mm tree.  Its filename is
     lib-generic-radix-treec-remove-unneeded-__rcu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-generic-radix-treec-remove-unneeded-__rcu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-generic-radix-treec-remove-unneeded-__rcu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: lib/generic-radix-tree.c: remove unneeded __rcu

struct __genradix is defined as having its member 'root'
annotated as __rcu. But in the corresponding API RCU is not used.
Sparse reports this type mismatch as:
	lib/generic-radix-tree.c:56:35: warning: incorrect type in initializer (different address spaces)
	lib/generic-radix-tree.c:56:35:    expected struct genradix_root *r
	lib/generic-radix-tree.c:56:35:    got struct genradix_root [noderef] <asn:4> *__val
with 6 other ones.

So, correct root's type by removing this unneeded __rcu.

Link: http://lkml.kernel.org/r/20200621161745.55396-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/generic-radix-tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/generic-radix-tree.h~lib-generic-radix-treec-remove-unneeded-__rcu
+++ a/include/linux/generic-radix-tree.h
@@ -44,7 +44,7 @@
 struct genradix_root;
 
 struct __genradix {
-	struct genradix_root __rcu	*root;
+	struct genradix_root		*root;
 };
 
 /*
_

Patches currently in -mm which might be from luc.vanoostenryck@gmail.com are

fix-annotation-of-ioreadwrite1632be.patch
lib-generic-radix-treec-remove-unneeded-__rcu.patch
