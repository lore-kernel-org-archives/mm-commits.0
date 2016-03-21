From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-list_blh-use-bool-instead-of-int-for-boolean-functions.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:26 -0700
Message-ID: <56f04056.QjvyWBnfBspNimHb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947AbcCUTVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chengang@emindsoft.com.cn, gang.chen.5i5j@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/list_bl.h: use bool instead of int for boolean functions
has been removed from the -mm tree.  Its filename was
     include-linux-list_blh-use-bool-instead-of-int-for-boolean-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


