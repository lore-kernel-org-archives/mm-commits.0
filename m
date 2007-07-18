From: akpm@linux-foundation.org
Subject: + fix-leak-on-proc-lockdep_stats.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:54:04 -0700
Message-ID: <200707180054.l6I0s41g016435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757582AbXGRAyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, stable@kernel.org


The patch titled
     Fix leak on /proc/lockdep_stats
has been added to the -mm tree.  Its filename is
     fix-leak-on-proc-lockdep_stats.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix leak on /proc/lockdep_stats
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep_proc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/lockdep_proc.c~fix-leak-on-proc-lockdep_stats kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~fix-leak-on-proc-lockdep_stats
+++ a/kernel/lockdep_proc.c
@@ -339,7 +339,7 @@ static const struct file_operations proc
 	.open		= lockdep_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 static int __init lockdep_proc_init(void)
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
