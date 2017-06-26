From: akpm@linux-foundation.org
Subject: [merged]
 autofs-sanity-check-status-reported-with-autofs_dev_ioctl_fail.patch
 removed from -mm tree
Date: Mon, 26 Jun 2017 13:22:42 -0700
Message-ID: <20170626202242.1lHqWpUcv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51384 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbdFZUW6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 16:22:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, neilb@suse.com, raven@themaw.net, stable@vger.kernel.org


The patch titled
     Subject: autofs: sanity check status reported with AUTOFS_DEV_IOCTL_FAIL
has been removed from the -mm tree.  Its filename was
     autofs-sanity-check-status-reported-with-autofs_dev_ioctl_fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.com>
Subject: autofs: sanity check status reported with AUTOFS_DEV_IOCTL_FAIL

If a positive status is passed with the AUTOFS_DEV_IOCTL_FAIL ioctl,
autofs4_d_automount() will return

   ERR_PTR(status)

with that status to follow_automount(), which will then dereference an
invalid pointer.

So treat a positive status the same as zero, and map to ENOENT.

See comment in systemd src/core/automount.c::automount_send_ready().

Link: http://lkml.kernel.org/r/871sqwczx5.fsf@notabene.neil.brown.name
Signed-off-by: NeilBrown <neilb@suse.com>
Cc: Ian Kent <raven@themaw.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-sanity-check-status-reported-with-autofs_dev_ioctl_fail fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-sanity-check-status-reported-with-autofs_dev_ioctl_fail
+++ a/fs/autofs4/dev-ioctl.c
@@ -344,7 +344,7 @@ static int autofs_dev_ioctl_fail(struct
 	int status;
 
 	token = (autofs_wqt_t) param->fail.token;
-	status = param->fail.status ? param->fail.status : -ENOENT;
+	status = param->fail.status < 0 ? param->fail.status : -ENOENT;
 	return autofs4_wait_release(sbi, token, status);
 }
 
_

Patches currently in -mm which might be from neilb@suse.com are


