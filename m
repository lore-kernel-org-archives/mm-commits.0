From: akpm@linux-foundation.org
Subject: [merged] slab-fix-init_lock_keys.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:36 -0700
Message-ID: <51db1500.RSdYdozuj1PajdOr%akpm__2455.18444940007$1373312273$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GHThh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, penguin-kernel@I-Love.SAKURA.ne.jp, penberg@kernel.org, cl@linux.com

Subject: [merged] slab-fix-init_lock_keys.patch removed from -mm tree
To: cl@linux.com,penberg@kernel.org,penguin-kernel@I-Love.SAKURA.ne.jp,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:36 -0700


The patch titled
     Subject: slab: fix init_lock_keys
has been removed from the -mm tree.  Its filename was
     slab-fix-init_lock_keys.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slab: fix init_lock_keys

Some architectures (e.g. powerpc built with CONFIG_PPC_256K_PAGES=y
CONFIG_FORCE_MAX_ZONEORDER=11) get PAGE_SHIFT + MAX_ORDER > 26.

In 3.10 kernels, CONFIG_LOCKDEP=y with PAGE_SHIFT + MAX_ORDER > 26 makes
init_lock_keys() dereference beyond kmalloc_caches[26].
This leads to an unbootable system (kernel panic at initializing SLAB)
if one of kmalloc_caches[26...PAGE_SHIFT+MAX_ORDER-1] is not NULL.

Fix this by making sure that init_lock_keys() does not dereference beyond
kmalloc_caches[26] arrays.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-Love.SAKURA.ne.jp>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: <stable@vger.kernel.org>	[3.10.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~slab-fix-init_lock_keys mm/slab.c
--- a/mm/slab.c~slab-fix-init_lock_keys
+++ a/mm/slab.c
@@ -565,7 +565,7 @@ static void init_node_lock_keys(int q)
 	if (slab_state < UP)
 		return;
 
-	for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
+	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {
 		struct kmem_cache_node *n;
 		struct kmem_cache *cache = kmalloc_caches[i];
 
_

Patches currently in -mm which might be from cl@linux.com are

linux-next.patch

