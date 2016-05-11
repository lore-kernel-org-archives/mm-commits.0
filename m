From: akpm@linux-foundation.org
Subject: +
 documentation-memcg-update-kmem-limit-doc-as-codes-behavior.patch added to
 -mm tree
Date: Wed, 11 May 2016 15:44:20 -0700
Message-ID: <5733b5c4.5Z49hVJPveFP9t3y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbcEKWoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2016 18:44:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h.huangqiang@huawei.com, corbet@lwn.net, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/memcg: update kmem limit doc to match code behavior
has been added to the -mm tree.  Its filename is
     documentation-memcg-update-kmem-limit-doc-as-codes-behavior.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-memcg-update-kmem-limit-doc-as-codes-behavior.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-memcg-update-kmem-limit-doc-as-codes-behavior.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qiang Huang <h.huangqiang@huawei.com>
Subject: Documentation/memcg: update kmem limit doc to match code behavior

The restriction of kmem setting is not there anymore because the
accounting is enabled by default even in the cgroup v1 - see b313aeee2509
("mm: memcontrol: enable kmem accounting for all cgroups in the legacy
hierarchy").

Update docs accordingly.

Link: http://lkml.kernel.org/r/5732CC23.2060101@huawei.com
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v1/memory.txt |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN Documentation/cgroup-v1/memory.txt~documentation-memcg-update-kmem-limit-doc-as-codes-behavior Documentation/cgroup-v1/memory.txt
--- a/Documentation/cgroup-v1/memory.txt~documentation-memcg-update-kmem-limit-doc-as-codes-behavior
+++ a/Documentation/cgroup-v1/memory.txt
@@ -280,17 +280,9 @@ the amount of kernel memory used by the
 different than user memory, since it can't be swapped out, which makes it
 possible to DoS the system by consuming too much of this precious resource.
 
-Kernel memory won't be accounted at all until limit on a group is set. This
-allows for existing setups to continue working without disruption.  The limit
-cannot be set if the cgroup have children, or if there are already tasks in the
-cgroup. Attempting to set the limit under those conditions will return -EBUSY.
-When use_hierarchy == 1 and a group is accounted, its children will
-automatically be accounted regardless of their limit value.
