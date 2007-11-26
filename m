From: akpm@linux-foundation.org
Subject: + proc-loadavg-reading-race.patch added to -mm tree
Date: Sun, 25 Nov 2007 23:41:22 -0800
Message-ID: <200711260741.lAQ7fMxf022707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbXKZHmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 02:42:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mschmidt@redhat.com, tglx@linutronix.de


The patch titled
     proc: loadavg reading race
has been added to the -mm tree.  Its filename is
     proc-loadavg-reading-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch
proc-loadavg-reading-race.patch
