From: akpm@linux-foundation.org
Subject: [merged] documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:41 -0800
Message-ID: <20121212195842.2569E200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37002 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:44 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so64881eei.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff.liu@oracle.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/cgroups/memory.txt: s/mem_cgroup_charge/mem_cgroup_change_common/
has been removed from the -mm tree.  Its filename was
     documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: Documentation/cgroups/memory.txt: s/mem_cgroup_charge/mem_cgroup_change_common/

mem_cgroup_charge_common() is invoked as the entry point for cgroup limits
charge rather than mem_cgroup_charge(), as the later has been removed for
years.  Update the cgroup/memory.txt to reflect this change.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/cgroups/memory.txt~documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common
+++ a/Documentation/cgroups/memory.txt
@@ -144,9 +144,9 @@ Figure 1 shows the important aspects of 
 3. Each page has a pointer to the page_cgroup, which in turn knows the
    cgroup it belongs to
 
-The accounting is done as follows: mem_cgroup_charge() is invoked to set up
-the necessary data structures and check if the cgroup that is being charged
-is over its limit. If it is, then reclaim is invoked on the cgroup.
+The accounting is done as follows: mem_cgroup_charge_common() is invoked to
+set up the necessary data structures and check if the cgroup that is being
+charged is over its limit. If it is, then reclaim is invoked on the cgroup.
 More details can be found in the reclaim section of this document.
 If everything goes well, a page meta-data-structure called page_cgroup is
 updated. page_cgroup has its own LRU on cgroup.
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
linux-next.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

