From: akpm@linux-foundation.org
Subject: + ratelimit-extend-to-print-suppressed-messages-on-release.patch
 added to -mm tree
Date: Mon, 18 Jul 2016 14:26:02 -0700
Message-ID: <578d496a.nacPwNozEk/GsCPV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbcGRV0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jul 2016 17:26:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, dyoung@redhat.com, fbui@suse.com, gregkh@linuxfoundation.org, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ratelimit: extend to print suppressed messages on release
has been added to the -mm tree.  Its filename is
     ratelimit-extend-to-print-suppressed-messages-on-release.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ratelimit-extend-to-print-=
suppressed-messages-on-release.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ratelimit-extend-to-print-=
suppressed-messages-on-release.patch

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
Subject: ratelimit: extend to print suppressed messages on release

Extend the ratelimiting facility to print the amount of suppressed line=
s
when it is being released.

This use case is aimed at short-termed, burst-like users for which we w=
ant
to output the suppressed lines stats only once, after it has been dispo=
sed
of.  For an example, see /dev/kmsg usage in a follow-on patch.

Also, change the printk() line we issue on release to not use "callback=
s"
as it is misleading: we're not suppressing callbacks but printk() calls=
=2E

This has been separated from a previous patch by Linus.

Link: http://lkml.kernel.org/r/20160716061745.15795-2-bp@alien8.de
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

 include/linux/ratelimit.h |   38 +++++++++++++++++++++++++++++++-----
 lib/ratelimit.c           |   10 +++++----
 2 files changed, 39 insertions(+), 9 deletions(-)

diff -puN include/linux/ratelimit.h~ratelimit-extend-to-print-suppresse=
d-messages-on-release include/linux/ratelimit.h
--- a/include/linux/ratelimit.h~ratelimit-extend-to-print-suppressed-me=
ssages-on-release
+++ a/include/linux/ratelimit.h
@@ -2,11 +2,15 @@
 #define _LINUX_RATELIMIT_H
=20
 #include <linux/param.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
=20
 #define DEFAULT_RATELIMIT_INTERVAL	(5 * HZ)
 #define DEFAULT_RATELIMIT_BURST		10
=20
+/* issue num suppressed message on exit */
+#define RATELIMIT_MSG_ON_RELEASE	BIT(0)
+
 struct ratelimit_state {
 	raw_spinlock_t	lock;		/* protect the state */
=20
@@ -15,6 +19,7 @@ struct ratelimit_state {
 	int		printed;
 	int		missed;
 	unsigned long	begin;
+	unsigned long	flags;
 };
=20
 #define RATELIMIT_STATE_INIT(name, interval_init, burst_init) {		\
@@ -34,12 +39,35 @@ struct ratelimit_state {
 static inline void ratelimit_state_init(struct ratelimit_state *rs,
 					int interval, int burst)
 {
+	memset(rs, 0, sizeof(*rs));
+
 	raw_spin_lock_init(&rs->lock);
-	rs->interval =3D interval;
-	rs->burst =3D burst;
-	rs->printed =3D 0;
-	rs->missed =3D 0;
-	rs->begin =3D 0;
+	rs->interval	=3D interval;
+	rs->burst	=3D burst;
+}
+
+static inline void ratelimit_default_init(struct ratelimit_state *rs)
+{
+	return ratelimit_state_init(rs, DEFAULT_RATELIMIT_INTERVAL,
+					DEFAULT_RATELIMIT_BURST);
+}
+
+static inline void ratelimit_state_exit(struct ratelimit_state *rs)
+{
+	if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE))
+		return;
+
+	if (rs->missed) {
+		pr_warn("%s: %d output lines suppressed due to ratelimiting\n",
+			current->comm, rs->missed);
+		rs->missed =3D 0;
+	}
+}
+
+static inline void
+ratelimit_set_flags(struct ratelimit_state *rs, unsigned long flags)
+{
+	rs->flags =3D flags;
 }
=20
 extern struct ratelimit_state printk_ratelimit_state;
diff -puN lib/ratelimit.c~ratelimit-extend-to-print-suppressed-messages=
-on-release lib/ratelimit.c
--- a/lib/ratelimit.c~ratelimit-extend-to-print-suppressed-messages-on-=
release
+++ a/lib/ratelimit.c
@@ -46,12 +46,14 @@ int ___ratelimit(struct ratelimit_state
 		rs->begin =3D jiffies;
=20
 	if (time_is_before_jiffies(rs->begin + rs->interval)) {
-		if (rs->missed)
-			printk(KERN_WARNING "%s: %d callbacks suppressed\n",
-				func, rs->missed);
+		if (rs->missed) {
+			if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
+				pr_warn("%s: %d callbacks suppressed\n", func, rs->missed);
+				rs->missed =3D 0;
+			}
+		}
 		rs->begin   =3D jiffies;
 		rs->printed =3D 0;
-		rs->missed  =3D 0;
 	}
 	if (rs->burst && rs->burst > rs->printed) {
 		rs->printed++;
_

Patches currently in -mm which might be from bp@suse.de are

ratelimit-extend-to-print-suppressed-messages-on-release.patch
printk-add-kernel-parameter-to-control-writes-to-dev-kmsg.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
