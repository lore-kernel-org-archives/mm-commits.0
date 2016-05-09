From: akpm@linux-foundation.org
Subject: [patch 1/3] Revert "proc/base: make prompt shell start from new
 line after executing "cat /proc/$pid/wchan""
Date: Mon, 09 May 2016 16:28:46 -0700
Message-ID: <57311d2e.P2JyPhRihF17Ouao%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbcEIX2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 19:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, plaguedbypenguins@gmail.com, mnfhuang@gmail.com

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
