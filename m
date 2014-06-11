From: akpm@linux-foundation.org
Subject: + list-use-argument-hlist_add_after-names-from-rcu-variant.patch
 added to -mm tree
Date: Wed, 11 Jun 2014 14:05:38 -0700
Message-ID: <5398c4a2.X3Zu6jx9OqelrcNh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaFKVFj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 17:05:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com, jeffrey.t.kirsher@intel.com, hughd@google.com, hch@infradead.org, kenhelias@firemail.de

Subject: + list-use-argument-hlist_add_after-names-from-rcu-variant.patch added to -mm tree
To: kenhelias@firemail.de,hch@infradead.org,hughd@google.com,jeffrey.t.kirsher@intel.com,paulmck@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 14:05:38 -0700


The patch titled
     Subject: list: make hlist_add_after() argument names match hlist_add_after_rcu()
has been added to the -mm tree.  Its filename is
     list-use-argument-hlist_add_after-names-from-rcu-variant.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list-use-argument-hlist_add_after-names-from-rcu-variant.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list-use-argument-hlist_add_after-names-from-rcu-variant.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch

