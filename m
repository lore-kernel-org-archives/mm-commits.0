From: akpm@linux-foundation.org
Subject: [merged]
 fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:42:13 -0700
Message-ID: <5390c815.yLHu8/WVUYLq6Wdv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaFETmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, jack@suse.cz, xypron.glpk@gmx.de

Subject: [merged] fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking.patch removed from -mm tree
To: xypron.glpk@gmx.de,jack@suse.cz,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:13 -0700


The patch titled
     Subject: fs/notify/fanotify/fanotify_user.c: fix FAN_MARK_FLUSH flag checking
has been removed from the -mm tree.  Its filename was
     fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: fs/notify/fanotify/fanotify_user.c: fix FAN_MARK_FLUSH flag checking

If fanotify_mark is called with illegal value of arguments flags and marks
it usually returns EINVAL.

When fanotify_mark is called with FAN_MARK_FLUSH the argument flags is not
checked for irrelevant flags like FAN_MARK_IGNORED_MASK.

The patch removes this inconsistency.

If an irrelevant flag is set error EINVAL is returned.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/notify/fanotify/fanotify_user.c~fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -776,7 +776,10 @@ SYSCALL_DEFINE5(fanotify_mark, int, fano
 	case FAN_MARK_REMOVE:
 		if (!mask)
 			return -EINVAL;
+		break;
 	case FAN_MARK_FLUSH:
+		if (flags & ~(FAN_MARK_MOUNT | FAN_MARK_FLUSH))
+			return -EINVAL;
 		break;
 	default:
 		return -EINVAL;
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

origin.patch
linux-next.patch

