From: akpm@linux-foundation.org
Subject: +
 include-linux-list_blh-use-bool-instead-of-int-for-boolean-functions.patch
 added to -mm tree
Date: Mon, 25 Jan 2016 17:00:41 -0800
Message-ID: <56a6c539.Dp8Q+44xMeMIfKRt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbcAZBAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 20:00:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chengang@emindsoft.com.cn, gang.chen.5i5j@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/list_bl.h: use bool instead of int for boolean functions
has been added to the -mm tree.  Its filename is
     include-linux-list_blh-use-bool-instead-of-int-for-boolean-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-list_blh-use-bool-instead-of-int-for-boolean-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-list_blh-use-bool-instead-of-int-for-boolean-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <chengang@emindsoft.com.cn>
Subject: include/linux/list_bl.h: use bool instead of int for boolean functions

hlist_bl_unhashed() and hlist_bl_empty() are all boolean functions, so
return bool instead of int.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_bl.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/list_bl.h~include-linux-list_blh-use-bool-instead-of-int-for-boolean-functions include/linux/list_bl.h
--- a/include/linux/list_bl.h~include-linux-list_blh-use-bool-instead-of-int-for-boolean-functions
+++ a/include/linux/list_bl.h
@@ -48,7 +48,7 @@ static inline void INIT_HLIST_BL_NODE(st
 
 #define hlist_bl_entry(ptr, type, member) container_of(ptr,type,member)
 
-static inline int hlist_bl_unhashed(const struct hlist_bl_node *h)
+static inline bool  hlist_bl_unhashed(const struct hlist_bl_node *h)
 {
 	return !h->pprev;
 }
@@ -68,7 +68,7 @@ static inline void hlist_bl_set_first(st
 	h->first = (struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK);
 }
 
-static inline int hlist_bl_empty(const struct hlist_bl_head *h)
+static inline bool hlist_bl_empty(const struct hlist_bl_head *h)
 {
 	return !((unsigned long)READ_ONCE(h->first) & ~LIST_BL_LOCKMASK);
 }
_

Patches currently in -mm which might be from chengang@emindsoft.com.cn are

include-linux-list_blh-use-bool-instead-of-int-for-boolean-functions.patch

