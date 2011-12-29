From: akpm@linux-foundation.org
Subject: + btree-export-btree_get_prev-so-modules-can-use-btree_for_each.patch added to -mm tree
Date: Thu, 29 Dec 2011 14:36:00 -0800
Message-ID: <20111229223600.9F78210004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:64043 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1L2WgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2011 17:36:01 -0500
Received: by yhjj51 with SMTP id j51so1863289yhj.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2011 14:36:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@purestorage.com, joern@logfs.org, roland@purestorage.com


The patch titled
     Subject: btree: export btree_get_prev() so modules can use btree_for_each
has been added to the -mm tree.  Its filename is
     btree-export-btree_get_prev-so-modules-can-use-btree_for_each.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steve Hodgson <steve@purestorage.com>
Subject: btree: export btree_get_prev() so modules can use btree_for_each

The btree_for_each API is implemented with macros that internally call
btree_get_prev(), so if btree_get_prev() isn't exported then modules fail
to link if they try to use one of the btree_for_each macros.  Since the
rest of the btree API is exported, we should keep things orthogonal and
make this work too.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Cc: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/btree.c~btree-export-btree_get_prev-so-modules-can-use-btree_for_each lib/btree.c
--- a/lib/btree.c~btree-export-btree_get_prev-so-modules-can-use-btree_for_each
+++ a/lib/btree.c
@@ -357,6 +357,7 @@ miss:
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(btree_get_prev);
 
 static int getpos(struct btree_geo *geo, unsigned long *node,
 		unsigned long *key)
_
Subject: Subject: btree: export btree_get_prev() so modules can use btree_for_each

Patches currently in -mm which might be from steve@purestorage.com are

btree-export-btree_get_prev-so-modules-can-use-btree_for_each.patch

