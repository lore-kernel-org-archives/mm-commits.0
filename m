From: akpm@linux-foundation.org
Subject: + export-get_task_comm.patch added to -mm tree
Date: Mon, 26 Jan 2009 21:17:00 -0800
Message-ID: <200901270517.n0R5H0nO028366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536AbZA0FR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 00:17:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, lirc@bartelmus.de


The patch titled
     export get_task_comm()
has been added to the -mm tree.  Its filename is
     export-get_task_comm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: export get_task_comm()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

task_struct.comm[] is useful for debugging and driver developers want to
use this information easily.  Direct access to task_struct.comm[] is a bit
racy, so export the official accessor.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/exec.c~export-get_task_comm fs/exec.c
--- a/fs/exec.c~export-get_task_comm
+++ a/fs/exec.c
@@ -943,6 +943,7 @@ char *get_task_comm(char *buf, struct ta
 	task_unlock(tsk);
 	return buf;
 }
+EXPORT_SYMBOL_GPL(get_task_comm);
 
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
export-get_task_comm.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

