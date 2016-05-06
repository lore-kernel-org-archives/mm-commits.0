From: akpm@linux-foundation.org
Subject: +
 revert-proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch added to -mm tree
Date: Fri, 06 May 2016 15:18:59 -0700
Message-ID: <572d1853.RJtIdqYCf0RVeqwp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbcEFWTA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 18:19:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: plaguedbypenguins@gmail.com, mnfhuang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "proc/base: make prompt shell start from new line after executing "cat /proc/$pid/wchan""
has been added to the -mm tree.  Its filename is
     revert-proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robin Humble <plaguedbypenguins@gmail.com>
Subject: Revert "proc/base: make prompt shell start from new line after executing "cat /proc/$pid/wchan""

This reverts the 4.6-rc1 commit 7e2bc81da333f0d4ca68 ("proc/base: make
prompt shell start from new line after executing "cat /proc/$pid/wchan").

Please revert because it breaks /proc/$PID/whcan formatting in ps and
top.

Revert also because the patch is inconsistent - it adds a newline at the
end of only the '0' wchan, and does not add a newline when
/proc/$PID/wchan contains a symbol name.

eg.
$ ps -eo pid,stat,wchan,comm
PID STAT WCHAN  COMMAND
...
1189 S    -      dbus-launch
1190 Ssl  0
dbus-daemon
1198 Sl   0
lightdm
1299 Ss   ep_pol systemd
1301 S    -      (sd-pam)
1304 Ss   wait   sh

Link: http://lkml.kernel.org/r/20160506151853.GA16537@trinity.cita.utoronto.ca
Signed-off-by: Robin Humble <plaguedbypenguins@gmail.com>
Cc: Minfei Huang <mnfhuang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~revert-proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan fs/proc/base.c
--- a/fs/proc/base.c~revert-proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan
+++ a/fs/proc/base.c
@@ -434,7 +434,7 @@ static int proc_pid_wchan(struct seq_fil
 			&& !lookup_symbol_name(wchan, symname))
 		seq_printf(m, "%s", symname);
 	else
-		seq_puts(m, "0\n");
+		seq_putc(m, '0');
 
 	return 0;
 }
_

Patches currently in -mm which might be from plaguedbypenguins@gmail.com are

revert-proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch

