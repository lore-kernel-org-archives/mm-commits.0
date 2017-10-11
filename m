From: akpm@linux-foundation.org
Subject: + fs-mm-account-filp-cache-to-kmemcg.patch added to -mm tree
Date: Wed, 11 Oct 2017 15:44:41 -0700
Message-ID: <59de9ed9.LfPOhlbXICWXsn96%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbdJKWom (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 18:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shakeelb@google.com, gthelen@google.com, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, mm: account filp cache to kmemcg
has been added to the -mm tree.  Its filename is
     fs-mm-account-filp-cache-to-kmemcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-mm-account-filp-cache-to-kmemcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-mm-account-filp-cache-to-kmemcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from shakeelb@google.com are

kvm-mm-account-kvm-related-kmem-slabs-to-kmemcg.patch
fs-mm-account-filp-cache-to-kmemcg.patch
epoll-account-epitem-and-eppoll_entry-to-kmemcg.patch

