From: akpm@linux-foundation.org
Subject: + documentation-memcg-warn-about-incomplete-kmemcg-state.patch
 added to -mm tree
Date: Mon, 21 Apr 2014 13:38:29 -0700
Message-ID: <535581c5.SsI8rr4ZHjUDlRH9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaDUUia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 16:38:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, vdavydov@parallels.com

Subject: + documentation-memcg-warn-about-incomplete-kmemcg-state.patch added to -mm tree
To: vdavydov@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 13:38:29 -0700


The patch titled
     Subject: Documentation/memcg: warn about incomplete kmemcg state
has been added to the -mm tree.  Its filename is
     documentation-memcg-warn-about-incomplete-kmemcg-state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-memcg-warn-about-incomplete-kmemcg-state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-memcg-warn-about-incomplete-kmemcg-state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Documentation/memcg: warn about incomplete kmemcg state

Kmemcg is currently under development and lacks some important features. 
In particular, it does not have support of kmem reclaim on memory pressure
inside cgroup, which practically makes it unusable in real life.  Let's
warn about it in both Kconfig and Documentation to prevent complaints
arising.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    5 +++++
 init/Kconfig                     |    6 ++++++
 2 files changed, 11 insertions(+)

diff -puN Documentation/cgroups/memory.txt~documentation-memcg-warn-about-incomplete-kmemcg-state Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~documentation-memcg-warn-about-incomplete-kmemcg-state
+++ a/Documentation/cgroups/memory.txt
@@ -270,6 +270,11 @@ When oom event notifier is registered, e
 
 2.7 Kernel Memory Extension (CONFIG_MEMCG_KMEM)
 
+WARNING: Current implementation lacks reclaim support. That means allocation
+	 attempts will fail when close to the limit even if there are plenty of
+	 kmem available for reclaim. That makes this option unusable in real
+	 life so DO NOT SELECT IT unless for development purposes.
+
 With the Kernel memory extension, the Memory Controller is able to limit
 the amount of kernel memory used by the system. Kernel memory is fundamentally
 different than user memory, since it can't be swapped out, which makes it
diff -puN init/Kconfig~documentation-memcg-warn-about-incomplete-kmemcg-state init/Kconfig
--- a/init/Kconfig~documentation-memcg-warn-about-incomplete-kmemcg-state
+++ a/init/Kconfig
@@ -996,6 +996,12 @@ config MEMCG_KMEM
 	  the kmem extension can use it to guarantee that no group of processes
 	  will ever exhaust kernel resources alone.
 
+	  WARNING: Current implementation lacks reclaim support. That means
+	  allocation attempts will fail when close to the limit even if there
+	  are plenty of kmem available for reclaim. That makes this option
+	  unusable in real life so DO NOT SELECT IT unless for development
+	  purposes.
+
 config CGROUP_HUGETLB
 	bool "HugeTLB Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS && HUGETLB_PAGE
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slub-fix-memcg_propagate_slab_attrs.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
mm-get-rid-of-__gfp_kmemcg-fix.patch
slab-document-kmalloc_order.patch
memcg-un-export-__memcg_kmem_get_cache.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch

