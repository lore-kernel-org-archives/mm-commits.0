From: akpm@linux-foundation.org
Subject: [merged] seq_file-fix-big-enough-lseek-read.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:34 -0800
Message-ID: <200902061938.n16JcY7h012560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711AbZBFTit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ebiederm@xmission.com, pjt@google.com, stable@kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     seq_file: fix big-enough lseek() + read()
has been removed from the -mm tree.  Its filename was
     seq_file-fix-big-enough-lseek-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: fix big-enough lseek() + read()
From: Alexey Dobriyan <adobriyan@gmail.com>

lseek() further than length of the file will leave stale ->index
(second-to-last during iteration).  Next seq_read() will not notice that
->f_pos is big enough to return 0, but will print last item as if ->f_pos
is pointing to it.

Introduced in commit cb510b8172602a66467f3551b4be1911f5a7c8c2 ("seq_file:
more atomicity in traverse()").

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Turner <pjt@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/seq_file.c~seq_file-fix-big-enough-lseek-read fs/seq_file.c
--- a/fs/seq_file.c~seq_file-fix-big-enough-lseek-read
+++ a/fs/seq_file.c
@@ -110,6 +110,7 @@ static int traverse(struct seq_file *m, 
 		p = m->op->next(m, p, &index);
 	}
 	m->op->stop(m, p);
+	m->index = index;
 	return error;
 
 Eoverflow:
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread.patch
seq_file-properly-cope-with-pread-fix.patch
linux-next.patch
eeepc-should-depend-on-input.patch
tags-fix-config-symbols-generation.patch
sm501-fix-section-mismatches.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
sysctl-min-max-range-check-is-broken.patch
xtensa-fix-compilation-somewhat.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

