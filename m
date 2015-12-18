From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch
 added to -mm tree
Date: Fri, 18 Dec 2015 12:58:30 -0800
Message-ID: <56747376.QrZaq+Gc47J196qX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbbLRU6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 15:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix SLOB build regression
has been added to the -mm tree.  Its filename is
     mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2943,7 +2943,11 @@ static void memcg_free_kmem(struct mem_c
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

include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

