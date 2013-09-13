From: akpm@linux-foundation.org
Subject: [merged]
 shrinker-convert-remaining-shrinkers-to-count-scan-api.patch removed from
 -mm tree
Date: Fri, 13 Sep 2013 14:16:25 -0700
Message-ID: <523380a9.EwJKhOyPdZFa550l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab3IMVQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: [merged] shrinker-convert-remaining-shrinkers-to-count-scan-api.patch removed from -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:16:25 -0700


The patch titled
     Subject: shrinker: convert remaining shrinkers to count/scan API
has been removed from the -mm tree.  Its filename was
     shrinker-convert-remaining-shrinkers-to-count-scan-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: shrinker: convert remaining shrinkers to count/scan API

Convert the remaining couple of random shrinkers in the tree to the new
API.

[akpm@linux-foundation.org: fix warnings]
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
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c |   25 ++++++++++++++++++-------
 net/sunrpc/auth.c  |   41 +++++++++++++++++++++++++++--------------
 2 files changed, 45 insertions(+), 21 deletions(-)

diff -puN arch/x86/kvm/mmu.c~shrinker-convert-remaining-shrinkers-to-count-scan-api arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~shrinker-convert-remaining-shrinkers-to-count-scan-api
+++ a/arch/x86/kvm/mmu.c
@@ -4421,13 +4421,12 @@ void kvm_mmu_invalidate_mmio_sptes(struc
 	}
 }
 
-static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
+static unsigned long
+mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct kvm *kvm;
 	int nr_to_scan = sc->nr_to_scan;
-
-	if (nr_to_scan == 0)
-		goto out;
+	unsigned long freed = 0;
 
 	raw_spin_lock(&kvm_lock);
 
@@ -4462,25 +4461,37 @@ static int mmu_shrink(struct shrinker *s
 			goto unlock;
 		}
 
-		prepare_zap_oldest_mmu_page(kvm, &invalid_list);
+		if (prepare_zap_oldest_mmu_page(kvm, &invalid_list))
+			freed++;
 		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 unlock:
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
+static unsigned long
+mmu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
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
@@ -434,12 +434,13 @@ EXPORT_SYMBOL_GPL(rpcauth_destroy_credca
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
 
@@ -451,10 +452,11 @@ rpcauth_prune_expired(struct list_head *
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
 
@@ -467,29 +469,39 @@ rpcauth_prune_expired(struct list_head *
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
+static unsigned long
+rpcauth_cache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
+
 {
 	LIST_HEAD(free);
-	int res;
-	int nr_to_scan = sc->nr_to_scan;
-	gfp_t gfp_mask = sc->gfp_mask;
+	unsigned long freed;
+
+	if ((sc->gfp_mask & GFP_KERNEL) != GFP_KERNEL)
+		return SHRINK_STOP;
 
-	if ((gfp_mask & GFP_KERNEL) != GFP_KERNEL)
-		return (nr_to_scan == 0) ? 0 : -1;
+	/* nothing left, don't come back */
 	if (list_empty(&cred_unused))
-		return 0;
+		return SHRINK_STOP;
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
+static unsigned long
+rpcauth_cache_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
+
+{
+	return (number_cred_unused / 100) * sysctl_vfs_cache_pressure;
 }
 
 /*
@@ -805,7 +817,8 @@ rpcauth_uptodatecred(struct rpc_task *ta
 }
 
 static struct shrinker rpc_cred_shrinker = {
-	.shrink = rpcauth_cache_shrinker,
+	.count_objects = rpcauth_cache_shrink_count,
+	.scan_objects = rpcauth_cache_shrink_scan,
 	.seeks = DEFAULT_SEEKS,
 };
 
_

Patches currently in -mm which might be from dchinner@redhat.com are

origin.patch
linux-next.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

