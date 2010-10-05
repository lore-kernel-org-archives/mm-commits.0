From: akpm@linux-foundation.org
Subject: + cgroup-notify-ns_cgroup-deprecated.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:53:27 -0700
Message-ID: <201010052153.o95LrRAA022283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755326Ab0JEVxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, menage@google.com


The patch titled
     cgroup: notify ns_cgroup deprecated
has been added to the -mm tree.  Its filename is
     cgroup-notify-ns_cgroup-deprecated.patch

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
Subject: cgroup: notify ns_cgroup deprecated
From: Daniel Lezcano <daniel.lezcano@free.fr>

The ns_cgroup will be removed very soon.  Let's warn, for this version,
ns_cgroup is deprecated.

Make ns_cgroup and clone_children exclusive.  If the clone_children is set
and the ns_cgroup is mounted, let's fail with EINVAL when the ns_cgroup
subsys is created (a printk will help the user to understand why the
creation fails).

Update the feature remove schedule file with the deprecated ns_cgroup.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   17 +++++++++++++++++
 kernel/ns_cgroup.c                         |    8 ++++++++
 2 files changed, 25 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~cgroup-notify-ns_cgroup-deprecated Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~cgroup-notify-ns_cgroup-deprecated
+++ a/Documentation/feature-removal-schedule.txt
@@ -545,4 +545,21 @@ Why:    This is a legacy interface which
 Who:    NeilBrown <neilb@suse.de>
 
 ----------------------------
+
+What:   namespace cgroup (ns_cgroup)
+When:   2.6.38
+Why:    The ns_cgroup leads to some problems:
+	* cgroup creation is out-of-control
+	* cgroup name can conflict when pids are looping
+	* it is not possible to have a single process handling
+	a lot of namespaces without falling in a exponential creation time
+	* we may want to create a namespace without creating a cgroup
+
+	The ns_cgroup is replaced by a compatibility flag 'clone_children',
+	where a newly created cgroup will copy the parent cgroup values.
+	The userspace has to manually create a cgroup and add a task to
+	the 'tasks' file.
+Who:    Daniel Lezcano <daniel.lezcano@free.fr>
+
+----------------------------
 	
diff -puN kernel/ns_cgroup.c~cgroup-notify-ns_cgroup-deprecated kernel/ns_cgroup.c
--- a/kernel/ns_cgroup.c~cgroup-notify-ns_cgroup-deprecated
+++ a/kernel/ns_cgroup.c
@@ -85,6 +85,14 @@ static struct cgroup_subsys_state *ns_cr
 		return ERR_PTR(-EPERM);
 	if (!cgroup_is_descendant(cgroup, current))
 		return ERR_PTR(-EPERM);
+	if (test_bit(CGRP_CLONE_CHILDREN, &cgroup->flags)) {
+		printk("ns_cgroup can't be created with parent "
+		       "'clone_children' set.\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	printk_once("ns_cgroup deprecated: consider using the "
+		    "'clone_children' flag without the ns_cgroup.\n");
 
 	ns_cgroup = kzalloc(sizeof(*ns_cgroup), GFP_KERNEL);
 	if (!ns_cgroup)
_

Patches currently in -mm which might be from daniel.lezcano@free.fr are

linux-next.patch
cgroup-add-clone_children-control-file.patch
cgroup-make-the-mount-options-parsing-more-accurate.patch
cgroup-notify-ns_cgroup-deprecated.patch

