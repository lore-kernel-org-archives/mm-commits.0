From: akpm@linux-foundation.org
Subject: + cgroup-add-clone_children-control-file.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:56:07 -0700
Message-ID: <201009271956.o8RJu7Aj013174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933522Ab0I0T5C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:57:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, ebiederm@xmission.com, hadi@cyberus.ca, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, serge.hallyn@canonical.com


The patch titled
     cgroup: add clone_children control file
has been added to the -mm tree.  Its filename is
     cgroup-add-clone_children-control-file.patch

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
Subject: cgroup: add clone_children control file
From: Daniel Lezcano <daniel.lezcano@free.fr>

The ns_cgroup is a control group interacting with the namespaces.  When a
new namespace is created, a corresponding cgroup is automatically created
too.  The cgroup name is the pid of the process who did 'unshare' or the
child of 'clone'.

This cgroup is tied with the namespace because it prevents a process to
escape the control group and use the post_clone callback, so the child
cgroup inherits the values of the parent cgroup.

Unfortunately, the more we use this cgroup and the more we are facing
problems with it:

(1) when a process unshares, the cgroup name may conflict with a
    previous cgroup with the same pid, so unshare or clone return -EEXIST

(2) the cgroup creation is out of control because there may have an
    application creating several namespaces where the system will
    automatically create several cgroups in his back and let them on the
    cgroupfs (eg.  a vrf based on the network namespace).

(3) the mix of (1) and (2) force an administrator to regularly check
    and clean these cgroups.

This patchset removes the ns_cgroup by adding a new flag to the cgroup and
the cgroupfs mount option.  It enables the copy of the parent cgroup when
a child cgroup is created.  We can then safely remove the ns_cgroup as
this flag brings a compatibility.  We have now to manually create and add
the task to a cgroup, which is consistent with the cgroup framework.



This patch:

Sent as an answer to a previous thread around the ns_cgroup.

https://lists.linux-foundation.org/pipermail/containers/2009-June/018627.html

It adds a control file 'clone_children' for a cgroup.  This control file
is a boolean specifying if the child cgroup should be a clone of the
parent cgroup or not.  The default value is 'false'.

This flag makes the child cgroup to call the post_clone callback of all
the subsystem, if it is available.

At present, the cpuset is the only one which had implemented the
post_clone callback.

The option can be set at mount time by specifying the 'clone_children'
mount option.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jamal Hadi Salim <hadi@cyberus.ca>
Cc: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |   14 ++++++++--
 include/linux/cgroup.h            |    4 ++
 kernel/cgroup.c                   |   39 ++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroup-add-clone_children-control-file Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroup-add-clone_children-control-file
+++ a/Documentation/cgroups/cgroups.txt
@@ -18,7 +18,8 @@ CONTENTS:
   1.2 Why are cgroups needed ?
   1.3 How are cgroups implemented ?
   1.4 What does notify_on_release do ?
-  1.5 How do I use cgroups ?
+  1.5 What does clone_children do ?
+  1.6 How do I use cgroups ?
 2. Usage Examples and Syntax
   2.1 Basic Usage
   2.2 Attaching processes
@@ -293,7 +294,16 @@ notify_on_release in the root cgroup at 
 value of their parents notify_on_release setting. The default value of
 a cgroup hierarchy's release_agent path is empty.
 
-1.5 How do I use cgroups ?
+1.5 What does clone_children do ?
+---------------------------------
+
+If the clone_children flag is enabled (1) in a cgroup, then all
+cgroups created beneath will call the post_clone callbacks for each
+subsystem of the newly created cgroup. Usually when this callback is
+implemented for a subsystem, it copies the values of the parent
+subsystem, this is the case for the cpuset.
+
+1.6 How do I use cgroups ?
 --------------------------
 
 To start a new job that is to be contained within a cgroup, using
diff -puN include/linux/cgroup.h~cgroup-add-clone_children-control-file include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-add-clone_children-control-file
+++ a/include/linux/cgroup.h
@@ -154,6 +154,10 @@ enum {
 	 * A thread in rmdir() is wating for this cgroup.
 	 */
 	CGRP_WAIT_ON_RMDIR,
+	/*
+	 * Clone cgroup values when creating a new child cgroup
+	 */
+	CGRP_CLONE_CHILDREN,
 };
 
 /* which pidlist file are we talking about? */
