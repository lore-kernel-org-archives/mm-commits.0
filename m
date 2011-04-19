From: akpm@linux-foundation.org
Subject: + mm-make-expand_downwards-symmetrical-with-expand_upwards-v3.patch added to -mm tree
Date: Tue, 19 Apr 2011 11:30:04 -0700
Message-ID: <201104191830.p3JIU57E015744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821Ab1DSSaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 14:30:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz


The patch titled
     mm-make-expand_downwards-symmetrical-with-expand_upwards-v3
has been added to the -mm tree.  Its filename is
     mm-make-expand_downwards-symmetrical-with-expand_upwards-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
mm-make-expand_downwards-symmetrical-with-expand_upwards-v3.patch
memsw-remove-noswapaccount-kernel-parameter.patch
memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

