From: akpm@linux-foundation.org
Subject: + list-fix-order-of-arguments-for-hlist_add_after_rcu.patch added to -mm tree
Date: Wed, 11 Jun 2014 14:05:39 -0700
Message-ID: <5398c4a3.xTYk2Mw/O6nJI0JF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaFKVFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 17:05:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com, jeffrey.t.kirsher@intel.com, hughd@google.com, hch@infradead.org, kenhelias@firemail.de

Subject: + list-fix-order-of-arguments-for-hlist_add_after_rcu.patch added to -mm tree
To: kenhelias@firemail.de,hch@infradead.org,hughd@google.com,jeffrey.t.kirsher@intel.com,paulmck@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 14:05:39 -0700


The patch titled
     Subject: list: fix order of arguments for hlist_add_after(_rcu)
has been added to the -mm tree.  Its filename is
     list-fix-order-of-arguments-for-hlist_add_after_rcu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list-fix-order-of-arguments-for-hlist_add_after_rcu.patch

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
Subject: list: fix order of arguments for hlist_add_after(_rcu)

All other add functions for lists have the new item as first argument and
the position where it is added as second argument.  This was changed for
no good reason in this function and makes using it unnecessary confusing.

The name was changed to hlist_add_behind() to cause unconverted code to
generate a compile error instead of using the wrong parameter order.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>	[intel driver bits]
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/RCU/whatisRCU.txt                  |    2 +-
 drivers/gpu/drm/drm_hashtab.c                    |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c   |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |    2 +-
 drivers/staging/lustre/lustre/libcfs/hash.c      |    4 ++--
 fs/namespace.c                                   |    2 +-
 fs/notify/inode_mark.c                           |    2 +-
 fs/notify/vfsmount_mark.c                        |    2 +-
 include/linux/list.h                             |    4 ++--
 include/linux/rculist.h                          |    8 ++++----
 net/batman-adv/fragmentation.c                   |    2 +-
 net/bridge/br_multicast.c                        |    2 +-
 net/ipv4/fib_trie.c                              |    2 +-
 net/ipv6/addrlabel.c                             |    2 +-
 net/xfrm/xfrm_policy.c                           |    4 ++--
 15 files changed, 21 insertions(+), 21 deletions(-)

diff -puN Documentation/RCU/whatisRCU.txt~list-fix-order-of-arguments-for-hlist_add_after_rcu Documentation/RCU/whatisRCU.txt
--- a/Documentation/RCU/whatisRCU.txt~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/Documentation/RCU/whatisRCU.txt
@@ -818,7 +818,7 @@ RCU pointer/list update:
 	list_add_tail_rcu
 	list_del_rcu
 	list_replace_rcu
-	hlist_add_after_rcu
+	hlist_add_behind_rcu
 	hlist_add_before_rcu
 	hlist_add_head_rcu
 	hlist_del_rcu
diff -puN drivers/gpu/drm/drm_hashtab.c~list-fix-order-of-arguments-for-hlist_add_after_rcu drivers/gpu/drm/drm_hashtab.c
--- a/drivers/gpu/drm/drm_hashtab.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/drivers/gpu/drm/drm_hashtab.c
@@ -125,7 +125,7 @@ int drm_ht_insert_item(struct drm_open_h
 		parent = &entry->head;
 	}
 	if (parent) {
-		hlist_add_after_rcu(parent, &item->head);
+		hlist_add_behind_rcu(&item->head, parent);
 	} else {
 		hlist_add_head_rcu(&item->head, h_list);
 	}
diff -puN drivers/net/ethernet/intel/i40e/i40e_ethtool.c~list-fix-order-of-arguments-for-hlist_add_after_rcu drivers/net/ethernet/intel/i40e/i40e_ethtool.c
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1434,7 +1434,7 @@ static int i40e_update_ethtool_fdir_entr
 
 	/* add filter to the list */
 	if (parent)
-		hlist_add_after(&parent->fdir_node, &input->fdir_node);
+		hlist_add_behind(&input->fdir_node, &parent->fdir_node);
 	else
 		hlist_add_head(&input->fdir_node,
 			       &pf->fdir_filter_list);
diff -puN drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c~list-fix-order-of-arguments-for-hlist_add_after_rcu drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2527,7 +2527,7 @@ static int ixgbe_update_ethtool_fdir_ent
 
 	/* add filter to the list */
 	if (parent)
-		hlist_add_after(&parent->fdir_node, &input->fdir_node);
+		hlist_add_behind(&input->fdir_node, &parent->fdir_node);
 	else
 		hlist_add_head(&input->fdir_node,
 			       &adapter->fdir_filter_list);
diff -puN drivers/staging/lustre/lustre/libcfs/hash.c~list-fix-order-of-arguments-for-hlist_add_after_rcu drivers/staging/lustre/lustre/libcfs/hash.c
--- a/drivers/staging/lustre/lustre/libcfs/hash.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/drivers/staging/lustre/lustre/libcfs/hash.c
@@ -351,7 +351,7 @@ cfs_hash_dh_hnode_add(struct cfs_hash *h
 					    cfs_hash_dhead_t, dh_head);
 
 	if (dh->dh_tail != NULL) /* not empty */
-		hlist_add_after(dh->dh_tail, hnode);
+		hlist_add_behind(hnode, dh->dh_tail);
 	else /* empty list */
 		hlist_add_head(hnode, &dh->dh_head);
 	dh->dh_tail = hnode;
@@ -406,7 +406,7 @@ cfs_hash_dd_hnode_add(struct cfs_hash *h
 						cfs_hash_dhead_dep_t, dd_head);
 
 	if (dh->dd_tail != NULL) /* not empty */
-		hlist_add_after(dh->dd_tail, hnode);
+		hlist_add_behind(hnode, dh->dd_tail);
 	else /* empty list */
 		hlist_add_head(hnode, &dh->dd_head);
 	dh->dd_tail = hnode;