diff -puN kernel/cgroup.c~cgroup-add-clone_children-control-file kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-add-clone_children-control-file
+++ a/kernel/cgroup.c
@@ -243,6 +243,11 @@ static int notify_on_release(const struc
 	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 }
 
+static int clone_children(const struct cgroup *cgrp)
+{
+	return test_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
+}
+
 /*
  * for_each_subsys() allows you to iterate on each subsystem attached to
  * an active hierarchy
@@ -1039,6 +1044,8 @@ static int cgroup_show_options(struct se
 		seq_puts(seq, ",noprefix");
 	if (strlen(root->release_agent_path))
 		seq_printf(seq, ",release_agent=%s", root->release_agent_path);
+	if (clone_children(&root->top_cgroup))
+		seq_puts(seq, ",clone_children");
 	if (strlen(root->name))
 		seq_printf(seq, ",name=%s", root->name);
 	mutex_unlock(&cgroup_mutex);
@@ -1049,6 +1056,7 @@ struct cgroup_sb_opts {
 	unsigned long subsys_bits;
 	unsigned long flags;
 	char *release_agent;
+	bool clone_children;
 	char *name;
 	/* User explicitly requested empty subsystem */
 	bool none;
@@ -1096,6 +1104,8 @@ static int parse_cgroupfs_options(char *
 			opts->none = true;
 		} else if (!strcmp(token, "noprefix")) {
 			set_bit(ROOT_NOPREFIX, &opts->flags);
+		} else if (!strcmp(token, "clone_children")) {
+			opts->clone_children = true;
 		} else if (!strncmp(token, "release_agent=", 14)) {
 			/* Specifying two release agents is forbidden */
 			if (opts->release_agent)
@@ -1354,6 +1364,8 @@ static struct cgroupfs_root *cgroup_root
 		strcpy(root->release_agent_path, opts->release_agent);
 	if (opts->name)
 		strcpy(root->name, opts->name);
+	if (opts->clone_children)
+		set_bit(CGRP_CLONE_CHILDREN, &root->top_cgroup.flags);
 	return root;
 }
 
@@ -3172,6 +3184,23 @@ fail:
 	return ret;
 }
 
+static u64 cgroup_clone_children_read(struct cgroup *cgrp,
+				    struct cftype *cft)
+{
+	return clone_children(cgrp);
+}
+
+static int cgroup_clone_children_write(struct cgroup *cgrp,
+				     struct cftype *cft,
+				     u64 val)
+{
+	if (val)
+		set_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
+	else
+		clear_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
+	return 0;
+}
+
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -3202,6 +3231,11 @@ static struct cftype files[] = {
 		.write_string = cgroup_write_event_control,
 		.mode = S_IWUGO,
 	},
+	{
+		.name = "cgroup.clone_children",
+		.read_u64 = cgroup_clone_children_read,
+		.write_u64 = cgroup_clone_children_write,
+	},
 };
 
 static struct cftype cft_release_agent = {
@@ -3331,6 +3365,9 @@ static long cgroup_create(struct cgroup 
 	if (notify_on_release(parent))
 		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 
+	if (clone_children(parent))
+		set_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
+
 	for_each_subsys(root, ss) {
 		struct cgroup_subsys_state *css = ss->create(ss, cgrp);
 
@@ -3345,6 +3382,8 @@ static long cgroup_create(struct cgroup 
 				goto err_destroy;
 		}
 		/* At error, ->destroy() callback has to free assigned ID. */
+		if (clone_children(parent) && ss->post_clone)
+			ss->post_clone(ss, cgrp);
 	}
 
 	cgroup_lock_hierarchy(root);
_

Patches currently in -mm which might be from daniel.lezcano@free.fr are

linux-next.patch
cgroup-add-clone_children-control-file.patch
cgroup-make-the-mount-options-parsing-more-accurate.patch
cgroup-remove-the-ns_cgroup.patch

