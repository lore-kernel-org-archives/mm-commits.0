From: akpm@linux-foundation.org
Subject: + btree-fix-tree-corruption-in-btree_get_prev.patch added to -mm tree
Date: Wed, 06 Jun 2012 16:22:49 -0700
Message-ID: <20120606232250.1F5D0A02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:36061 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab2FFXWw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 19:22:52 -0400
Received: by wgbdt11 with SMTP id dt11so250wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 16:22:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@purestorage.com, joern@logfs.org, stable@vger.kernel.org


The patch titled
     Subject: btree: fix tree corruption in btree_get_prev()
has been added to the -mm tree.  Its filename is
     btree-fix-tree-corruption-in-btree_get_prev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roland Dreier <roland@purestorage.com>
Subject: btree: fix tree corruption in btree_get_prev()

The memory the parameter __key points to is used as an iterator in
btree_get_prev(), so if we save off a bkey() pointer in retry_key and then
assign that to __key, we'll end up corrupting the btree internals when we
do eg

	longcpy(__key, bkey(geo, node, i), geo->keylen);

to return the key value.  What we should do instead is use longcpy() to
copy the key value that retry_key points to __key.

This can cause a btree to get corrupted by seemingly read-only operations
such as btree_for_each_safe.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Acked-by: Joern Engel <joern@logfs.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/btree.c~btree-fix-tree-corruption-in-btree_get_prev lib/btree.c
--- a/lib/btree.c~btree-fix-tree-corruption-in-btree_get_prev
+++ a/lib/btree.c
@@ -351,7 +351,7 @@ retry:
 	}
 miss:
 	if (retry_key) {
-		__key = retry_key;
+		longcpy(__key, retry_key, geo->keylen);
 		retry_key = NULL;
 		goto retry;
 	}
_
Subject: Subject: btree: fix tree corruption in btree_get_prev()

Patches currently in -mm which might be from roland@purestorage.com are

origin.patch
linux-next.patch
btree-fix-tree-corruption-in-btree_get_prev.patch
btree-fix-tree-corruption-in-btree_get_prev-fix.patch
btree-catch-null-value-before-it-does-harm.patch

