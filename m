From: akpm@linux-foundation.org
Subject: + cgroups-remove-node_-prefix_from-ns-subsystem.patch added to -mm tree
Date: Thu, 22 May 2008 01:36:18 -0700
Message-ID: <200805220836.m4M8aIxm025711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757733AbYEVIhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 04:37:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, menage@google.com, serue@us.ibm.com, stable@kernel.org


The patch titled
     cgroups: remove node_ prefix_from ns subsystem
has been added to the -mm tree.  Its filename is
     cgroups-remove-node_-prefix_from-ns-subsystem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: remove node_ prefix_from ns subsystem
From: Cedric Le Goater <clg@fr.ibm.com>

This is a slight change in the namespace cgroup subsystem api.

The change is that previously when cgroup_clone() was called (currently
only from the unshare path in ns_proxy cgroup, you'd get a new group named
"node_$pid" whereas now you'll get a group named after just your pid.)

The only users who would notice it are those who are using the ns_proxy
cgroup subsystem to auto-create cgroups when namespaces are unshared -
something of an experimental feature, which I think really needs more
complete container/namespace support in order to be useful.  I suspect the
only users are Cedric and Serge, or maybe a few others on
containers@lists.linux-foundation.org.  And in fact it would only be
noticed by the users who make the assumption about how the name is
generated, rather than getting it from the /proc/<pid>/cgroups file for
the process in question.

Whether the change is actually needed or not I'm fairly agnostic on, but I
guess it is more elegant to just use the pid as the new group name rather
than adding a fairly arbitrary "node_" prefix on the front.

[menage@google.com: provided changelog]
Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Paul Menage" <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-remove-node_-prefix_from-ns-subsystem kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-remove-node_-prefix_from-ns-subsystem
+++ a/kernel/cgroup.c
@@ -2903,7 +2903,7 @@ int cgroup_clone(struct task_struct *tsk
 	cg = tsk->cgroups;
 	parent = task_cgroup(tsk, subsys->subsys_id);
 
-	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "node_%d", tsk->pid);
+	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "%d", tsk->pid);
 
 	/* Pin the hierarchy */
 	atomic_inc(&parent->root->sb->s_active);
_

Patches currently in -mm which might be from clg@fr.ibm.com are

cgroups-remove-node_-prefix_from-ns-subsystem.patch

