From: akpm@linux-foundation.org
Subject: [merged] slub-fix-leak-of-name-in-sysfs_slab_add.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:45:05 -0700
Message-ID: <53446de1.c81CStBYK5BeMMsV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaDHVpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, penberg@kernel.org, davej@fedoraproject.org

Subject: [merged] slub-fix-leak-of-name-in-sysfs_slab_add.patch removed from -mm tree
To: davej@fedoraproject.org,penberg@kernel.org,vdavydov@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:45:05 -0700


The patch titled
     Subject: slub: fix leak of 'name' in sysfs_slab_add
has been removed from the -mm tree.  Its filename was
     slub-fix-leak-of-name-in-sysfs_slab_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jones <davej@fedoraproject.org>
Subject: slub: fix leak of 'name' in sysfs_slab_add

The failure paths of sysfs_slab_add don't release the allocation of 'name'
made by create_unique_id() a few lines above the context of the diff below.
Create a common exit path to make it more obvious what needs freeing.

[vdavydov@parallels.com: free the name only if !unmergeable]
Signed-off-by: Dave Jones <davej@fedoraproject.org>
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN mm/slub.c~slub-fix-leak-of-name-in-sysfs_slab_add mm/slub.c
--- a/mm/slub.c~slub-fix-leak-of-name-in-sysfs_slab_add
+++ a/mm/slub.c
@@ -5214,25 +5214,19 @@ static int sysfs_slab_add(struct kmem_ca
 
 	s->kobj.kset = cache_kset(s);
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
-	if (err) {
-		kobject_put(&s->kobj);
-		return err;
-	}
+	if (err)
+		goto out_put_kobj;
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
-	if (err) {
-		kobject_del(&s->kobj);
-		kobject_put(&s->kobj);
-		return err;
-	}
+	if (err)
+		goto out_del_kobj;
 
 #ifdef CONFIG_MEMCG_KMEM
 	if (is_root_cache(s)) {
 		s->memcg_kset = kset_create_and_add("cgroup", NULL, &s->kobj);
 		if (!s->memcg_kset) {
-			kobject_del(&s->kobj);
-			kobject_put(&s->kobj);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto out_del_kobj;
 		}
 	}
 #endif
@@ -5241,9 +5235,16 @@ static int sysfs_slab_add(struct kmem_ca
 	if (!unmergeable) {
 		/* Setup first alias */
 		sysfs_slab_alias(s, s->name);
-		kfree(name);
 	}
-	return 0;
+out:
+	if (!unmergeable)
+		kfree(name);
+	return err;
+out_del_kobj:
+	kobject_del(&s->kobj);
+out_put_kobj:
+	kobject_put(&s->kobj);
+	goto out;
 }
 
 static void sysfs_slab_remove(struct kmem_cache *s)
_

Patches currently in -mm which might be from davej@fedoraproject.org are

origin.patch

