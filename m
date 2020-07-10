From: Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-mm-sync-up-oom_score_adj-documentation.patch added
 to -mm tree
Date: Thu, 09 Jul 2020 17:36:10 -0700
Message-ID: <20200710003610.UWTHbou0w%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgGJAgL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 20:36:11 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com


The patch titled
     Subject: doc, mm: sync up oom_score_adj documentation
has been added to the -mm tree.  Its filename is
     doc-mm-sync-up-oom_score_adj-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-mm-sync-up-oom_score_adj-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-mm-sync-up-oom_score_adj-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: doc, mm: sync up oom_score_adj documentation

There are at least two notes in the oom section.  The 3% discount for root
processes is gone since d46078b28889 ("mm, oom: remove 3% bonus for
CAP_SYS_ADMIN processes").

Likewise children of the selected oom victim are not sacrificed since
bbbe48029720 ("mm, oom: remove 'prefer children over parent' heuristic")

Drop both of them.

Link: http://lkml.kernel.org/r/20200709062603.18480-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    8 --------
 1 file changed, 8 deletions(-)

--- a/Documentation/filesystems/proc.rst~doc-mm-sync-up-oom_score_adj-documentation
+++ a/Documentation/filesystems/proc.rst
@@ -1634,9 +1634,6 @@ may allocate from based on an estimation
 For example, if a task is using all allowed memory, its badness score will be
 1000.  If it is using half of its allowed memory, its score will be 500.
 
-There is an additional factor included in the badness score: the current memory
-and swap usage is discounted by 3% for root processes.
-
 The amount of "allowed" memory depends on the context in which the oom killer
 was called.  If it is due to the memory assigned to the allocating task's cpuset
 being exhausted, the allowed memory represents the set of mems assigned to that
@@ -1672,11 +1669,6 @@ The value of /proc/<pid>/oom_score_adj m
 value set by a CAP_SYS_RESOURCE process. To reduce the value any lower
 requires CAP_SYS_RESOURCE.
 
-Caveat: when a parent task is selected, the oom killer will sacrifice any first
-generation children with separate address spaces instead, if possible.  This
-avoids servers and important system daemons from being killed and loses the
-minimal amount of work.
