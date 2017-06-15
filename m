From: akpm@linux-foundation.org
Subject: +
 autofs-sanity-check-status-reported-with-autofs_dev_ioctl_fail.patch added
 to -mm tree
Date: Thu, 15 Jun 2017 16:34:04 -0700
Message-ID: <5943196c.OPUyX8+DQuOkjOBd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49298 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdFOXeF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 19:34:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: sanity check status reported with AUTOFS_DEV_IOCTL_FAIL
has been added to the -mm tree.  Its filename is
     autofs-sanity-check-status-reported-with-autofs_dev_ioctl_fail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-sanity-check-status-reported-with-autofs_dev_ioctl_fail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-sanity-check-status-reported-with-autofs_dev_ioctl_fail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

autofs-sanity-check-status-reported-with-autofs_dev_ioctl_fail.patch

