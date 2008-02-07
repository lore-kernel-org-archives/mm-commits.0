From: akpm@linux-foundation.org
Subject: - proc-loadavg-reading-race.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:55 -0800
Message-ID: <200802070022.m170Makf006438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760540AbYBGApD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mschmidt@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     proc: loadavg reading race
has been removed from the -mm tree.  Its filename was
     proc-loadavg-reading-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: loadavg reading race
From: Michal Schmidt <mschmidt@redhat.com>

The avenrun[] values are supposed to be protected by xtime_lock. 
loadavg_read_proc does not use it.  Theoretically this may result in an
occasional glitch when the value read from /proc/loadavg would be as much
as 1<<11 times higher than it should be.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/proc/proc_misc.c~proc-loadavg-reading-race fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~proc-loadavg-reading-race
+++ a/fs/proc/proc_misc.c
@@ -84,10 +84,15 @@ static int loadavg_read_proc(char *page,
 {
 	int a, b, c;
 	int len;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		a = avenrun[0] + (FIXED_1/200);
+		b = avenrun[1] + (FIXED_1/200);
+		c = avenrun[2] + (FIXED_1/200);
+	} while (read_seqretry(&xtime_lock, seq));
 
-	a = avenrun[0] + (FIXED_1/200);
-	b = avenrun[1] + (FIXED_1/200);
-	c = avenrun[2] + (FIXED_1/200);
 	len = sprintf(page,"%d.%02d %d.%02d %d.%02d %ld/%d %d\n",
 		LOAD_INT(a), LOAD_FRAC(a),
 		LOAD_INT(b), LOAD_FRAC(b),
_

Patches currently in -mm which might be from mschmidt@redhat.com are

origin.patch
