From: akpm@linux-foundation.org
Subject: [folded] mm-make-expand_downwards-symmetrical-with-expand_upwards-v3.patch removed from -mm tree
Date: Mon, 09 May 2011 13:01:29 -0700
Message-ID: <201105092001.p49K1UuK014636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316Ab1EIUBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 16:01:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm-make-expand_downwards-symmetrical-with-expand_upwards-v3
has been removed from the -mm tree.  Its filename was
     mm-make-expand_downwards-symmetrical-with-expand_upwards-v3.patch

This patch was dropped because it was folded into mm-make-expand_downwards-symmetrical-with-expand_upwards.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-make-expand_downwards-symmetrical-with-expand_upwards-v3
From: Michal Hocko <mhocko@suse.cz>

fix compilation error on ia64

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/mm/fault.c~mm-make-expand_downwards-symmetrical-with-expand_upwards-v3 arch/ia64/mm/fault.c
--- a/arch/ia64/mm/fault.c~mm-make-expand_downwards-symmetrical-with-expand_upwards-v3
+++ a/arch/ia64/mm/fault.c
@@ -197,7 +197,7 @@ ia64_do_page_fault (unsigned long addres
 		 */
 		if (address > vma->vm_end + PAGE_SIZE - sizeof(long))
 			goto bad_area;
-		if (expand_upwards(vma, address))
+		if (expand_stack_upwards(vma, address))
 			goto bad_area;
 	}
 	goto good_area;
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-make-expand_downwards-symmetrical-with-expand_upwards.patch
mm-make-expand_downwards-symmetrical-to-expand_upwards.patch
memsw-remove-noswapaccount-kernel-parameter.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

