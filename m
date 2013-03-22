From: akpm@linux-foundation.org
Subject: [obsolete] kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch removed from -mm tree
Date: Fri, 22 Mar 2013 14:54:54 -0700
Message-ID: <20130322215454.70B4C31C15E__23824.4865010076$1363989337$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:39664 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423344Ab3CVVyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 17:54:55 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so427043vea.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 14:54:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jwboyer@redhat.com, eparis@redhat.com, jmorris@namei.org, lists@nerdbynature.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
has been removed from the -mm tree.  Its filename was
     kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Josh Boyer <jwboyer@redhat.com>
Subject: kmsg: honor dmesg_restrict sysctl on /dev/kmsg

Originally, the addition of dmesg_restrict covered both the syslog
method of accessing dmesg, as well as /dev/kmsg itself.  This was done
indirectly by security_syslog calling cap_syslog before doing any LSM
checks.

However, commit 12b3052c3ee ("capabilities/syslog: open code cap_syslog
logic to fix build failure") moved the code around and pushed the checks
into the caller itself.  That seems to have inadvertently dropped the
checks for dmesg_restrict on /dev/kmsg.  Most people haven't noticed
because util-linux dmesg(1) defaults to using the syslog method for access
in older versions.  With util-linux 2.22 and a kernel newer than 3.5,
dmesg(1) defaults to reading directly from /dev/kmsg.

Fix this by making an explicit check in the devkmsg_open function.

This fixes https://bugzilla.redhat.com/show_bug.cgi?id=903192

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg kernel/printk.c
--- a/kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg
+++ a/kernel/printk.c
@@ -620,6 +620,9 @@ static int devkmsg_open(struct inode *in
 	struct devkmsg_user *user;
 	int err;
 
+	if (dmesg_restrict && !capable(CAP_SYSLOG))
+		return -EACCES;
+
 	/* write-only does not need any file context */
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
_

Patches currently in -mm which might be from jwboyer@redhat.com are

origin.patch
mkcapflagspl-convert-to-mkcapflagssh.patch
headers_installpl-convert-to-headers_installsh.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

