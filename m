From: akpm@linux-foundation.org
Subject: [merged] autofs-use-autofs_dev_ioctl_size.patch removed
 from -mm tree
Date: Mon, 11 Sep 2017 12:43:19 -0700
Message-ID: <20170911194319.bCHmKh-21%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdIKTnU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raven@themaw.net, tkusumi@tuxera.com


The patch titled
     Subject: autofs: use AUTOFS_DEV_IOCTL_SIZE
has been removed from the -mm tree.  Its filename was
     autofs-use-autofs_dev_ioctl_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: use AUTOFS_DEV_IOCTL_SIZE

Use a macro which defines misc-dev ioctl parameter size (excluding a path
beyond &path[0]) since it's been used to initialize and copy this
structure ever since it first appeared in 8d7b48e0 in 2008.

(or simply get rid of this if this is just unnecessary abstraction when
all it needs is sizeof(struct autofs_dev_ioctl))

Edit: raven@themaw.net
That's a good point but I'd prefer to keep the macro define.
End edit: raven@themaw.net

Link: http://lkml.kernel.org/r/150285068577.4670.2599968823770600622.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-use-autofs_dev_ioctl_size fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-use-autofs_dev_ioctl_size
+++ a/fs/autofs4/dev-ioctl.c
@@ -97,13 +97,13 @@ static struct autofs_dev_ioctl *
 {
 	struct autofs_dev_ioctl tmp, *res;
 
-	if (copy_from_user(&tmp, in, sizeof(tmp)))
+	if (copy_from_user(&tmp, in, AUTOFS_DEV_IOCTL_SIZE))
 		return ERR_PTR(-EFAULT);
 
-	if (tmp.size < sizeof(tmp))
+	if (tmp.size < AUTOFS_DEV_IOCTL_SIZE)
 		return ERR_PTR(-EINVAL);
 
-	if (tmp.size > (PATH_MAX + sizeof(tmp)))
+	if (tmp.size > AUTOFS_DEV_IOCTL_SIZE + PATH_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
 
 	res = memdup_user(in, tmp.size);
@@ -133,8 +133,8 @@ static int validate_dev_ioctl(int cmd, s
 		goto out;
 	}
 
-	if (param->size > sizeof(*param)) {
-		err = invalid_str(param->path, param->size - sizeof(*param));
+	if (param->size > AUTOFS_DEV_IOCTL_SIZE) {
+		err = invalid_str(param->path, param->size - AUTOFS_DEV_IOCTL_SIZE);
 		if (err) {
 			pr_warn(
 			  "path string terminator missing for cmd(0x%08x)\n",
@@ -451,7 +451,7 @@ static int autofs_dev_ioctl_requester(st
 	dev_t devid;
 	int err = -ENOENT;
 
-	if (param->size <= sizeof(*param)) {
+	if (param->size <= AUTOFS_DEV_IOCTL_SIZE) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -539,7 +539,7 @@ static int autofs_dev_ioctl_ismountpoint
 	unsigned int devid, magic;
 	int err = -ENOENT;
 
-	if (param->size <= sizeof(*param)) {
+	if (param->size <= AUTOFS_DEV_IOCTL_SIZE) {
 		err = -EINVAL;
 		goto out;
 	}
_

Patches currently in -mm which might be from tkusumi@tuxera.com are


