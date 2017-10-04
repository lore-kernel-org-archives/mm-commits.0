From: akpm@linux-foundation.org
Subject: +
 tty-fall-back-to-n_null-if-switching-to-n_tty-fails-during-hangup.patch
 added to -mm tree
Date: Wed, 04 Oct 2017 15:32:16 -0700
Message-ID: <59d56170.apzx3k5IJWD7/Fvj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44742 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdJDWcR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 18:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, alan@llwyncelyn.cymru, dvyukov@google.com, hch@lst.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tty: fall back to N_NULL if switching to N_TTY fails during hangup
has been added to the -mm tree.  Its filename is
     tty-fall-back-to-n_null-if-switching-to-n_tty-fails-during-hangup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tty-fall-back-to-n_null-if-switching-to-n_tty-fails-during-hangup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tty-fall-back-to-n_null-if-switching-to-n_tty-fails-during-hangup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: tty: fall back to N_NULL if switching to N_TTY fails during hangup

We have seen NULL-pointer dereference crashes in tty->disc_data when the
N_TTY fallback driver failed to open during hangup.  The immediate cause
of this open to fail has been addressed in the preceding patch to
vmalloc(), but this code could be more robust.

As Alan pointed out in 8a8dabf2dd68 ("tty: handle the case where we cannot
restore a line discipline"), the N_TTY driver, historically the safe
fallback that could never fail, can indeed fail, but the surrounding code
is not prepared to handle this.  To avoid crashes he added a new N_NULL
driver to take N_TTY's place as the last resort.

Hook that fallback up to the hangup path.  Update tty_ldisc_reinit() to
reflect the reality that n_tty_open can indeed fail.

Link: http://lkml.kernel.org/r/20171004185959.GC2136@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alan Cox <alan@llwyncelyn.cymru>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/tty_ldisc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/tty/tty_ldisc.c~tty-fall-back-to-n_null-if-switching-to-n_tty-fails-during-hangup drivers/tty/tty_ldisc.c
--- a/drivers/tty/tty_ldisc.c~tty-fall-back-to-n_null-if-switching-to-n_tty-fails-during-hangup
+++ a/drivers/tty/tty_ldisc.c
@@ -694,10 +694,8 @@ int tty_ldisc_reinit(struct tty_struct *
 	tty_set_termios_ldisc(tty, disc);
 	retval = tty_ldisc_open(tty, tty->ldisc);
 	if (retval) {
-		if (!WARN_ON(disc == N_TTY)) {
-			tty_ldisc_put(tty->ldisc);
-			tty->ldisc = NULL;
-		}
+		tty_ldisc_put(tty->ldisc);
+		tty->ldisc = NULL;
 	}
 	return retval;
 }
@@ -752,8 +750,9 @@ void tty_ldisc_hangup(struct tty_struct
 
 	if (tty->ldisc) {
 		if (reinit) {
-			if (tty_ldisc_reinit(tty, tty->termios.c_line) < 0)
-				tty_ldisc_reinit(tty, N_TTY);
+			if (tty_ldisc_reinit(tty, tty->termios.c_line) < 0 &&
+			    tty_ldisc_reinit(tty, N_TTY) < 0)
+				WARN_ON(tty_ldisc_reinit(tty, N_NULL) < 0);
 		} else
 			tty_ldisc_kill(tty);
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

revert-vmalloc-back-off-when-the-current-task-is-killed.patch
tty-fall-back-to-n_null-if-switching-to-n_tty-fails-during-hangup.patch

