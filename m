From: akpm@linux-foundation.org
Subject: [merged]
 documentation-cgroup-add-memoryswapcurrentmax-description.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:30:03 -0800
Message-ID: <56a169fb.ppZl4/cxq/JO+aR2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAUXaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:30:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: cgroup: add memory.swap.{current,max} description
has been removed from the -mm tree.  Its filename was
     documentation-cgroup-add-memoryswapcurrentmax-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Documentation: cgroup: add memory.swap.{current,max} description

The rationale of separate swap counter is given by Johannes Weiner.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN Documentation/cgroup-v2.txt~documentation-cgroup-add-memoryswapcurrentmax-description Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~documentation-cgroup-add-memoryswapcurrentmax-description
+++ a/Documentation/cgroup-v2.txt
@@ -819,6 +819,22 @@ PAGE_SIZE multiple when read back.
 		the cgroup.  This may not exactly match the number of
 		processes killed but should generally be close.
 
+  memory.swap.current
+
+	A read-only single value file which exists on non-root
+	cgroups.
+
+	The total amount of swap currently being used by the cgroup
+	and its descendants.
+
+  memory.swap.max
+
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "max".
+
+	Swap usage hard limit.  If a cgroup's swap usage reaches this
+	limit, anonymous meomry of the cgroup will not be swapped out.
+
 
 5-2-2. General Usage
 
@@ -1291,3 +1307,20 @@ allocation from the slack available in o
 system than killing the group.  Otherwise, memory.max is there to
 limit this type of spillover and ultimately contain buggy or even
 malicious applications.
+
+The combined memory+swap accounting and limiting is replaced by real
+control over swap space.
+
+The main argument for a combined memory+swap facility in the original
+cgroup design was that global or parental pressure would always be
+able to swap all anonymous memory of a child group, regardless of the
+child's own (possibly untrusted) configuration.  However, untrusted
+groups can sabotage swapping by other means - such as referencing its
+anonymous memory in a tight loop - and an admin can not assume full
+swappability when overcommitting untrusted jobs.
+
+For trusted jobs, on the other hand, a combined counter is not an
+intuitive userspace interface, and it flies in the face of the idea
+that cgroup controllers should account and limit specific physical
+resources.  Swap space is a resource like all others in the system,
+and that's why unified hierarchy allows distributing it separately.
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are


