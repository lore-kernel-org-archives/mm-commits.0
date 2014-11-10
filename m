From: akpm@linux-foundation.org
Subject: [withdrawn]
 slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix.patch removed
 from -mm tree
Date: Mon, 10 Nov 2014 14:16:02 -0800
Message-ID: <54613922.b2f+8kEPOfon5qAW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaKJWQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:16:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, sfr@canb.auug.org.au, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: Always predeclare slab_free()
has been removed from the -mm tree.  Its filename was
     slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: mm/slab: Always predeclare slab_free()

Commit 5da1c3c725ab ("slab: recharge slab pages to the allocating memory
cgroup") added a predeclaration of the new slab_free() helper so that it
can be used in slab_alloc_node() and slab_alloc().  However the prototype
is added in an #ifdef CONFIG_NUMA protected section of code, which works
fine for slab_alloc_node() but fails for slab_alloc().

Fixes the following build warnings and errors:

	mm/slab.c: In function 'slab_alloc':
	mm/slab.c:3260:4: error: implicit declaration of function 'slab_free' [-Werror=implicit-function-declaration]
	    slab_free(cachep, objp);
	    ^
	mm/slab.c: At top level:
	mm/slab.c:3534:29: warning: conflicting types for 'slab_free'
	 static __always_inline void slab_free(struct kmem_cache *cachep, void *objp)
				     ^
	mm/slab.c:3534:29: error: static declaration of 'slab_free' follows non-static declaration
	mm/slab.c:3260:4: note: previous implicit declaration of 'slab_free' was here
	    slab_free(cachep, objp);
	    ^

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix mm/slab.c
--- a/mm/slab.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix
+++ a/mm/slab.c
@@ -2961,6 +2961,8 @@ out:
 	return objp;
 }
 
+static __always_inline void slab_free(struct kmem_cache *cachep, void *objp);
+
 #ifdef CONFIG_NUMA
 /*
  * Try allocating on another node if PFA_SPREAD_SLAB is a mempolicy is set.
@@ -3133,8 +3135,6 @@ done:
 	return obj;
 }
 
-static __always_inline void slab_free(struct kmem_cache *cachep, void *objp);
