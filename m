From: akpm@linux-foundation.org
Subject: [merged]
 mm-docs-update-memorystat-description-with-workingset-entries.patch removed
 from -mm tree
Date: Tue, 16 May 2017 10:50:26 -0700
Message-ID: <20170516175026.f0DUsn7nP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57444 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752912AbdEPRu1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 13:50:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org, vdavydov.dev@gmail.com


The patch titled
     Subject: mm, docs: update memory.stat description with workingset* entries
has been removed from the -mm tree.  Its filename was
     mm-docs-update-memorystat-description-with-workingset-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm, docs: update memory.stat description with workingset* entries

4b4cea91691d ("mm: vmscan: fix IO/refault regression in cache workingset
transition") introduced three new entries in memory stat file:

     - workingset_refault,
     - workingset_activate,
     - workingset_nodereclaim.

This commit adds a corresponding description to the cgroup v2 docs.

Link: http://lkml.kernel.org/r/1494530293-31236-1-git-send-email-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN Documentation/cgroup-v2.txt~mm-docs-update-memorystat-description-with-workingset-entries Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-docs-update-memorystat-description-with-workingset-entries
+++ a/Documentation/cgroup-v2.txt
@@ -918,6 +918,18 @@ PAGE_SIZE multiple when read back.
 
 		Number of major page faults incurred
 
+	  workingset_refault
+
+		Number of refaults of previously evicted pages
+
+	  workingset_activate
+
+		Number of refaulted pages that were immediately activated
+
+	  workingset_nodereclaim
+
+		Number of times a shadow node has been reclaimed
+
   memory.swap.current
 
 	A read-only single value file which exists on non-root
_

Patches currently in -mm which might be from guro@fb.com are


