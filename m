From: akpm@linux-foundation.org
Subject: [folded-merged]
 memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 15:28:04 -0700
Message-ID: <51db3cf4.XDKxwYKDhvZQo9+A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3GHW2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, sedat.dilek@gmail.com, mhocko@suse.cz, fengguang.wu@intel.com, lizefan@huawei.com

Subject: [folded-merged] memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix.patch removed from -mm tree
To: lizefan@huawei.com,fengguang.wu@intel.com,mhocko@suse.cz,sedat.dilek@gmail.com,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:28:04 -0700


The patch titled
     Subject: memcg: fix build error if CONFIG_MEMCG_KMEM=n
has been removed from the -mm tree.  Its filename was
     memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix.patch

This patch was dropped because it was folded into memcg-use-css_get-put-when-charging-uncharging-kmem.patch

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: fix build error if CONFIG_MEMCG_KMEM=n

Fix this build error:

mm/built-in.o: In function `mem_cgroup_css_free':
memcontrol.c:(.text+0x5caa6): undefined reference to 'mem_cgroup_sockets_destroy'

Maybe it's better to add memcg_destroy_kmem(), to pair with memcg_init_kmem().

This patch can be folded into "memcg: use css_get/put when charging/uncharging kmem".

Rename the patch as it is a follow-up for the mmotm tree:
"memcg-use-css_get-put-when-charging-uncharging-kmem-fix-2.patch"

See [1] for the original patch and follow the discussion in [2].

[1] http://marc.info/?l=linux-mm&m=137285590123430&w=2
[2] http://marc.info/?t=137285378500005&r=1&w=2

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix
+++ a/mm/memcontrol.c
@@ -5916,6 +5916,11 @@ static int memcg_init_kmem(struct mem_cg
 	return mem_cgroup_sockets_init(memcg, ss);
 }
 
+static void memcg_destroy_kmem(struct mem_cgroup *memcg)
+{
+	mem_cgroup_sockets_destroy(memcg);
+}
+
 static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
 {
 	if (!memcg_kmem_is_active(memcg))
@@ -5955,6 +5960,10 @@ static int memcg_init_kmem(struct mem_cg
 	return 0;
 }
 
+static void memcg_destroy_kmem(struct mem_cgroup *memcg)
+{
+}
+
 static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
 {
 }
@@ -6399,8 +6408,7 @@ static void mem_cgroup_css_free(struct c
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
-	mem_cgroup_sockets_destroy(memcg);
