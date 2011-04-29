From: akpm@linux-foundation.org
Subject: [merged] memcg-update-documentation-to-describe-usage_in_bytes.patch removed from -mm tree
Date: Fri, 29 Apr 2011 12:46:48 -0700
Message-ID: <201104291941.p3TJfJkC011441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397Ab1D2TmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 15:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     memcg: update documentation to describe usage_in_bytes
has been removed from the -mm tree.  Its filename was
     memcg-update-documentation-to-describe-usage_in_bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: update documentation to describe usage_in_bytes
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Since 569b846d ("memcg: coalesce uncharge during unmap/truncate"), we do
batched (delayed) uncharge at truncation/unmap.  And since cdec2e42(memcg:
coalesce charging via percpu storage), we have percpu cache for
res_counter.

These changes improved performance of memory cgroup very much, but made
res_counter->usage usually have a bigger value than the actual value of
memory usage.  So, *.usage_in_bytes, which show res_counter->usage, are
not desirable for precise values of memory(and swap) usage anymore.

Instead of removing these files completely(because we cannot know
res_counter->usage without them), this patch updates the meaning of those
files.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-update-documentation-to-describe-usage_in_bytes Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-update-documentation-to-describe-usage_in_bytes
+++ a/Documentation/cgroups/memory.txt
@@ -52,8 +52,10 @@ Brief summary of control files.
  tasks				 # attach a task(thread) and show list of threads
  cgroup.procs			 # show list of processes
  cgroup.event_control		 # an interface for event_fd()
- memory.usage_in_bytes		 # show current memory(RSS+Cache) usage.
- memory.memsw.usage_in_bytes	 # show current memory+Swap usage
+ memory.usage_in_bytes		 # show current res_counter usage for memory
+				 (See 5.5 for details)
+ memory.memsw.usage_in_bytes	 # show current res_counter usage for memory+Swap
+				 (See 5.5 for details)
  memory.limit_in_bytes		 # set/show limit of memory usage
  memory.memsw.limit_in_bytes	 # set/show limit of memory+Swap usage
  memory.failcnt			 # show the number of memory usage hits limits
@@ -453,6 +455,15 @@ memory under it will be reclaimed.
 You can reset failcnt by writing 0 to failcnt file.
 # echo 0 > .../memory.failcnt
 
+5.5 usage_in_bytes
+
+For efficiency, as other kernel components, memory cgroup uses some optimization
+to avoid unnecessary cacheline false sharing. usage_in_bytes is affected by the
+method and doesn't show 'exact' value of memory(and swap) usage, it's an fuzz
+value for efficient access. (Of course, when necessary, it's synchronized.)
+If you want to know more exact memory usage, you should use RSS+CACHE(+SWAP)
+value in memory.stat(see 5.2).
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memsw-remove-noswapaccount-kernel-parameter.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch

