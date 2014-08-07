From: akpm@linux-foundation.org
Subject: [merged]
 list-use-argument-hlist_add_after-names-from-rcu-variant.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:07:31 -0700
Message-ID: <53e3dc83.E7QFhawM2mWXghEg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:51476 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaHGUHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:32 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so843509oac.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenhelias@firemail.de, hch@infradead.org, hughd@google.com, jeffrey.t.kirsher@intel.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: list: make hlist_add_after() argument names match hlist_add_after_rcu()
has been removed from the -mm tree.  Its filename was
     list-use-argument-hlist_add_after-names-from-rcu-variant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ken Helias <kenhelias@firemail.de>
Subject: list: make hlist_add_after() argument names match hlist_add_after_rcu()

The argument names for hlist_add_after() are poorly chosen because they
look the same as the ones for hlist_add_before() but have to be used
differently.

hlist_add_after_rcu() has made a better choice.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/list.h~list-use-argument-hlist_add_after-names-from-rcu-variant include/linux/list.h
--- a/include/linux/list.h~list-use-argument-hlist_add_after-names-from-rcu-variant
+++ a/include/linux/list.h
@@ -654,15 +654,15 @@ static inline void hlist_add_before(stru
 	*(n->pprev) = n;
 }
 
-static inline void hlist_add_after(struct hlist_node *n,
-					struct hlist_node *next)
+static inline void hlist_add_after(struct hlist_node *prev,
+				   struct hlist_node *n)
 {
-	next->next = n->next;
-	n->next = next;
-	next->pprev = &n->next;
+	n->next = prev->next;
+	prev->next = n;
+	n->pprev = &prev->next;
 
-	if(next->next)
-		next->next->pprev  = &next->next;
+	if (n->next)
+		n->next->pprev  = &n->next;
 }
 
 /* after that we'll appear to be on some hlist and hlist_del will work */
_

Patches currently in -mm which might be from kenhelias@firemail.de are

origin.patch

