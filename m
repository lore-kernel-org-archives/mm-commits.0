From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch
 removed from -mm tree
Date: Wed, 20 Jan 2016 14:42:21 -0800
Message-ID: <56a00d4d.82zGKwjbe6WGT/d1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbcATWmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:42:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix SLOB build regression
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

This patch was dropped because it was folded into mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: memcg: fix SLOB build regression

A recent cleanup broke the build when CONFIG_SLOB is used:

mm/memcontrol.c: In function 'memcg_update_kmem_limit':
mm/memcontrol.c:2974:9: error: implicit declaration of function 'memcg_online_kmem' [-Werror=implicit-function-declaration]
mm/memcontrol.c: In function 'mem_cgroup_css_alloc':
mm/memcontrol.c:4229:10: error: too many arguments to function 'memcg_propagate_kmem'
mm/memcontrol.c:2949:12: note: declared here

This fixes the memcg_propagate_kmem prototype to match the normal
implementation and adds the respective memcg_online_kmem helper
function that was needed.

Fixes: a5ed904c5039 ("mm: memcontrol: clean up alloc, online, offline, free functions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2
+++ a/mm/memcontrol.c
@@ -2941,7 +2941,11 @@ static void memcg_free_kmem(struct mem_c
 	}
 }
 #else
-static int memcg_propagate_kmem(struct mem_cgroup *memcg)
+static int memcg_propagate_kmem(struct mem_cgroup *parent, struct mem_cgroup *memcg)
+{
+	return 0;
+}
+static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch

