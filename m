From: akpm@linux-foundation.org
Subject: - proc-fix-warnings.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:57:12 -0700
Message-ID: <200808062057.m76KvCSX014749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754986AbYHFVBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:01:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, oleg@tv-sign.ru, righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: fix warnings
has been removed from the -mm tree.  Its filename was
     proc-fix-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: fix warnings
From: Alexander Beregalov <a.beregalov@gmail.com>

proc: fix warnings

fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 3 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 4 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 5 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 6 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 7 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 8 has type 'u64'
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 9 has type 'u64'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Acked-by: Andrea Righi <righi.andrea@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-fix-warnings fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-warnings
+++ a/fs/proc/base.c
@@ -2423,10 +2423,13 @@ static int do_io_accounting(struct task_
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
 			"cancelled_write_bytes: %llu\n",
-			acct.rchar, acct.wchar,
-			acct.syscr, acct.syscw,
-			acct.read_bytes, acct.write_bytes,
-			acct.cancelled_write_bytes);
+			(unsigned long long)acct.rchar,
+			(unsigned long long)acct.wchar,
+			(unsigned long long)acct.syscr,
+			(unsigned long long)acct.syscw,
+			(unsigned long long)acct.read_bytes,
+			(unsigned long long)acct.write_bytes,
+			(unsigned long long)acct.cancelled_write_bytes);
 }
 
 static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch
git-sparc64.patch

