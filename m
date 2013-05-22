From: akpm@linux-foundation.org
Subject: + vfs-fix-invalid-ida_remove-call.patch added to -mm tree
Date: Wed, 22 May 2013 14:41:48 -0700
Message-ID: <519d3b9c.8HDWHvjAVC4cd5Fb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3EVVlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 17:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, crrodriguez@opensuse.org, tiwai@suse.de

Subject: + vfs-fix-invalid-ida_remove-call.patch added to -mm tree
To: tiwai@suse.de,crrodriguez@opensuse.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 14:41:48 -0700


The patch titled
     Subject: vfs: fix invalid ida_remove() call
has been added to the -mm tree.  Its filename is
     vfs-fix-invalid-ida_remove-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Takashi Iwai <tiwai@suse.de>
Subject: vfs: fix invalid ida_remove() call

When the group id of a shared mount is not allocated, the umount still
tries to call mnt_release_group_id(), which eventually hits a kernel
warning at ida_remove() spewing a message like:

  ida_remove called for id=0 which is not allocated.

This patch fixes the bug simply checking the group id in the caller.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Cristian Rodríguez <crrodriguez@opensuse.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pnode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/pnode.c~vfs-fix-invalid-ida_remove-call fs/pnode.c
--- a/fs/pnode.c~vfs-fix-invalid-ida_remove-call
+++ a/fs/pnode.c
@@ -83,7 +83,8 @@ static int do_make_slave(struct mount *m
 		if (peer_mnt == mnt)
 			peer_mnt = NULL;
 	}
-	if (IS_MNT_SHARED(mnt) && list_empty(&mnt->mnt_share))
+	if (mnt->mnt_group_id && IS_MNT_SHARED(mnt) &&
+	    list_empty(&mnt->mnt_share))
 		mnt_release_group_id(mnt);
 
 	list_del_init(&mnt->mnt_share);
_

Patches currently in -mm which might be from tiwai@suse.de are

linux-next.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
vfs-fix-invalid-ida_remove-call.patch
idr-print-a-stack-dump-after-ida_remove-warning.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch

