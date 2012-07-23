From: akpm@linux-foundation.org
Subject: [merged] sysfs-fail-dentry-revalidation-after-namespace-change.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:31:19 -0700
Message-ID: <20120723213119.BA3231E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:61379 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab2GWVbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:31:20 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so783049ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:31:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, ebiederm@xmission.com, gregkh@linuxfoundation.org, serge.hallyn@ubuntu.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sysfs: fail dentry revalidation after namespace change
has been removed from the -mm tree.  Its filename was
     sysfs-fail-dentry-revalidation-after-namespace-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: sysfs: fail dentry revalidation after namespace change

When we change the namespace tag of a sysfs entry, the associated dentry
is still kept around.  readdir() will work correctly and not display the
old entries, but open() will still succeed, so will reads and writes.

This will no longer happen if sysfs is remounted, hinting that this is a
cache-related problem.

I am using the following sequence to demonstrate that:

shell1:
ip link add type veth
unshare -nm

shell2:
ip link set veth1 <pid_of_shell_1>
cat /sys/devices/virtual/net/veth1/ifindex

Before that patch, this will succeed (fail to fail).  After it, it will
correctly return an error.  Differently from a normal rename, which we
handle fine, changing the object namespace will keep it's path intact.  So
this check seems necessary as well.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Reviewed-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/sysfs/dir.c~sysfs-fail-dentry-revalidation-after-namespace-change fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-fail-dentry-revalidation-after-namespace-change
+++ a/fs/sysfs/dir.c
@@ -307,6 +307,7 @@ static int sysfs_dentry_revalidate(struc
 {
 	struct sysfs_dirent *sd;
 	int is_dir;
+	int type;
 
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -326,6 +327,13 @@ static int sysfs_dentry_revalidate(struc
 	if (strcmp(dentry->d_name.name, sd->s_name) != 0)
 		goto out_bad;
 
+	/* The sysfs dirent has been moved to a different namespace */
+	type = KOBJ_NS_TYPE_NONE;
+	if (sd->s_parent)
+		type = sysfs_ns_type(sd->s_parent);
+	if (type && (sysfs_info(dentry->d_sb)->ns[type] != sd->s_ns))
+		goto out_bad;
+
 	mutex_unlock(&sysfs_mutex);
 out_valid:
 	return 1;
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
memcg-fix-bad-behavior-in-use_hierarchy-file.patch

