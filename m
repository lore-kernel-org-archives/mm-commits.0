From: akpm@linux-foundation.org
Subject: +
 mm-zswap-remove-unneeded-initialization-to-null-in-zswap_entry_find_get.patch added to -mm tree
Date: Fri, 11 Sep 2015 15:56:46 -0700
Message-ID: <55f35c2e.YhxB6mZxpwan4uGC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbbIKW4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexey.klimov@linaro.org, ddstreet@ieee.org, minchan@kernel.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: remove unneeded initialization to NULL in zswap_entry_find_get()
has been added to the -mm tree.  Its filename is
     mm-zswap-remove-unneeded-initialization-to-null-in-zswap_entry_find_get.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-remove-unneeded-initialization-to-null-in-zswap_entry_find_get.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-remove-unneeded-initialization-to-null-in-zswap_entry_find_get.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Klimov <alexey.klimov@linaro.org>
Subject: mm/zswap.c: remove unneeded initialization to NULL in zswap_entry_find_get()

On the next line entry variable will be re-initialized so no need to init
it with NULL.

Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zswap.c~mm-zswap-remove-unneeded-initialization-to-null-in-zswap_entry_find_get mm/zswap.c
--- a/mm/zswap.c~mm-zswap-remove-unneeded-initialization-to-null-in-zswap_entry_find_get
+++ a/mm/zswap.c
@@ -342,7 +342,7 @@ static void zswap_entry_put(struct zswap
 static struct zswap_entry *zswap_entry_find_get(struct rb_root *root,
 				pgoff_t offset)
 {
-	struct zswap_entry *entry = NULL;
+	struct zswap_entry *entry;
 
 	entry = zswap_rb_search(root, offset);
 	if (entry)
_

Patches currently in -mm which might be from alexey.klimov@linaro.org are

mm-kmemleak-remove-unneeded-initialization-of-object-to-null.patch
mm-zswap-remove-unneeded-initialization-to-null-in-zswap_entry_find_get.patch

