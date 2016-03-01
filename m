From: akpm@linux-foundation.org
Subject: +
 proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch added to -mm tree
Date: Tue, 01 Mar 2016 11:26:39 -0800
Message-ID: <56d5ecef.Ps0V9h2a0l5Dm+qz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcCAT0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 14:26:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc/base: make prompt shell start from new line after executing "cat /proc/$pid/wchan"
has been added to the -mm tree.  Its filename is
     proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minfei Huang <mnfhuang@gmail.com>
Subject: proc/base: make prompt shell start from new line after executing "cat /proc/$pid/wchan"

It is not elegant that prompt shell does not start from new line after
executing "cat /proc/$pid/wchan".  Make prompt shell start from new line.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan fs/proc/base.c
--- a/fs/proc/base.c~proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan
+++ a/fs/proc/base.c
@@ -434,7 +434,7 @@ static int proc_pid_wchan(struct seq_fil
 			&& !lookup_symbol_name(wchan, symname))
 		seq_printf(m, "%s", symname);
 	else
-		seq_putc(m, '0');
+		seq_puts(m, "0\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from mnfhuang@gmail.com are

proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch

