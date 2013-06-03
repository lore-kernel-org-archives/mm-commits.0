From: akpm@linux-foundation.org
Subject: [merged] vfs-fix-invalid-ida_remove-call.patch removed from -mm
 tree
Date: Mon, 03 Jun 2013 13:29:59 -0700
Message-ID: <51acfcc7.+dPO2VcxAy2RMI0x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3FCUaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 16:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, crrodriguez@opensuse.org, tiwai@suse.de

Subject: [merged] vfs-fix-invalid-ida_remove-call.patch removed from -mm tree
To: tiwai@suse.de,crrodriguez@opensuse.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 13:29:59 -0700


The patch titled
     Subject: vfs: fix invalid ida_remove() call
has been removed from the -mm tree.  Its filename was
     vfs-fix-invalid-ida_remove-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drm-cirrus-correct-register-values-for-16bpp.patch
idr-print-a-stack-dump-after-ida_remove-warning.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch

