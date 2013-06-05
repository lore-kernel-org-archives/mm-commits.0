From: akpm@linux-foundation.org
Subject: + shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
 added to -mm tree
Date: Wed, 05 Jun 2013 16:11:13 -0700
Message-ID: <51afc591.lAhVRM3csEXg/3hd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab3FEXLO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 19:11:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, riel@redhat.com, penberg@kernel.org, mtosatti@redhat.com, mhocko@suse.cz, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hughd@google.com, hch@lst.de, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, anton@enomsg.org, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: + shrinker-convert-remaining-shrinkers-to-count-scan-api.patch added to -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,anton@enomsg.org,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hch@lst.de,hughd@google.com,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mhocko@suse.cz,mtosatti@redhat.com,penberg@kernel.org,riel@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 16:11:13 -0700


The patch titled
     Subject: shrinker: convert remaining shrinkers to count/scan API
has been added to the -mm tree.  Its filename is
     shrinker-convert-remaining-shrinkers-to-count-scan-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: shrinker: convert remaining shrinkers to count/scan API

Convert the remaining couple of random shrinkers in the tree to the new
API.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c |   28 ++++++++++++++++++++------
 net/sunrpc/auth.c  |   45 +++++++++++++++++++++++++++++--------------
 2 files changed, 52 insertions(+), 21 deletions(-)

diff -puN arch/x86/kvm/mmu.c~shrinker-convert-remaining-shrinkers-to-count-scan-api arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~shrinker-convert-remaining-shrinkers-to-count-scan-api
+++ a/arch/x86/kvm/mmu.c
@@ -4213,13 +4213,14 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
-static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
+static long
+mmu_shrink_scan(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
 {
 	struct kvm *kvm;
 	int nr_to_scan = sc->nr_to_scan;
-
-	if (nr_to_scan == 0)
-		goto out;
+	long freed = 0;
 
 	raw_spin_lock(&kvm_lock);
 
@@ -4247,24 +4248,37 @@ static int mmu_shrink(struct shrinker *s
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
 
-		prepare_zap_oldest_mmu_page(kvm, &invalid_list);
+		freed += prepare_zap_oldest_mmu_page(kvm, &invalid_list);
 		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 		spin_unlock(&kvm->mmu_lock);
 		srcu_read_unlock(&kvm->srcu, idx);
 
+		/*
+		 * unfair on small ones
+		 * per-vm shrinkers cry out
+		 * sadness comes quickly
+		 */
 		list_move_tail(&kvm->vm_list, &vm_list);
 		break;
 	}
 
 	raw_spin_unlock(&kvm_lock);
+	return freed;
 
-out:
+}
+
+static long
+mmu_shrink_count(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
 	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
 }
 
 static struct shrinker mmu_shrinker = {
-	.shrink = mmu_shrink,
+	.count_objects = mmu_shrink_count,
+	.scan_objects = mmu_shrink_scan,
 	.seeks = DEFAULT_SEEKS * 10,
 };
 
diff -puN net/sunrpc/auth.c~shrinker-convert-remaining-shrinkers-to-count-scan-api net/sunrpc/auth.c
--- a/net/sunrpc/auth.c~shrinker-convert-remaining-shrinkers-to-count-scan-api
+++ a/net/sunrpc/auth.c
@@ -413,12 +413,13 @@ EXPORT_SYMBOL_GPL(rpcauth_destroy_credca
 /*
  * Remove stale credentials. Avoid sleeping inside the loop.
  */
-static int
+static long
 rpcauth_prune_expired(struct list_head *free, int nr_to_scan)
 {
 	spinlock_t *cache_lock;
 	struct rpc_cred *cred, *next;
 	unsigned long expired = jiffies - RPC_AUTH_EXPIRY_MORATORIUM;
+	long freed = 0;
 
 	list_for_each_entry_safe(cred, next, &cred_unused, cr_lru) {
 
@@ -430,10 +431,11 @@ rpcauth_prune_expired(struct list_head *
 		 */
 		if (time_in_range(cred->cr_expire, expired, jiffies) &&
 		    test_bit(RPCAUTH_CRED_HASHED, &cred->cr_flags) != 0)
-			return 0;
+			break;
 
 		list_del_init(&cred->cr_lru);
 		number_cred_unused--;
+		freed++;
 		if (atomic_read(&cred->cr_count) != 0)
 			continue;
 
@@ -446,29 +448,43 @@ rpcauth_prune_expired(struct list_head *
 		}
 		spin_unlock(cache_lock);
 	}
-	return (number_cred_unused / 100) * sysctl_vfs_cache_pressure;
+	return freed;
 }
 
 /*
  * Run memory cache shrinker.
  */
-static int
-rpcauth_cache_shrinker(struct shrinker *shrink, struct shrink_control *sc)
+static long
+rpcauth_cache_shrink_scan(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+
 {
 	LIST_HEAD(free);
-	int res;
-	int nr_to_scan = sc->nr_to_scan;
-	gfp_t gfp_mask = sc->gfp_mask;
+	long freed;
+
+	if ((sc->gfp_mask & GFP_KERNEL) != GFP_KERNEL)
+		return -1;
 
-	if ((gfp_mask & GFP_KERNEL) != GFP_KERNEL)
-		return (nr_to_scan == 0) ? 0 : -1;
+	/* nothing left, don't come back */
 	if (list_empty(&cred_unused))
-		return 0;
+		return -1;
+
 	spin_lock(&rpc_credcache_lock);
-	res = rpcauth_prune_expired(&free, nr_to_scan);
+	freed = rpcauth_prune_expired(&free, sc->nr_to_scan);
 	spin_unlock(&rpc_credcache_lock);
 	rpcauth_destroy_credlist(&free);
-	return res;
+
+	return freed;
+}
+
+static long
+rpcauth_cache_shrink_count(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+
+{
+	return (number_cred_unused / 100) * sysctl_vfs_cache_pressure;
 }
 
 /*
@@ -784,7 +800,8 @@ rpcauth_uptodatecred(struct rpc_task *ta
 }
 
 static struct shrinker rpc_cred_shrinker = {
-	.shrink = rpcauth_cache_shrinker,
+	.count_objects = rpcauth_cache_shrink_count,
+	.scan_objects = rpcauth_cache_shrink_scan,
 	.seeks = DEFAULT_SEEKS,
 };
 
_

Patches currently in -mm which might be from dchinner@redhat.com are

linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list-fix.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
list_lru-per-node-api.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
vmscan-also-shrink-slab-in-memcg-pressure.patch
memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