diff -puN fs/namespace.c~list-fix-order-of-arguments-for-hlist_add_after_rcu fs/namespace.c
--- a/fs/namespace.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/fs/namespace.c
@@ -798,7 +798,7 @@ static void commit_tree(struct mount *mn
 	list_splice(&head, n->list.prev);
 
 	if (shadows)
-		hlist_add_after_rcu(&shadows->mnt_hash, &mnt->mnt_hash);
+		hlist_add_behind_rcu(&mnt->mnt_hash, &shadows->mnt_hash);
 	else
 		hlist_add_head_rcu(&mnt->mnt_hash,
 				m_hash(&parent->mnt, mnt->mnt_mountpoint));
diff -puN fs/notify/inode_mark.c~list-fix-order-of-arguments-for-hlist_add_after_rcu fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/fs/notify/inode_mark.c
@@ -232,7 +232,7 @@ int fsnotify_add_inode_mark(struct fsnot
 
 	BUG_ON(last == NULL);
 	/* mark should be the last entry.  last is the current last entry */
-	hlist_add_after_rcu(&last->i.i_list, &mark->i.i_list);
+	hlist_add_behind_rcu(&mark->i.i_list, &last->i.i_list);
 out:
 	fsnotify_recalc_inode_mask_locked(inode);
 	spin_unlock(&inode->i_lock);
diff -puN fs/notify/vfsmount_mark.c~list-fix-order-of-arguments-for-hlist_add_after_rcu fs/notify/vfsmount_mark.c
--- a/fs/notify/vfsmount_mark.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/fs/notify/vfsmount_mark.c
@@ -191,7 +191,7 @@ int fsnotify_add_vfsmount_mark(struct fs
 
 	BUG_ON(last == NULL);
 	/* mark should be the last entry.  last is the current last entry */
-	hlist_add_after_rcu(&last->m.m_list, &mark->m.m_list);
+	hlist_add_behind_rcu(&mark->m.m_list, &last->m.m_list);
 out:
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
 	spin_unlock(&mnt->mnt_root->d_lock);
diff -puN include/linux/list.h~list-fix-order-of-arguments-for-hlist_add_after_rcu include/linux/list.h
--- a/include/linux/list.h~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/include/linux/list.h
@@ -654,8 +654,8 @@ static inline void hlist_add_before(stru
 	*(n->pprev) = n;
 }
 
-static inline void hlist_add_after(struct hlist_node *prev,
-				   struct hlist_node *n)
+static inline void hlist_add_behind(struct hlist_node *n,
+				    struct hlist_node *prev)
 {
 	n->next = prev->next;
 	prev->next = n;
diff -puN include/linux/rculist.h~list-fix-order-of-arguments-for-hlist_add_after_rcu include/linux/rculist.h
--- a/include/linux/rculist.h~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/include/linux/rculist.h
@@ -432,9 +432,9 @@ static inline void hlist_add_before_rcu(
 }
 
 /**
- * hlist_add_after_rcu
- * @prev: the existing element to add the new element after.
+ * hlist_add_behind_rcu
  * @n: the new element to add to the hash list.
+ * @prev: the existing element to add the new element after.
  *
  * Description:
  * Adds the specified element to the specified hlist
@@ -449,8 +449,8 @@ static inline void hlist_add_before_rcu(
  * hlist_for_each_entry_rcu(), used to prevent memory-consistency
  * problems on Alpha CPUs.
  */
-static inline void hlist_add_after_rcu(struct hlist_node *prev,
-				       struct hlist_node *n)
+static inline void hlist_add_behind_rcu(struct hlist_node *n,
+				        struct hlist_node *prev)
 {
 	n->next = prev->next;
 	n->pprev = &prev->next;
diff -puN net/batman-adv/fragmentation.c~list-fix-order-of-arguments-for-hlist_add_after_rcu net/batman-adv/fragmentation.c
--- a/net/batman-adv/fragmentation.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/net/batman-adv/fragmentation.c
@@ -184,7 +184,7 @@ static bool batadv_frag_insert_packet(st
 
 	/* Reached the end of the list, so insert after 'frag_entry_curr'. */
 	if (likely(frag_entry_curr)) {
-		hlist_add_after(&frag_entry_curr->list, &frag_entry_new->list);
+		hlist_add_behind(&frag_entry_new->list, &frag_entry_curr->list);
 		chain->size += skb->len - hdr_size;
 		chain->timestamp = jiffies;
 		ret = true;
diff -puN net/bridge/br_multicast.c~list-fix-order-of-arguments-for-hlist_add_after_rcu net/bridge/br_multicast.c
--- a/net/bridge/br_multicast.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/net/bridge/br_multicast.c
@@ -1093,7 +1093,7 @@ static void br_multicast_add_router(stru
 	}
 
 	if (slot)
-		hlist_add_after_rcu(slot, &port->rlist);
+		hlist_add_behind_rcu(&port->rlist, slot);
 	else
 		hlist_add_head_rcu(&port->rlist, &br->router_list);
 }
diff -puN net/ipv4/fib_trie.c~list-fix-order-of-arguments-for-hlist_add_after_rcu net/ipv4/fib_trie.c
--- a/net/ipv4/fib_trie.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/net/ipv4/fib_trie.c
@@ -940,7 +940,7 @@ static void insert_leaf_info(struct hlis
 			last = li;
 		}
 		if (last)
-			hlist_add_after_rcu(&last->hlist, &new->hlist);
+			hlist_add_behind_rcu(&new->hlist, &last->hlist);
 		else
 			hlist_add_before_rcu(&new->hlist, &li->hlist);
 	}
diff -puN net/ipv6/addrlabel.c~list-fix-order-of-arguments-for-hlist_add_after_rcu net/ipv6/addrlabel.c
--- a/net/ipv6/addrlabel.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/net/ipv6/addrlabel.c
@@ -277,7 +277,7 @@ static int __ip6addrlbl_add(struct ip6ad
 		last = p;
 	}
 	if (last)
-		hlist_add_after_rcu(&last->list, &newp->list);
+		hlist_add_behind_rcu(&newp->list, &last->list);
 	else
 		hlist_add_head_rcu(&newp->list, &ip6addrlbl_table.head);
 out:
diff -puN net/xfrm/xfrm_policy.c~list-fix-order-of-arguments-for-hlist_add_after_rcu net/xfrm/xfrm_policy.c
--- a/net/xfrm/xfrm_policy.c~list-fix-order-of-arguments-for-hlist_add_after_rcu
+++ a/net/xfrm/xfrm_policy.c
@@ -389,7 +389,7 @@ redo:
 			if (h != h0)
 				continue;
 			hlist_del(&pol->bydst);
-			hlist_add_after(entry0, &pol->bydst);
+			hlist_add_behind(&pol->bydst, entry0);
 		}
 		entry0 = &pol->bydst;
 	}
@@ -654,7 +654,7 @@ int xfrm_policy_insert(int dir, struct x
 			break;
 	}
 	if (newpos)
-		hlist_add_after(newpos, &policy->bydst);
+		hlist_add_behind(&policy->bydst, newpos);
 	else
 		hlist_add_head(&policy->bydst, chain);
 	xfrm_pol_hold(policy);
_

Patches currently in -mm which might be from kenhelias@firemail.de are

list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch

