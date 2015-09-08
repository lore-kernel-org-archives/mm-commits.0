From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-fix-slab-double-free-in-case-of-duplicate-sysfs-filename.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:03:43 -0700
Message-ID: <55ef22ff.mhrTqttkrMVjKk7D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbbIHSDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: fix slab double-free in case of duplicate sysfs filename
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-slab-double-free-in-case-of-duplicate-sysfs-filename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/slub: fix slab double-free in case of duplicate sysfs filename

sysfs_slab_add() shouldn't call kobject_put at error path: this puts last
reference of kmem-cache kobject and frees it.  Kmem cache will be freed
second time at error path in kmem_cache_create().

For example this happens when slub debug was enabled in runtime and
somebody creates new kmem cache:

# echo 1 | tee /sys/kernel/slab/*/sanity_checks
# modprobe configfs

"configfs_dir_cache" cannot be merged because existing slab have debug and
cannot create new slab because unique name ":t-0000096" already taken.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/slub.c~mm-slub-fix-slab-double-free-in-case-of-duplicate-sysfs-filename mm/slub.c
--- a/mm/slub.c~mm-slub-fix-slab-double-free-in-case-of-duplicate-sysfs-filename
+++ a/mm/slub.c
@@ -5283,7 +5283,7 @@ static int sysfs_slab_add(struct kmem_ca
 	s->kobj.kset = cache_kset(s);
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
 	if (err)
-		goto out_put_kobj;
+		goto out;
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
 	if (err)
@@ -5310,8 +5310,6 @@ out:
 	return err;
 out_del_kobj:
 	kobject_del(&s->kobj);
-out_put_kobj:
-	kobject_put(&s->kobj);
 	goto out;
 }
 
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

pagemap-check-permissions-and-capabilities-at-open-time.patch
pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
pagemap-rework-hugetlb-and-thp-report.patch
pagemap-hide-physical-addresses-from-non-privileged-users.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
pagemap-update-documentation.patch

