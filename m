From: akpm@linux-foundation.org
Subject: + aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch added to -mm tree
Date: Wed, 17 Oct 2012 15:10:40 -0700
Message-ID: <20121017221041.05FB2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40239 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2JQWKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 18:10:41 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so998975ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 15:10:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: support the forgetting (flushing) of a user-specified AoE target
has been added to the -mm tree.  Its filename is
     aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch

