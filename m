From: akpm@linux-foundation.org
Subject: [patch 074/131] fs, mm: account filp cache to kmemcg
Date: Wed, 15 Nov 2017 17:35:44 -0800
Message-ID: <20171116013544.HlmKOXa45%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39664 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933189AbdKPBfq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:35:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com, viro@zeniv.linux.org.uk

From: Shakeel Butt <shakeelb@google.com>
Subject: fs, mm: account filp cache to kmemcg

The allocations from filp cache can be directly triggered by userspace
applications.  A buggy application can consume a significant amount of
unaccounted system memory.  Though we have not noticed such buggy
applications in our production but upon close inspection, we found that a
lot of machines spend very significant amount of memory on these caches.

One way to limit allocations from filp cache is to set system level limit
of maximum number of open files.  However this limit is shared between
different users on the system and one user can hog this resource.  To
cater that, we can charge filp to kmemcg and set the maximum limit very
high and let the memory limit of each user limit the number of files they
can open and indirectly limiting their allocations from filp cache.

One side effect of this change is that it will allow _sysctl() to return
ENOMEM and the man page of _sysctl() does not specify that.  However the
man page also discourages to use _sysctl() at all.

Link: http://lkml.kernel.org/r/20171011190359.34926-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/file_table.c~fs-mm-account-filp-cache-to-kmemcg fs/file_table.c
--- a/fs/file_table.c~fs-mm-account-filp-cache-to-kmemcg
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
