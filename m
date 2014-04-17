From: akpm@linux-foundation.org
Subject: +
 documentation-vm-numa_memory_policytxt-fix-wrong-document-in-numa_memory_policytxt.patch added to -mm tree
Date: Thu, 17 Apr 2014 14:29:06 -0700
Message-ID: <535047a2.Kn6/PqSZpn4zoaNV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDQV3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 17:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, rdunlap@infradead.org, tangchen@cn.fujitsu.com

Subject: + documentation-vm-numa_memory_policytxt-fix-wrong-document-in-numa_memory_policytxt.patch added to -mm tree
To: tangchen@cn.fujitsu.com,rdunlap@infradead.org,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 14:29:06 -0700


The patch titled
     Subject: Documentation/vm/numa_memory_policy.txt: fix wrong document in numa_memory_policy.txt
has been added to the -mm tree.  Its filename is
     documentation-vm-numa_memory_policytxt-fix-wrong-document-in-numa_memory_policytxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-vm-numa_memory_policytxt-fix-wrong-document-in-numa_memory_policytxt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-vm-numa_memory_policytxt-fix-wrong-document-in-numa_memory_policytxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: Documentation/vm/numa_memory_policy.txt: fix wrong document in numa_memory_policy.txt

In document numa_memory_policy.txt, the following examples for flag
MPOL_F_RELATIVE_NODES are incorrect.

	For example, consider a task that is attached to a cpuset with
	mems 2-5 that sets an Interleave policy over the same set with
	MPOL_F_RELATIVE_NODES.  If the cpuset's mems change to 3-7, the
	interleave now occurs over nodes 3,5-6.  If the cpuset's mems
	then change to 0,2-3,5, then the interleave occurs over nodes
	0,3,5.

According to the comment of the patch adding flag MPOL_F_RELATIVE_NODES,
the nodemasks the user specifies should be considered relative to the
current task's mems_allowed.
(https://lkml.org/lkml/2008/2/29/428)

And according to numa_memory_policy.txt, if the user's nodemask includes
nodes that are outside the range of the new set of allowed nodes, then
the remap wraps around to the beginning of the nodemask and, if not already
set, sets the node in the mempolicy nodemask.

So in the example, if the user specifies 2-5, for a task whose mems_allowed
is 3-7, the nodemasks should be remapped the third, fourth, fifth, sixth
node in mems_allowed.  like the following:

	mems_allowed:       3  4  5  6  7

	relative index:     0  1  2  3  4
	                    5

So the nodemasks should be remapped to 3,5-7, but not 3,5-6.

And for a task whose mems_allowed is 0,2-3,5, the nodemasks should be
remapped to 0,2-3,5, but not 0,3,5.

	mems_allowed:       0  2  3  5

        relative index:     0  1  2  3
                            4  5

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/numa_memory_policy.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/vm/numa_memory_policy.txt~documentation-vm-numa_memory_policytxt-fix-wrong-document-in-numa_memory_policytxt Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt~documentation-vm-numa_memory_policytxt-fix-wrong-document-in-numa_memory_policytxt
+++ a/Documentation/vm/numa_memory_policy.txt
@@ -174,7 +174,6 @@ Components of Memory Policies
 	allocation fails, the kernel will search other nodes, in order of
 	increasing distance from the preferred node based on information
 	provided by the platform firmware.
-	containing the cpu where the allocation takes place.
 
 	    Internally, the Preferred policy uses a single node--the
 	    preferred_node member of struct mempolicy.  When the internal
@@ -275,9 +274,9 @@ Components of Memory Policies
 	    For example, consider a task that is attached to a cpuset with
 	    mems 2-5 that sets an Interleave policy over the same set with
 	    MPOL_F_RELATIVE_NODES.  If the cpuset's mems change to 3-7, the
-	    interleave now occurs over nodes 3,5-6.  If the cpuset's mems
+	    interleave now occurs over nodes 3,5-7.  If the cpuset's mems
 	    then change to 0,2-3,5, then the interleave occurs over nodes
-	    0,3,5.
+	    0,2-3,5.
 
 	    Thanks to the consistent remapping, applications preparing
 	    nodemasks to specify memory policies using this flag should
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

documentation-vm-numa_memory_policytxt-fix-wrong-document-in-numa_memory_policytxt.patch

