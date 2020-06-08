From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 54/54] doc: cgroup: update note about conditions
 when oom killer is invoked
Date: Sun, 07 Jun 2020 21:42:55 -0700
Message-ID: <20200608044255.Jspt1z7ML%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEm4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:56 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, khlebnikov@yandex-team.ru, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: doc: cgroup: update note about conditions when oom killer is invoked

Starting from v4.19 commit 29ef680ae7c2 ("memcg, oom: move out_of_memory
back to the charge path") cgroup oom killer is no longer invoked only from
page faults.  Now it implements the same semantics as global OOM killer:
allocation context invokes OOM killer and keeps retrying until success.

[akpm@linux-foundation.org: fixes per Randy]
Link: http://lkml.kernel.org/r/158894738928.208854.5244393925922074518.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1170,6 +1170,13 @@ PAGE_SIZE multiple when read back.
 	Under certain circumstances, the usage may go over the limit
 	temporarily.
 
+	In default configuration regular 0-order allocations always
+	succeed unless OOM killer chooses current task as a victim.
+
+	Some kinds of allocations don't invoke the OOM killer.
+	Caller could retry them differently, return into userspace
+	as -ENOMEM or silently ignore in cases like disk readahead.
+
 	This is the ultimate protection mechanism.  As long as the
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
@@ -1226,17 +1233,9 @@ PAGE_SIZE multiple when read back.
 		The number of time the cgroup's memory usage was
 		reached the limit and allocation was about to fail.
 
-		Depending on context result could be invocation of OOM
-		killer and retrying allocation or failing allocation.
-
-		Failed allocation in its turn could be returned into
-		userspace as -ENOMEM or silently ignored in cases like
-		disk readahead.  For now OOM in memory cgroup kills
-		tasks iff shortage has happened inside page fault.
