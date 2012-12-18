From: akpm@linux-foundation.org
Subject: [merged] aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:45 -0800
Message-ID: <20121218200945.A34F082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54693 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2LRUJq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:46 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so126077vbi.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: support the forgetting (flushing) of a user-specified AoE target
has been removed from the -mm tree.  Its filename was
     aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: support the forgetting (flushing) of a user-specified AoE target

Users sometimes want to cause the aoe driver to forget a particular
previously discovered device when it is no longer online.  The aoetools
provide an "aoe-flush" command that users run to perform this
administrative task.  The changes below provide the support needed in the
driver.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |   44 ++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 6 deletions(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target
+++ a/drivers/block/aoe/aoedev.c
@@ -241,6 +241,30 @@ aoedev_freedev(struct aoedev *d)
 	kfree(d);
 }
 
+/* return whether the user asked for this particular
+ * device to be flushed
+ */
+static int
+user_req(char *s, size_t slen, struct aoedev *d)
+{
+	char *p;
+	size_t lim;
+
+	if (!d->gd)
+		return 0;
+	p = strrchr(d->gd->disk_name, '/');
+	if (!p)
+		p = d->gd->disk_name;
+	else
+		p += 1;
+	lim = sizeof(d->gd->disk_name);
+	lim -= p - d->gd->disk_name;
+	if (slen < lim)
+		lim = slen;
+
+	return !strncmp(s, p, lim);
+}
+
 int
 aoedev_flush(const char __user *str, size_t cnt)
 {
@@ -249,6 +273,7 @@ aoedev_flush(const char __user *str, siz
 	struct aoedev *rmd = NULL;
 	char buf[16];
 	int all = 0;
+	int specified = 0;	/* flush a specific device */
 
 	if (cnt >= 3) {
 		if (cnt > sizeof buf)
@@ -256,26 +281,33 @@ aoedev_flush(const char __user *str, siz
 		if (copy_from_user(buf, str, cnt))
 			return -EFAULT;
 		all = !strncmp(buf, "all", 3);
+		if (!all)
+			specified = 1;
 	}
 
 	spin_lock_irqsave(&devlist_lock, flags);
 	dd = &devlist;
 	while ((d = *dd)) {
 		spin_lock(&d->lock);
-		if ((!all && (d->flags & DEVFL_UP))
+		if (specified) {
+			if (!user_req(buf, cnt, d))
+				goto skip;
+		} else if ((!all && (d->flags & DEVFL_UP))
 		|| (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
 		|| d->nopen
-		|| d->ref) {
-			spin_unlock(&d->lock);
-			dd = &d->next;
-			continue;
-		}
+		|| d->ref)
+			goto skip;
+
 		*dd = d->next;
 		aoedev_downdev(d);
 		d->flags |= DEVFL_TKILL;
 		spin_unlock(&d->lock);
 		d->next = rmd;
 		rmd = d;
+		continue;
+skip:
+		spin_unlock(&d->lock);
+		dd = &d->next;
 	}
 	spin_unlock_irqrestore(&devlist_lock, flags);
 	while ((d = rmd)) {
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

