From: akpm@linux-foundation.org
Subject: + mm-list_lruc-avoid-error-path-null-pointer-deref.patch added to -mm tree
Date: Mon, 17 Oct 2016 16:57:12 -0700
Message-ID: <58056558.xBVOX3rEjQaLwzJR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934292AbcJQX5N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2016 19:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apolyakov@beget.ru, stable@vger.kernel.org, vdavydov@parallels.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: avoid error-path NULL pointer deref
has been added to the -mm tree.  Its filename is
     mm-list_lruc-avoid-error-path-null-pointer-deref.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-list_lruc-avoid-error-path-null-pointer-deref.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lruc-avoid-error-path-null-pointer-deref.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Vladimir Davydov <vdavydov@parallels.com>
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

mm-list_lruc-avoid-error-path-null-pointer-deref.patch

