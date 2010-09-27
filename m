From: akpm@linux-foundation.org
Subject: + cgroup-make-the-mount-options-parsing-more-accurate.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:56:09 -0700
Message-ID: <201009271956.o8RJu9mv013177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933522Ab0I0T5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, ebiederm@xmission.com, hadi@cyberus.ca, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, serge.hallyn@canonical.com


The patch titled
     cgroup: make the mount options parsing more accurate
has been added to the -mm tree.  Its filename is
     cgroup-make-the-mount-options-parsing-more-accurate.patch

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
Subject: cgroup: make the mount options parsing more accurate
From: Daniel Lezcano <daniel.lezcano@free.fr>

Current behavior:
=================

(1) When we mount a cgroup, we can specify the 'all' option which
    means to enable all the cgroup subsystems.  This is the default option
    when no option is specified.

(2) If we want to mount a cgroup with a subset of the supported cgroup
    subsystems, we have to specify a subsystems name list for the mount
    option.

(3) If we specify another option like 'noprefix' or 'release_agent',
    the actual code wants the 'all' or a subsystem name option specified
    also.  Not critical but a bit not friendly as we should assume (1) in
    this case.

(4) Logically, the 'all' option is mutually exclusive with a subsystem
    name, but this is not detected.

In other words:
 succeed : mount -t cgroup -o all,freezer cgroup /cgroup
	=> is it 'all' or 'freezer' ?
 fails : mount -t cgroup -o noprefix cgroup /cgroup
	=> succeed if we do '-o noprefix,all'

The following patches consolidate a bit the mount options check.

New behavior:
=============

(1) untouched
(2) untouched
(3) the 'all' option will be by default when specifying other than
    a subsystem name option
(4) raises an error

In other words:
 fails   : mount -t cgroup -o all,freezer cgroup /cgroup
 succeed : mount -t cgroup -o noprefix cgroup /cgroup

For the sake of lisibility, the if ... then ... else ... if ...
indentation when parsing the options has been changed to:
if ... then
	...
	continue
fi

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jamal Hadi Salim <hadi@cyberus.ca>
Cc: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   90 ++++++++++++++++++++++++++++++----------------
 1 file changed, 60 insertions(+), 30 deletions(-)

diff -puN kernel/cgroup.c~cgroup-make-the-mount-options-parsing-more-accurate kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-make-the-mount-options-parsing-more-accurate
+++ a/kernel/cgroup.c
@@ -1073,7 +1073,8 @@ struct cgroup_sb_opts {
  */
 static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 {
-	char *token, *o = data ?: "all";
+	char *token, *o = data;
+	bool all_ss = false, one_ss = false;
 	unsigned long mask = (unsigned long)-1;
 	int i;
 	bool module_pin_failed = false;
@@ -1089,24 +1090,27 @@ static int parse_cgroupfs_options(char *
 	while ((token = strsep(&o, ",")) != NULL) {
 		if (!*token)
 			return -EINVAL;
-		if (!strcmp(token, "all")) {
-			/* Add all non-disabled subsystems */
-			opts->subsys_bits = 0;
-			for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-				struct cgroup_subsys *ss = subsys[i];
-				if (ss == NULL)
-					continue;
-				if (!ss->disabled)
-					opts->subsys_bits |= 1ul << i;
-			}
-		} else if (!strcmp(token, "none")) {
+		if (!strcmp(token, "none")) {
 			/* Explicitly have no subsystems */
 			opts->none = true;
-		} else if (!strcmp(token, "noprefix")) {
+			continue;
+		}
+		if (!strcmp(token, "all")) {
+			/* Mutually exclusive option 'all' + subsystem name */
+			if (one_ss)
+				return -EINVAL;
+			all_ss = true;
+			continue;
+		}
+		if (!strcmp(token, "noprefix")) {
 			set_bit(ROOT_NOPREFIX, &opts->flags);
-		} else if (!strcmp(token, "clone_children")) {
+			continue;
+		}
+		if (!strcmp(token, "clone_children")) {
 			opts->clone_children = true;
-		} else if (!strncmp(token, "release_agent=", 14)) {
+			continue;
+		}
+		if (!strncmp(token, "release_agent=", 14)) {
 			/* Specifying two release agents is forbidden */
 			if (opts->release_agent)
 				return -EINVAL;
@@ -1114,7 +1118,9 @@ static int parse_cgroupfs_options(char *
 				kstrndup(token + 14, PATH_MAX - 1, GFP_KERNEL);
 			if (!opts->release_agent)
 				return -ENOMEM;
-		} else if (!strncmp(token, "name=", 5)) {
+			continue;
+		}
+		if (!strncmp(token, "name=", 5)) {
 			const char *name = token + 5;
 			/* Can't specify an empty name */
 			if (!strlen(name))
@@ -1136,20 +1142,44 @@ static int parse_cgroupfs_options(char *
 					      GFP_KERNEL);
 			if (!opts->name)
 				return -ENOMEM;
-		} else {
-			struct cgroup_subsys *ss;
-			for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-				ss = subsys[i];
-				if (ss == NULL)
-					continue;
-				if (!strcmp(token, ss->name)) {
-					if (!ss->disabled)
-						set_bit(i, &opts->subsys_bits);
-					break;
-				}
-			}
-			if (i == CGROUP_SUBSYS_COUNT)
-				return -ENOENT;
+
+			continue;
+		}
+
+		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+			struct cgroup_subsys *ss = subsys[i];
+			if (ss == NULL)
+				continue;
+			if (strcmp(token, ss->name))
+				continue;
+			if (ss->disabled)
+				continue;
+
+			/* Mutually exclusive option 'all' + subsystem name */
+			if (all_ss)
+				return -EINVAL;
+			set_bit(i, &opts->subsys_bits);
+			one_ss = true;
+
+			break;
+		}
+		if (i == CGROUP_SUBSYS_COUNT)
+			return -ENOENT;
+	}
+
+	/*
+	 * If the 'all' option was specified select all the subsystems,
+	 * otherwise 'all, 'none' and a subsystem name options were not
+	 * specified, let's default to 'all'
+	 */
+	if (all_ss || (!all_ss && !one_ss && !opts->none)) {
+		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+			struct cgroup_subsys *ss = subsys[i];
+			if (ss == NULL)
+				continue;
+			if (ss->disabled)
+				continue;
+			set_bit(i, &opts->subsys_bits);
 		}
 	}
 
_

Patches currently in -mm which might be from daniel.lezcano@free.fr are

linux-next.patch
cgroup-add-clone_children-control-file.patch
cgroup-make-the-mount-options-parsing-more-accurate.patch
cgroup-remove-the-ns_cgroup.patch

