From: akpm@linux-foundation.org
Subject: - whitespace-fixes-process-accounting.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:32 -0700
Message-ID: <200710190343.l9J3hW4U013069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966266AbXJSDzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: process accounting
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-process-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: process accounting
From: Daniel Walker <dwalker@mvista.com>

Lots of converting spaces to tabs.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |   64 ++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff -puN kernel/acct.c~whitespace-fixes-process-accounting kernel/acct.c
--- a/kernel/acct.c~whitespace-fixes-process-accounting
+++ a/kernel/acct.c
@@ -329,16 +329,16 @@ static comp_t encode_comp_t(unsigned lon
 	}
 
 	/*
-         * If we need to round up, do it (and handle overflow correctly).
-         */
+	 * If we need to round up, do it (and handle overflow correctly).
+	 */
 	if (rnd && (++value > MAXFRACT)) {
 		value >>= EXPSIZE;
 		exp++;
 	}
 
 	/*
-         * Clean it up and polish it off.
-         */
+	 * Clean it up and polish it off.
+	 */
 	exp <<= MANTSIZE;		/* Shift the exponent into place */
 	exp += value;			/* and add on the mantissa. */
 	return exp;
@@ -361,30 +361,30 @@ static comp_t encode_comp_t(unsigned lon
 
 static comp2_t encode_comp2_t(u64 value)
 {
-        int exp, rnd;
+	int exp, rnd;
 
-        exp = (value > (MAXFRACT2>>1));
-        rnd = 0;
-        while (value > MAXFRACT2) {
-                rnd = value & 1;
-                value >>= 1;
-                exp++;
-        }
-
-        /*
-         * If we need to round up, do it (and handle overflow correctly).
-         */
-        if (rnd && (++value > MAXFRACT2)) {
-                value >>= 1;
-                exp++;
-        }
-
-        if (exp > MAXEXP2) {
-                /* Overflow. Return largest representable number instead. */
-                return (1ul << (MANTSIZE2+EXPSIZE2-1)) - 1;
-        } else {
-                return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));
-        }
+	exp = (value > (MAXFRACT2>>1));
+	rnd = 0;
+	while (value > MAXFRACT2) {
+		rnd = value & 1;
+		value >>= 1;
+		exp++;
+	}
+
+	/*
+	 * If we need to round up, do it (and handle overflow correctly).
+	 */
+	if (rnd && (++value > MAXFRACT2)) {
+		value >>= 1;
+		exp++;
+	}
+
+	if (exp > MAXEXP2) {
+		/* Overflow. Return largest representable number instead. */
+		return (1ul << (MANTSIZE2+EXPSIZE2-1)) - 1;
+	} else {
+		return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));
+	}
 }
 #endif
 
@@ -501,14 +501,14 @@ static void do_acct_process(struct file 
 	ac.ac_swaps = encode_comp_t(0);
 
 	/*
-         * Kernel segment override to datasegment and write it
-         * to the accounting file.
-         */
+	 * Kernel segment override to datasegment and write it
+	 * to the accounting file.
+	 */
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 	/*
- 	 * Accounting records are not subject to resource limits.
- 	 */
+	 * Accounting records are not subject to resource limits.
+	 */
 	flim = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	file->f_op->write(file, (char *)&ac,
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
