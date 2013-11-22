From: akpm@linux-foundation.org
Subject: [merged] configfs-fix-race-between-dentry-put-and-lookup.patch
 removed from -mm tree
Date: Fri, 22 Nov 2013 13:21:44 -0800
Message-ID: <528fcae8.4w8FUpbHaD9vKrVm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab3KVVVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:21:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, stable@vger.kernel.org, jlbec@evilplan.org, junxiao.bi@oracle.com

Subject: [merged] configfs-fix-race-between-dentry-put-and-lookup.patch removed from -mm tree
To: junxiao.bi@oracle.com,jlbec@evilplan.org,stable@vger.kernel.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:21:44 -0800


The patch titled
     Subject: configfs: fix race between dentry put and lookup
has been removed from the -mm tree.  Its filename was
     configfs-fix-race-between-dentry-put-and-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: configfs: fix race between dentry put and lookup

A race window in configfs, it starts from one dentry is UNHASHED and end
before configfs_d_iput is called.  In this window, if a lookup happen,
since the original dentry was UNHASHED, so a new dentry will be allocated,
and then in configfs_attach_attr(), sd->s_dentry will be updated to the
new dentry.  Then in configfs_d_iput(), BUG_ON(sd->s_dentry != dentry)
will be triggered and system panic.

sys_open:                                             sys_close:
 ...                                                   fput
                                                        dput
                                                         dentry_kill
                                                          __d_drop <--- dentry unhashed here,
                                                                   but sd->dentry still point
                                                                   to this dentry.
 lookup_real
  configfs_lookup
   configfs_attach_attr---> update sd->s_dentry
                            to new allocated dentry here.
                                                          d_kill
                                                           configfs_d_iput <--- BUG_ON(sd->s_dentry != dentry)
                                                                           triggered here.

To fix it, change configfs_d_iput to not update sd->s_dentry if
sd->s_count > 2, that means there are another dentry is using the sd
beside the one that is going to be put.  Use configfs_dirent_lock in
configfs_attach_attr to sync with configfs_d_iput.

With the following steps, you can reproduce the bug.

1. enable ocfs2, this will mount configfs at /sys/kernel/config and
   fill configure in it.

2. run the following script.
	while [ 1 ]; do cat /sys/kernel/config/cluster/$your_cluster_name/idle_timeout_ms > /dev/null; done &
	while [ 1 ]; do cat /sys/kernel/config/cluster/$your_cluster_name/idle_timeout_ms > /dev/null; done &

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/dir.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/configfs/dir.c~configfs-fix-race-between-dentry-put-and-lookup fs/configfs/dir.c
--- a/fs/configfs/dir.c~configfs-fix-race-between-dentry-put-and-lookup
+++ a/fs/configfs/dir.c
@@ -56,10 +56,19 @@ static void configfs_d_iput(struct dentr
 	struct configfs_dirent *sd = dentry->d_fsdata;
 
 	if (sd) {
-		BUG_ON(sd->s_dentry != dentry);
 		/* Coordinate with configfs_readdir */
 		spin_lock(&configfs_dirent_lock);
-		sd->s_dentry = NULL;
+		/* Coordinate with configfs_attach_attr where will increase
+		 * sd->s_count and update sd->s_dentry to new allocated one.
+		 * Only set sd->dentry to null when this dentry is the only
+		 * sd owner.
+		 * If not do so, configfs_d_iput may run just after
+		 * configfs_attach_attr and set sd->s_dentry to null
+		 * even it's still in use.
+		 */
+		if (atomic_read(&sd->s_count) <= 2)
+			sd->s_dentry = NULL;
+
 		spin_unlock(&configfs_dirent_lock);
 		configfs_put(sd);
 	}
@@ -416,8 +425,11 @@ static int configfs_attach_attr(struct c
 	struct configfs_attribute * attr = sd->s_element;
 	int error;
 
+	spin_lock(&configfs_dirent_lock);
 	dentry->d_fsdata = configfs_get(sd);
 	sd->s_dentry = dentry;
+	spin_unlock(&configfs_dirent_lock);
+
 	error = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG,
 				configfs_init_file);
 	if (error) {
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

origin.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch

