From: akpm@linux-foundation.org
Subject: +
 printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-update.patch
 added to -mm tree
Date: Tue, 19 Jul 2016 11:35:23 -0700
Message-ID: <578e72eb.o69wt1DSeUBvusws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbcGSSfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 14:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, dyoung@redhat.com, fbui@suse.com, gregkh@linuxfoundation.org, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-add-kernel-parameter-to-control-writes-to-dev-kmsg=
-update
has been added to the -mm tree.  Its filename is
     printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-update.p=
atch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-add-kernel-paramete=
r-to-control-writes-to-dev-kmsg-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-add-kernel-paramete=
r-to-control-writes-to-dev-kmsg-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Borislav Petkov <bp@suse.de>
Subject: printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-upda=
te

Thanks for catching this, here's an updated 2/2 patch with the above
integrated and the SYSTEM_BOOTING check removed because we set
system_state to SYSTEM_RUNNING before we start init.

Link: http://lkml.kernel.org/r/20160719072344.GC25563@nazgul.tnic
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Dave Young <dyoung@redhat.com>
Cc: Franck Bui <fbui@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/printk/printk.c~printk-add-kernel-parameter-to-control=
-writes-to-dev-kmsg-update kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-kernel-parameter-to-control-wri=
tes-to-dev-kmsg-update
+++ a/kernel/printk/printk.c
@@ -117,8 +117,7 @@ static int __control_devkmsg(char *str)
 		devkmsg_log =3D DEVKMSG_LOG_MASK_DEFAULT;
 		return 9;
 	}
-	else
-		return -EINVAL;
+	return -EINVAL;
 }
=20
 static int __init control_devkmsg(char *str)
@@ -741,8 +740,8 @@ static ssize_t devkmsg_write(struct kioc
 	if (devkmsg_log & DEVKMSG_LOG_MASK_OFF)
 		return len;
=20
-	/* Ratelimit when not explicitly enabled or when we're not booting. *=
/
-	if ((system_state !=3D SYSTEM_BOOTING) && !(devkmsg_log & DEVKMSG_LOG=
_MASK_ON)) {
+	/* Ratelimit when not explicitly enabled. */
+	if (!(devkmsg_log & DEVKMSG_LOG_MASK_ON)) {
 		if (!___ratelimit(&user->rs, current->comm))
 			return ret;
 	}
_

Patches currently in -mm which might be from bp@suse.de are

ratelimit-extend-to-print-suppressed-messages-on-release.patch
printk-add-kernel-parameter-to-control-writes-to-dev-kmsg.patch
printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-update.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
