From: akpm@linux-foundation.org
Subject: + documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common.patch added to -mm tree
Date: Thu, 01 Nov 2012 15:36:11 -0700
Message-ID: <20121101223611.AE0D9100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46614 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760291Ab2KAWgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 18:36:13 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so356994vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 15:36:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff.liu@oracle.com, yinghan@google.com


The patch titled
     Subject: Documentation/cgroups/memory.txt: s/mem_cgroup_charge/mem_cgroup_change_common/
has been added to the -mm tree.  Its filename is
     documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common.patch

