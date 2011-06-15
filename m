From: akpm@linux-foundation.org
Subject: + documentation-feature-removal-scheduletxt-remove-ns_cgroup-from-feature-removal-scheduletxt.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:20 -0700
Message-ID: <201106150124.p5F1ObJR031968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab1FOBZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:25:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, daniel.lezcano@free.fr, serge.hallyn@canonical.com


The patch titled
     Documentation/feature-removal-schedule.txt: remove ns_cgroup from feature-removal-schedule.txt
has been added to the -mm tree.  Its filename is
     documentation-feature-removal-scheduletxt-remove-ns_cgroup-from-feature-removal-scheduletxt.patch

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
Subject: Documentation/feature-removal-schedule.txt: remove ns_cgroup from feature-removal-schedule.txt


Commit a77aea92010acf ("cgroup: remove the ns_cgroup") removed the
ns_cgroup but it forgot to remove the related doc in
feature-removal-schedule.txt.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Serge E.  Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <>
---

 Documentation/feature-removal-schedule.txt |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~documentation-feature-removal-scheduletxt-remove-ns_cgroup-from-feature-removal-scheduletxt Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~documentation-feature-removal-scheduletxt-remove-ns_cgroup-from-feature-removal-scheduletxt
+++ a/Documentation/feature-removal-schedule.txt
@@ -481,23 +481,6 @@ Who:	FUJITA Tomonori <fujita.tomonori@la
 
 ----------------------------
 
-What:   namespace cgroup (ns_cgroup)
-When:   2.6.38
-Why:    The ns_cgroup leads to some problems:
-	* cgroup creation is out-of-control
-	* cgroup name can conflict when pids are looping
-	* it is not possible to have a single process handling
-	a lot of namespaces without falling in a exponential creation time
-	* we may want to create a namespace without creating a cgroup
-
-	The ns_cgroup is replaced by a compatibility flag 'clone_children',
-	where a newly created cgroup will copy the parent cgroup values.
-	The userspace has to manually create a cgroup and add a task to
-	the 'tasks' file.
-Who:    Daniel Lezcano <daniel.lezcano@free.fr>
-
-----------------------------
