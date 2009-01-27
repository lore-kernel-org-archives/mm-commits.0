From: akpm@linux-foundation.org
Subject: [nacked] export-get_task_comm.patch removed from -mm tree
Date: Tue, 27 Jan 2009 01:01:08 -0800
Message-ID: <200901270901.n0R918Iu009223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbZA0JBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 04:01:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, lirc@bartelmus.de, mm-commits@vger.kernel.org


The patch titled
     export get_task_comm()
has been removed from the -mm tree.  Its filename was
     export-get_task_comm.patch

This patch was dropped because it was nacked

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

