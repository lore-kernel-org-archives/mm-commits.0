From: akpm@linux-foundation.org
Subject: - slub-change-slub_debug-to-config_slub_debug-in-slubc.patch removed from -mm tree
Date: Tue, 01 Apr 2008 13:32:33 -0700
Message-ID: <200804012032.m31KWXPE011923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758932AbYDAUcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 16:32:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tremyfr@yahoo.fr, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: change SLUB_DEBUG to CONFIG_SLUB_DEBUG in slub.c
has been removed from the -mm tree.  Its filename was
     slub-change-slub_debug-to-config_slub_debug-in-slubc.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slub: change SLUB_DEBUG to CONFIG_SLUB_DEBUG in slub.c
From: Reynes Philippe <tremyfr@yahoo.fr>

SLUB_DEBUG is used, instead of CONFIG_SLUB_DEBUG. So the compilation
failed with the error :

  CC      mm/slub.o
mm/slub.c: In function `show_slab_objects':
mm/slub.c:3674: erreur: implicit declaration of function `count_partial'
mm/slub.c:3674: erreur: `count_free' undeclared (first use in this function)

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-change-slub_debug-to-config_slub_debug-in-slubc mm/slub.c
--- a/mm/slub.c~slub-change-slub_debug-to-config_slub_debug-in-slubc
+++ a/mm/slub.c
@@ -2688,7 +2688,8 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
-#if defined(SLUB_DEBUG) || defined(CONFIG_SLABINFO)
+#if (defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)) || \
+	defined(CONFIG_SLABINFO)
 static unsigned long count_partial(struct kmem_cache_node *n)
 {
 	unsigned long flags;
_

Patches currently in -mm which might be from tremyfr@yahoo.fr are

slub-change-slub_debug-to-config_slub_debug-in-slubc.patch
git-sched-schedc-needs-tickh.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

