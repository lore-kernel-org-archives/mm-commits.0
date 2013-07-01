From: akpm@linux-foundation.org
Subject: + slab-fix-init_lock_keys.patch added to -mm tree
Date: Mon, 01 Jul 2013 13:09:10 -0700
Message-ID: <51d1e1e6.QGP2xtTPKJr7RPK7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3GAUJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jul 2013 16:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, penguin-kernel@I-Love.SAKURA.ne.jp, penberg@kernel.org, cl@linux.com

Subject: + slab-fix-init_lock_keys.patch added to -mm tree
To: cl@linux.com,penberg@kernel.org,penguin-kernel@I-Love.SAKURA.ne.jp,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 01 Jul 2013 13:09:10 -0700


The patch titled
     Subject: slab: fix init_lock_keys
has been added to the -mm tree.  Its filename is
     slab-fix-init_lock_keys.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ slab-fix-init_lock_keys.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ slab-fix-init_lock_keys.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slab: fix init_lock_keys

init_lock_keys() goes too far in initializing values in kmalloc_caches
because it assumed that the size of the kmalloc array goes up to
MAX_ORDER.  However, the size of the kmalloc array for SLAB may be
restricted due to increased page sizes or CONFIG_FORCE_MAX_ZONEORDER.

Tetsuo said:

: It hangs (with CPU#0 spinning) immediately after printing
: 
:   Decompressing Linux... Parsing ELF... done.
:   Booting the kernel.
: 
: lines.

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
slab-fix-init_lock_keys.patch

