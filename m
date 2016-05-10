From: akpm@linux-foundation.org
Subject: [merged]
 revert-proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch removed from -mm tree
Date: Tue, 10 May 2016 10:30:46 -0700
Message-ID: <57321ac6.1TIgmnVLmdk8q95Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbcEJRat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 13:30:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: plaguedbypenguins@gmail.com, mnfhuang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "proc/base: make prompt shell start from new line after executing "cat /proc/$pid/wchan""
has been removed from the -mm tree.  Its filename was
     revert-proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


