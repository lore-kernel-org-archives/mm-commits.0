From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fs-mm-account-filp-and-names-caches-to-kmemcg.patch removed from -mm tree
Date: Wed, 11 Oct 2017 15:44:05 -0700
Message-ID: <59de9eb5.EoaSo60wT30zHaAb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdJKWoH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 18:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shakeelb@google.com, gthelen@google.com, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, mm: account filp and names caches to kmemcg
has been removed from the -mm tree.  Its filename was
     fs-mm-account-filp-and-names-caches-to-kmemcg.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: fs, mm: account filp and names caches to kmemcg

The allocations from filp and names kmem caches can be directly triggered
by user space applications.  A buggy application can consume a significant
amount of unaccounted system memory.  Though we have not noticed such
buggy applications in our production but upon close inspection, we found
that a lot of machines spend very significant amount of memory on these
caches.  So, these caches should be accounted to kmemcg.

Link: http://lkml.kernel.org/r/20171005222144.123797-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c     |    2 +-
 fs/file_table.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dcache.c~fs-mm-account-filp-and-names-caches-to-kmemcg fs/dcache.c
--- a/fs/dcache.c~fs-mm-account-filp-and-names-caches-to-kmemcg
+++ a/fs/dcache.c
@@ -3641,7 +3641,7 @@ void __init vfs_caches_init_early(void)
 void __init vfs_caches_init(void)
 {
 	names_cachep = kmem_cache_create("names_cache", PATH_MAX, 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
 
 	dcache_init();
 	inode_init();
diff -puN fs/file_table.c~fs-mm-account-filp-and-names-caches-to-kmemcg fs/file_table.c
--- a/fs/file_table.c~fs-mm-account-filp-and-names-caches-to-kmemcg
+++ a/fs/file_table.c
@@ -312,7 +312,7 @@ void put_filp(struct file *file)
 void __init files_init(void)
 {
 	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
-			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT, NULL);
 	percpu_counter_init(&nr_files, 0, GFP_KERNEL);
 }
 
_

Patches currently in -mm which might be from shakeelb@google.com are

kvm-mm-account-kvm-related-kmem-slabs-to-kmemcg.patch
fs-mm-account-filp-cache-to-kmemcg-v2.patch
epoll-account-epitem-and-eppoll_entry-to-kmemcg.patch

