From: akpm@linux-foundation.org
Subject: [merged] mm-list_lruc-avoid-error-path-null-pointer-deref.patch
 removed from -mm tree
Date: Fri, 28 Oct 2016 11:30:19 -0700
Message-ID: <5813993b.3nkQOxm7sgAkvqIa%akpm__21639.055645983$1477679522$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966097AbcJ1SaU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 14:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apolyakov@beget.ru, stable@vger.kernel.org, vdavydov.dev@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: avoid error-path NULL pointer deref
has been removed from the -mm tree.  Its filename was
     mm-list_lruc-avoid-error-path-null-pointer-deref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Polakov <apolyakov@beget.ru>
Subject: mm/list_lru.c: avoid error-path NULL pointer deref

As described in https://bugzilla.kernel.org/show_bug.cgi?id=177821:

After some analysis it seems to be that the problem is in alloc_super(). 
In case list_lru_init_memcg() fails it goes into destroy_super(), which
calls list_lru_destroy().

And in list_lru_init() we see that in case memcg_init_list_lru() fails,
lru->node is freed, but not set NULL, which then leads list_lru_destroy()
to believe it is initialized and call memcg_destroy_list_lru(). 
memcg_destroy_list_lru() in turn can access lru->node[i].memcg_lrus, which
is NULL.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Alexander Polakov <apolyakov@beget.ru>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/list_lru.c~mm-list_lruc-avoid-error-path-null-pointer-deref mm/list_lru.c
--- a/mm/list_lru.c~mm-list_lruc-avoid-error-path-null-pointer-deref
+++ a/mm/list_lru.c
@@ -554,6 +554,8 @@ int __list_lru_init(struct list_lru *lru
 	err = memcg_init_list_lru(lru, memcg_aware);
 	if (err) {
 		kfree(lru->node);
+		/* Do this so a list_lru_destroy() doesn't crash: */
+		lru->node = NULL;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from apolyakov@beget.ru are


