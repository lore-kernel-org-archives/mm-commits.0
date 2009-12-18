From: akpm@linux-foundation.org
Subject: + copy_signal-cleanup-clean-tty_audit_fork.patch added to -mm tree
Date: Fri, 18 Dec 2009 14:59:45 -0800
Message-ID: <200912182259.nBIMxjrY023601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754650AbZLRXAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 18:00:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vfalico@redhat.com, oleg@redhat.com, roland@redhat.com


The patch titled
     copy_signal() cleanup: clean tty_audit_fork()
has been added to the -mm tree.  Its filename is
     copy_signal-cleanup-clean-tty_audit_fork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: copy_signal() cleanup: clean tty_audit_fork()
From: Veaceslav Falico <vfalico@redhat.com>

Remove unneeded initialization in tty_audit_fork().  It is called only via
copy_signal() and is useless after the kmem_cache_zalloc() was used.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_audit.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/tty_audit.c~copy_signal-cleanup-clean-tty_audit_fork drivers/char/tty_audit.c
--- a/drivers/char/tty_audit.c~copy_signal-cleanup-clean-tty_audit_fork
+++ a/drivers/char/tty_audit.c
@@ -148,7 +148,6 @@ void tty_audit_fork(struct signal_struct
 	spin_lock_irq(&current->sighand->siglock);
 	sig->audit_tty = current->signal->audit_tty;
 	spin_unlock_irq(&current->sighand->siglock);
-	sig->tty_audit_buf = NULL;
 }
 
 /**
_

Patches currently in -mm which might be from vfalico@redhat.com are

copy_signal-cleanup-use-zalloc-and-remove-initializations.patch
copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct.patch
copy_signal-cleanup-clean-thread_group_cputime_init.patch
copy_signal-cleanup-clean-tty_audit_fork.patch

