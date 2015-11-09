From: akpm@linux-foundation.org
Subject: [merged]
 mm-zswap-remove-unneeded-initialization-to-null-in-zswap_entry_find_get.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:44:56 -0800
Message-ID: <5640f7b8.w+LftUliORpMKFLz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbbKITo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexey.klimov@linaro.org, ddstreet@ieee.org, minchan@kernel.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: remove unneeded initialization to NULL in zswap_entry_find_get()
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-unneeded-initialization-to-null-in-zswap_entry_find_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


