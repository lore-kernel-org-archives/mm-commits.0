From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch removed
 from -mm tree
Date: Wed, 20 Jan 2016 14:40:16 -0800
Message-ID: <56a00cd0.IPFt8bQVL0QtbNkO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbcATWkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:40:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch

This patch was dropped because it was folded into mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/slab.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix include/linux/slab.h
--- a/include/linux/slab.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix
+++ a/include/linux/slab.h
@@ -86,7 +86,7 @@
 #else
 # define SLAB_FAILSLAB		0x00000000UL
 #endif
-#ifdef CONFIG_MEMCG_KMEM
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 # define SLAB_ACCOUNT		0x04000000UL	/* Account to memcg */
 #else
 # define SLAB_ACCOUNT		0x00000000UL
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

