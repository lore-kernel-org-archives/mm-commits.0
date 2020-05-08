From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked.patch
 added to -mm tree
Date: Fri, 08 May 2020 16:43:23 -0700
Message-ID: <20200508234323.64kzgWh8Q%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgEHXn0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:43:26 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, khlebnikov@yandex-team.ru, mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: doc: cgroup: update note about conditions when oom killer is invoked
has been added to the -mm tree.  Its filename is
     doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: doc: cgroup: update note about conditions when oom killer is invoked

Starting from v4.19 commit 29ef680ae7c2 ("memcg, oom: move out_of_memory
back to the charge path") cgroup oom killer is no longer invoked only from
page faults.  Now it implements the same semantics as global OOM killer:
allocation context invokes OOM killer and keeps retrying until success.

Link: http://lkml.kernel.org/r/158894738928.208854.5244393925922074518.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1172,6 +1172,13 @@ PAGE_SIZE multiple when read back.
 	Under certain circumstances, the usage may go over the limit
 	temporarily.
 
+	In default configuration regular 0-order allocation always
+	succeed unless OOM killer choose current task as a victim.
+
+	Some kinds of allocations don't invoke the OOM killer.
+	Caller could retry them differently, return into userspace
+	as -ENOMEM or silently ignore in cases like disk readahead.
+
 	This is the ultimate protection mechanism.  As long as the
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
@@ -1228,17 +1235,9 @@ PAGE_SIZE multiple when read back.
 		The number of time the cgroup's memory usage was
 		reached the limit and allocation was about to fail.
 
-		Depending on context result could be invocation of OOM
-		killer and retrying allocation or failing allocation.
-
-		Failed allocation in its turn could be returned into
-		userspace as -ENOMEM or silently ignored in cases like
-		disk readahead.  For now OOM in memory cgroup kills
-		tasks iff shortage has happened inside page fault.
