From: akpm@linux-foundation.org
Subject: + proc-fix-warnings.patch added to -mm tree
Date: Mon, 04 Aug 2008 17:06:37 -0700
Message-ID: <200808050006.m7506b6Q006899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbYHEAGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 20:06:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, oleg@tv-sign.ru, righi.andrea@gmail.com


The patch titled
     proc: fix warnings
has been added to the -mm tree.  Its filename is
     proc-fix-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
atyfb_basec-fix-warning.patch
omfs-fix-warning.patch
proc-fix-warnings.patch
linux-next.patch

