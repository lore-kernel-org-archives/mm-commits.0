From: akpm@linux-foundation.org
Subject: + lockstat-human-readability-tweaks-fix.patch added to -mm tree
Date: Wed, 18 Jul 2007 00:27:17 -0700
Message-ID: <200707180731.l6I7VgER030396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756460AbXGRHcP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 03:32:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, bunk@stusta.de, jbaron@redhat.com, mingo@elte.hu


The patch titled
     lockstat-human-readability-tweaks-fix
has been added to the -mm tree.  Its filename is
     lockstat-human-readability-tweaks-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockstat-human-readability-tweaks-fix
From: Andrew Morton <akpm@linux-foundation.org>

kernel/lockdep_proc.c:394: warning: long long int format, s64 arg (arg 4)

Cc: Adrian Bunk <bunk@stusta.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/lockdep_proc.c~lockstat-human-readability-tweaks-fix kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~lockstat-human-readability-tweaks-fix
+++ a/kernel/lockdep_proc.c
@@ -391,7 +391,7 @@ static void snprint_time(char *buf, size
 	unsigned long rem;
 
 	rem = do_div(nr, 1000); /* XXX: do_div_signed */
-	snprintf(buf, bufsiz, "%lld.%02d", nr, ((int)rem+5)/10);
+	snprintf(buf, bufsiz, "%lld.%02d", (long long)nr, ((int)rem+5)/10);
 }
 
 static void seq_time(struct seq_file *m, s64 time)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
readahead-split-ondemand-readahead-interface-into-two-functions-fix.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
add-sys-kernel-notes-fix.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks-fix.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
