From: akpm@linux-foundation.org
Subject: + proc-rename-catch-function-argument.patch added to -mm
 tree
Date: Wed, 15 Apr 2020 21:07:41 -0700
Message-ID: <20200416040741.MspmCtvON%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgDPEHm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Apr 2020 00:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: rename "catch" function argument
has been added to the -mm tree.  Its filename is
     proc-rename-catch-function-argument.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-rename-catch-function-argument.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-rename-catch-function-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: rename "catch" function argument

"catch" is reserved keyword in C++, rename it to something both gcc and
g++ accept.

Rename "ign" for symmetry.

Link: http://lkml.kernel.org/r/20200331210905.GA31680@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/array.c~proc-rename-catch-function-argument
+++ a/fs/proc/array.c
@@ -248,8 +248,8 @@ void render_sigset_t(struct seq_file *m,
 	seq_putc(m, '\n');
 }
 
-static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
-				    sigset_t *catch)
+static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *sigign,
+				    sigset_t *sigcatch)
 {
 	struct k_sigaction *k;
 	int i;
@@ -257,9 +257,9 @@ static void collect_sigign_sigcatch(stru
 	k = p->sighand->action;
 	for (i = 1; i <= _NSIG; ++i, ++k) {
 		if (k->sa.sa_handler == SIG_IGN)
-			sigaddset(ign, i);
+			sigaddset(sigign, i);
 		else if (k->sa.sa_handler != SIG_DFL)
-			sigaddset(catch, i);
+			sigaddset(sigcatch, i);
 	}
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
proc-rename-catch-function-argument.patch
