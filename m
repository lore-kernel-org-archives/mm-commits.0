From: akpm@linux-foundation.org
Subject: [merged] vfs-d_obtain_alias-needs-to-use-as-default-name.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:40:39 -0800
Message-ID: <20121221204040.44A1F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:42479 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2LUUkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:40:42 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so272741eaa.2
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:40:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, Trond.Myklebust@netapp.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: d_obtain_alias() needs to use "/" as default name.
has been removed from the -mm tree.  Its filename was
     vfs-d_obtain_alias-needs-to-use-as-default-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: vfs: d_obtain_alias() needs to use "/" as default name.

NFS appears to use d_obtain_alias() to create the root dentry rather than
d_make_root.  This can cause 'prepend_path()' to complain that the root
has a weird name if an NFS filesystem is lazily unmounted.  e.g.  if
"/mnt" is an NFS mount then

 { cd /mnt; umount -l /mnt ; ls -l /proc/self/cwd; }

will cause a WARN message like
   WARNING: at /home/git/linux/fs/dcache.c:2624 prepend_path+0x1d7/0x1e0()
   ...
   Root dentry has weird name <>

to appear in kernel logs.

So change d_obtain_alias() to use "/" rather than "" as the anonymous
name.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dcache.c~vfs-d_obtain_alias-needs-to-use-as-default-name fs/dcache.c
--- a/fs/dcache.c~vfs-d_obtain_alias-needs-to-use-as-default-name
+++ a/fs/dcache.c
@@ -1583,7 +1583,7 @@ EXPORT_SYMBOL(d_find_any_alias);
  */
 struct dentry *d_obtain_alias(struct inode *inode)
 {
-	static const struct qstr anonstring = { .name = "" };
+	static const struct qstr anonstring = QSTR_INIT("/", 1);
 	struct dentry *tmp;
 	struct dentry *res;
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch

