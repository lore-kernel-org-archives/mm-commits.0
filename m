From: akpm@linux-foundation.org
Subject: [merged] slab_common-fix-the-check-for-duplicate-slab-names.patch removed from -mm tree
Date: Wed, 23 Jul 2014 12:02:10 -0700
Message-ID: <53d006b2.FBmaXXVllHCCVYFx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:56103 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaGWTCL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jul 2014 15:02:11 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so454867pdj.2
        for <mm-commits@vger.kernel.org>; Wed, 23 Jul 2014 12:02:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpatocka@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab_common: fix the check for duplicate slab names
has been removed from the -mm tree.  Its filename was
     slab_common-fix-the-check-for-duplicate-slab-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: slab_common: fix the check for duplicate slab names

3e374919b314 ("slab_common: Do not check for duplicate slab names") is
supposed to fix the problem where kmem_cache_create incorrectly reports
duplicate cache name and fails.  The problem is described in the header of
that patch.

However, the patch doesn't really fix the problem because of these
reasons:

* the logic to test for debugging is reversed. It was intended to perform
  the check only if slub debugging is enabled (which implies that caches
  with the same parameters are not merged). Therefore, there should be
  #if !defined(CONFIG_SLUB) || defined(CONFIG_SLUB_DEBUG_ON)
  The current code has the condition reversed and performs the test if
  debugging is disabled.

* slub debugging may be enabled or disabled based on kernel command line,
  CONFIG_SLUB_DEBUG_ON is just the default settings. Therefore the test
  based on definition of CONFIG_SLUB_DEBUG_ON is unreliable.

This patch fixes the problem by removing the test
"!defined(CONFIG_SLUB_DEBUG_ON)". Therefore, duplicate names are never
checked if the SLUB allocator is used.

Note to stable kernel maintainers: when backporint this patch, please
backport also the patch 3e374919b314f20e2a04f641ebc1093d758f66a4.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>	[3.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab_common.c~slab_common-fix-the-check-for-duplicate-slab-names mm/slab_common.c
--- a/mm/slab_common.c~slab_common-fix-the-check-for-duplicate-slab-names
+++ a/mm/slab_common.c
@@ -55,7 +55,7 @@ static int kmem_cache_sanity_check(const
 			continue;
 		}
 
-#if !defined(CONFIG_SLUB) || !defined(CONFIG_SLUB_DEBUG_ON)
+#if !defined(CONFIG_SLUB)
 		if (!strcmp(s->name, name)) {
 			pr_err("%s (%s): Cache name already exists.\n",
 			       __func__, name);
_

Patches currently in -mm which might be from mpatocka@redhat.com are

origin.patch
linux-next.patch

