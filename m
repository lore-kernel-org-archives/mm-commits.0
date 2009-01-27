From: akpm@linux-foundation.org
Subject: + cgroups-add-cpu_relax-calls-in-css_tryget-and-cgroup_clear_css_refs.patch added to -mm tree
Date: Tue, 27 Jan 2009 15:08:08 -0800
Message-ID: <200901272308.n0RN88Oj007253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbZA0XIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 18:08:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com


The patch titled
     cgroups: add cpu_relax() calls in css_tryget() and cgroup_clear_css_refs()
has been added to the -mm tree.  Its filename is
     cgroups-add-cpu_relax-calls-in-css_tryget-and-cgroup_clear_css_refs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add cpu_relax() calls in css_tryget() and cgroup_clear_css_refs()
From: Paul Menage <menage@google.com>

css_tryget() and cgroup_clear_css_refs() contain polling loops; these
loops should have cpu_relax calls in them to reduce cross-cache traffic.

Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-add-cpu_relax-calls-in-css_tryget-and-cgroup_clear_css_refs include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-cpu_relax-calls-in-css_tryget-and-cgroup_clear_css_refs
+++ a/include/linux/cgroup.h
@@ -99,6 +99,7 @@ static inline bool css_tryget(struct cgr
 	while (!atomic_inc_not_zero(&css->refcnt)) {
 		if (test_bit(CSS_REMOVED, &css->flags))
 			return false;
+		cpu_relax();
 	}
 	return true;
 }
diff -puN kernel/cgroup.c~cgroups-add-cpu_relax-calls-in-css_tryget-and-cgroup_clear_css_refs kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-cpu_relax-calls-in-css_tryget-and-cgroup_clear_css_refs
+++ a/kernel/cgroup.c
@@ -2509,7 +2509,7 @@ static int cgroup_clear_css_refs(struct 
 	for_each_subsys(cgrp->root, ss) {
 		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
 		int refcnt;
-		do {
+		while (1) {
 			/* We can only remove a CSS with a refcnt==1 */
 			refcnt = atomic_read(&css->refcnt);
 			if (refcnt > 1) {
@@ -2523,7 +2523,10 @@ static int cgroup_clear_css_refs(struct 
 			 * css_tryget() to spin until we set the
 			 * CSS_REMOVED bits or abort
 			 */
-		} while (atomic_cmpxchg(&css->refcnt, refcnt, 0) != refcnt);
+			if (atomic_cmpxchg(&css->refcnt, refcnt, 0) == refcnt)
+				break;
+			cpu_relax();
+		}
 	}
  done:
 	for_each_subsys(cgrp->root, ss) {
_

Patches currently in -mm which might be from menage@google.com are

cgroups-use-hierarchy-mutex-in-creation-failure-path.patch
memcg-get-put-parents-at-create-free.patch
memcg-get-put-parents-at-create-free-fix.patch
cgroups-fix-lock-inconsistency-in-cgroup_clone.patch
cgroups-add-cpu_relax-calls-in-css_tryget-and-cgroup_clear_css_refs.patch
linux-next.patch
cgroups-fix-cgrouph-comments.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-checkpatch-fixes.patch
add-a-refcount-check-in-dput.patch

