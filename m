From: akpm@linux-foundation.org
Subject: [merged] mm-zswap-add-__init-to-some-functions-in-zswap.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:09:04 -0800
Message-ID: <548d0d60.Ufq++mFBRLXQh3kK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaLNEI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, ddstreet@ieee.org, minchan@kernel.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: add __init to some functions in zswap
has been removed from the -mm tree.  Its filename was
     mm-zswap-add-__init-to-some-functions-in-zswap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: mm/zswap: add __init to some functions in zswap

zswap_cpu_init/zswap_comp_exit/zswap_entry_cache_create is only called by
__init init_zswap()

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/zswap.c~mm-zswap-add-__init-to-some-functions-in-zswap mm/zswap.c
--- a/mm/zswap.c~mm-zswap-add-__init-to-some-functions-in-zswap
+++ a/mm/zswap.c
@@ -149,7 +149,7 @@ static int __init zswap_comp_init(void)
 	return 0;
 }
 
-static void zswap_comp_exit(void)
+static void __init zswap_comp_exit(void)
 {
 	/* free percpu transforms */
 	if (zswap_comp_pcpu_tfms)
@@ -206,7 +206,7 @@ static struct zswap_tree *zswap_trees[MA
 **********************************/
 static struct kmem_cache *zswap_entry_cache;
 
-static int zswap_entry_cache_create(void)
+static int __init zswap_entry_cache_create(void)
 {
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	return zswap_entry_cache == NULL;
@@ -389,7 +389,7 @@ static struct notifier_block zswap_cpu_n
 	.notifier_call = zswap_cpu_notifier
 };
 
-static int zswap_cpu_init(void)
+static int __init zswap_cpu_init(void)
 {
 	unsigned long cpu;
 
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

origin.patch

