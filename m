From: akpm@linux-foundation.org
Subject: + mm-zswap-change-incorrect-strncmp-use-to-strcmp.patch added to
 -mm tree
Date: Fri, 11 Dec 2015 15:42:53 -0800
Message-ID: <566b5f7d.HPv1uw4RxYHV/zSO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbbLKXmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 18:42:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sjennings@variantweb.net, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: change incorrect strncmp use to strcmp
has been added to the -mm tree.  Its filename is
     mm-zswap-change-incorrect-strncmp-use-to-strcmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-change-incorrect-strncmp-use-to-strcmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-change-incorrect-strncmp-use-to-strcmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: mm/zswap: change incorrect strncmp use to strcmp

Change the use of strncmp in zswap_pool_find_get() to strcmp.

The use of strncmp is no longer correct, now that zswap_zpool_type is not
an array; sizeof() will return the size of a pointer, which isn't the
right length to compare.  We don't need to use strncmp anyway, because the
existing params and the passed in params are all guaranteed to be null
terminated, so strcmp should be used.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Reported-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/zswap.c~mm-zswap-change-incorrect-strncmp-use-to-strcmp mm/zswap.c
--- a/mm/zswap.c~mm-zswap-change-incorrect-strncmp-use-to-strcmp
+++ a/mm/zswap.c
@@ -541,6 +541,7 @@ static struct zswap_pool *zswap_pool_las
 	return last;
 }
 
+/* type and compressor must be null-terminated */
 static struct zswap_pool *zswap_pool_find_get(char *type, char *compressor)
 {
 	struct zswap_pool *pool;
@@ -548,10 +549,9 @@ static struct zswap_pool *zswap_pool_fin
 	assert_spin_locked(&zswap_pools_lock);
 
 	list_for_each_entry_rcu(pool, &zswap_pools, list) {
-		if (strncmp(pool->tfm_name, compressor, sizeof(pool->tfm_name)))
+		if (strcmp(pool->tfm_name, compressor))
 			continue;
-		if (strncmp(zpool_get_type(pool->zpool), type,
-			    sizeof(zswap_zpool_type)))
+		if (strcmp(zpool_get_type(pool->zpool), type))
 			continue;
 		/* if we can't get it, it's about to be destroyed */
 		if (!zswap_pool_get(pool))
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zswap-change-incorrect-strncmp-use-to-strcmp.patch

