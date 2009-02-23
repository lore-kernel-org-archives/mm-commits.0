From: akpm@linux-foundation.org
Subject: [merged] pm-wait-for-console-in-resume.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:07:05 -0800
Message-ID: <200902232007.n1NK75bZ013460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058AbZBWUHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:07:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arve@android.com, alan@lxorguk.ukuu.org.uk, pavel@ucw.cz, rjw@sisk.pl, swetland@google.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     pm: wait for console in resume
has been removed from the -mm tree.  Its filename was
     pm-wait-for-console-in-resume.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: pm: wait for console in resume
=46rom: Arve Hj=F8nnev=E5g <arve@android.com>

Avoids later waking up to a blinking cursor if the device woke up and
returned to sleep before the console switch happened.

Signed-off-by: Brian Swetland <swetland@google.com>
Signed-off-by: Arve Hj=F8nnev=E5g <arve@android.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/console.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/power/console.c~pm-wait-for-console-in-resume kernel/p=
ower/console.c
--- a/kernel/power/console.c~pm-wait-for-console-in-resume
+++ a/kernel/power/console.c
@@ -78,6 +78,12 @@ void pm_restore_console(void)
 	}
 	set_console(orig_fgconsole);
 	release_console_sem();
+
+	if (vt_waitactive(orig_fgconsole)) {
+		pr_debug("Resume: Can't switch VCs.");
+		return;
+	}
+
 	kmsg_redirect =3D orig_kmsg;
 }
 #endif
_

Patches currently in -mm which might be from arve@android.com are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
