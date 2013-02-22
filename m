From: akpm@linux-foundation.org
Subject: + kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch added to -mm tree
Date: Fri, 22 Feb 2013 13:13:50 -0800
Message-ID: <20130222211350.B80355A4252@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34599 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab3BVVNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 16:13:52 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so107338vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 13:13:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jwboyer@redhat.com, eparis@redhat.com, jmorris@namei.org, lists@nerdbynature.de, stable@vger.kernel.org


The patch titled
     Subject: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
has been added to the -mm tree.  Its filename is
     kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -621,6 +621,9 @@ static int devkmsg_open(struct inode *in
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
linux-next.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-v3-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

