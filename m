From: akpm@linux-foundation.org
Subject: [merged]
 proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:40:56 -0700
Message-ID: <56f04038.Ai+UutVElIGqaUPX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbcCUT4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnfhuang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc/base: make prompt shell start from new line after executing "cat /proc/$pid/wchan"
has been removed from the -mm tree.  Its filename was
     proc-base-make-prompt-shell-start-from-new-line-after-executing-cat-proc-pid-wchan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kexec-make-a-pair-of-map-unmap-reserved-pages-in-error-path.patch
kexec-do-a-cleanup-for-function-kexec_load.patch

