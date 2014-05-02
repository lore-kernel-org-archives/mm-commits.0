From: akpm@linux-foundation.org
Subject: +
 fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking.patch
 added to -mm tree
Date: Fri, 02 May 2014 15:08:21 -0700
Message-ID: <53641755.zzw2eNsTDWKBWb2Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaEBWIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 18:08:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, jack@suse.cz, xypron.glpk@gmx.de

Subject: + fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking.patch added to -mm tree
To: xypron.glpk@gmx.de,jack@suse.cz,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 15:08:21 -0700


The patch titled
     Subject: fs/notify/fanotify/fanotify_user.c: fix FAN_MARK_FLUSH flag checking
has been added to the -mm tree.  Its filename is
     fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch
fanotify-create-fan_access-event-for-readdir.patch
fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking.patch

