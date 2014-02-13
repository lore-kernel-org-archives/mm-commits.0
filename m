From: akpm@linux-foundation.org
Subject: [failures] slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
 removed from -mm tree
Date: Thu, 13 Feb 2014 11:54:00 -0800
Message-ID: <52fd22d8.B3fSt0t5cUbl53W9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaBMTyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 14:54:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, greg@kroah.com, cl@linux.com, vdavydov@parallels.com

Subject: [failures] slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux.com,greg@kroah.com,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 11:54:00 -0800


The patch titled
     Subject: slub: do not drop slab_mutex for sysfs_slab_add
has been removed from the -mm tree.  Its filename was
     slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: do not drop slab_mutex for sysfs_slab_add

We release the slab_mutex while calling sysfs_slab_add from
__kmem_cache_create since commit 66c4c35c6bc5 ("slub: Do not hold
slub_lock when calling sysfs_slab_add()"), because kobject_uevent called
by sysfs_slab_add might block waiting for the usermode helper to exec,
which would result in a deadlock if we took the slab_mutex while executing
it.

However, apart from complicating synchronization rules, releasing the
slab_mutex on kmem cache creation can result in a kmemcg-related race. 
The point is that we check if the memcg cache exists before going to
__kmem_cache_create, but register the new cache in memcg subsys after it. 
Since we can drop the mutex there, several threads can see that the memcg
cache does not exist and proceed to creating it, which is wrong.

Fortunately, recently kobject_uevent was patched to call the usermode
helper with the UMH_NO_WAIT flag, making the deadlock impossible. 
Therefore there is no point in releasing the slab_mutex while calling
sysfs_slab_add, so let's simplify kmem_cache_create synchronization and
fix the kmemcg-race mentioned above by holding the slab_mutex during the
whole cache creation path.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/slub.c~slub-do-not-drop-slab_mutex-for-sysfs_slab_add mm/slub.c
--- a/mm/slub.c~slub-do-not-drop-slab_mutex-for-sysfs_slab_add
+++ a/mm/slub.c
@@ -3237,8 +3237,9 @@ int __kmem_cache_shutdown(struct kmem_ca
 
 	if (!rc) {
 		/*
-		 * We do the same lock strategy around sysfs_slab_add, see
-		 * __kmem_cache_create. Because this is pretty much the last
+		 * Since slab_attr_store may take the slab_mutex, we should
+		 * release the lock while removing the sysfs entry in order to
+		 * avoid a deadlock. Because this is pretty much the last
 		 * operation we do and the lock will be released shortly after
 		 * that in slab_common.c, we could just move sysfs_slab_remove
 		 * to a later point in common code. We should do that when we
@@ -3778,10 +3779,7 @@ int __kmem_cache_create(struct kmem_cach
 		return 0;
 
 	memcg_propagate_slab_attrs(s);
-	mutex_unlock(&slab_mutex);
 	err = sysfs_slab_add(s);
-	mutex_lock(&slab_mutex);
