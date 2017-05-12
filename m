From: akpm@linux-foundation.org
Subject: +
 mm-docs-update-memorystat-description-with-workingset-entries.patch added
 to -mm tree
Date: Fri, 12 May 2017 13:49:54 -0700
Message-ID: <59161ff2.9ezeTo+4rheJE7FS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdELUtz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 16:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, mhocko@kernel.org, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, docs: update memory.stat description with workingset* entries
has been added to the -mm tree.  Its filename is
     mm-docs-update-memorystat-description-with-workingset-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-docs-update-memorystat-description-with-workingset-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-docs-update-memorystat-description-with-workingset-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-docs-update-memorystat-description-with-workingset-entries.patch

