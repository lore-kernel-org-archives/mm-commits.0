From: akpm@linux-foundation.org
Subject: + mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch
 added to -mm tree
Date: Wed, 09 Dec 2015 16:31:50 -0800
Message-ID: <5668c7f6.chmiolxyOj3SQw6b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbLJAbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:31:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: only manage socket pressure for CONFIG_INET
has been added to the -mm tree.  Its filename is
     mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch

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
Subject: mm: memcontrol: only manage socket pressure for CONFIG_INET

When IPV4 support is disabled, the memcg->socket_pressure field is
not defined and we get a build error from the vmpressure code:

mm/vmpressure.c: In function 'vmpressure':
mm/vmpressure.c:287:9: error: 'struct mem_cgroup' has no member named 'socket_pressure'
    memcg->socket_pressure = jiffies + HZ;
mm/built-in.o: In function `mem_cgroup_css_free':
:(.text+0x1c03a): undefined reference to `tcp_destroy_cgroup'
mm/built-in.o: In function `mem_cgroup_css_online':
:(.text+0x1c20e): undefined reference to `tcp_init_cgroup'

This puts the code causing this in the same #ifdef that guards the
struct member and the TCP implementation.

Fixes: 20cc40e66c42 ("mm: memcontrol: hook up vmpressure to socket pressure")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 mm/vmpressure.c |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-introduce-config_memcg_legacy_kmem-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-introduce-config_memcg_legacy_kmem-fix
+++ a/mm/memcontrol.c
@@ -4223,13 +4223,13 @@ mem_cgroup_css_online(struct cgroup_subs
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_INET
 #ifdef CONFIG_MEMCG_LEGACY_KMEM
 	ret = tcp_init_cgroup(memcg);
 	if (ret)
 		return ret;
 #endif
 
-#ifdef CONFIG_INET
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_inc(&memcg_sockets_enabled_key);
 #endif
@@ -4279,7 +4279,7 @@ static void mem_cgroup_css_free(struct c
 
 	memcg_free_kmem(memcg);
 
-#ifdef CONFIG_MEMCG_LEGACY_KMEM
+#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
 	tcp_destroy_cgroup(memcg);
 #endif
 
diff -puN mm/vmpressure.c~mm-memcontrol-introduce-config_memcg_legacy_kmem-fix mm/vmpressure.c
--- a/mm/vmpressure.c~mm-memcontrol-introduce-config_memcg_legacy_kmem-fix
+++ a/mm/vmpressure.c
@@ -275,6 +275,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 
 		level = vmpressure_calc_level(scanned, reclaimed);
 
+#ifdef CONFIG_INET
 		if (level > VMPRESSURE_LOW) {
 			/*
 			 * Let the socket buffer allocator know that
@@ -286,6 +287,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 			 */
 			memcg->socket_pressure = jiffies + HZ;
 		}
+#endif
 	}
 }
 
_

Patches currently in -mm which might be from arnd@arndb.de are

include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch

