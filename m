From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 071/127] proc: rename "catch" function argument
Date: Thu, 04 Jun 2020 16:49:55 -0700
Message-ID: <20200604234955.9KOkCzDj8%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXt4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:56 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
