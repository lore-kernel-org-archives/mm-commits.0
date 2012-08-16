From: akpm@linux-foundation.org
Subject: + vfs-d_obtain_alias-needs-to-use-as-default-name.patch added to -mm tree
Date: Thu, 16 Aug 2012 12:11:16 -0700
Message-ID: <20120816191117.170DD200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:45571 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2HPTLT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 15:11:19 -0400
Received: by weyr1 with SMTP id r1so149066wey.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 12:11:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, Trond.Myklebust@netapp.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: vfs: d_obtain_alias() needs to use "/" as default name.
has been added to the -mm tree.  Its filename is
     vfs-d_obtain_alias-needs-to-use-as-default-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dcache.c~vfs-d_obtain_alias-needs-to-use-as-default-name fs/dcache.c
--- a/fs/dcache.c~vfs-d_obtain_alias-needs-to-use-as-default-name
+++ a/fs/dcache.c
@@ -1579,7 +1579,7 @@ EXPORT_SYMBOL(d_find_any_alias);
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
vfs-d_obtain_alias-needs-to-use-as-default-name.patch

