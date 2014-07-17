From: akpm@linux-foundation.org
Subject: + proc-more-const-char-pointers.patch added to -mm tree
Date: Thu, 17 Jul 2014 15:54:31 -0700
Message-ID: <53c85427.7l/cy4nhJ/6AXLfF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:52168 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbaGQWyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:33 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so438843qap.0
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: more "const char *" pointers
has been added to the -mm tree.  Its filename is
     proc-more-const-char-pointers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-more-const-char-pointers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-more-const-char-pointers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: more "const char *" pointers

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-more-const-char-pointers fs/proc/base.c
--- a/fs/proc/base.c~proc-more-const-char-pointers
+++ a/fs/proc/base.c
@@ -105,7 +105,7 @@
  */
 
 struct pid_entry {
-	char *name;
+	const char *name;
 	int len;
 	umode_t mode;
 	const struct inode_operations *iop;
@@ -418,8 +418,8 @@ static int proc_oom_score(struct task_st
 }
 
 struct limit_names {
-	char *name;
-	char *unit;
+	const char *name;
+	const char *unit;
 };
 
 static const struct limit_names lnames[RLIM_NLIMITS] = {
@@ -2056,7 +2056,7 @@ static int show_timer(struct seq_file *m
 	struct k_itimer *timer;
 	struct timers_private *tp = m->private;
 	int notify;
-	static char *nstr[] = {
+	static const char * const nstr[] = {
 		[SIGEV_SIGNAL] = "signal",
 		[SIGEV_NONE] = "none",
 		[SIGEV_THREAD] = "thread",
_

Patches currently in -mm which might be from adobriyan@gmail.com are

lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
proc-add-and-remove-proc-entry-create-checks.patch
proc-faster-proc-pid-lookup.patch
proc-make-proc_subdir_lock-static.patch
proc-remove-proc_tty_ldisc-variable.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
proc-more-const-char-pointers.patch
proc-convert-proc-pid-auxv-to-seq_file-interface.patch
proc-convert-proc-pid-limits-to-seq_file-interface.patch
proc-convert-proc-pid-syscall-to-seq_file-interface.patch
proc-fix-page_size-limit-of-proc-pid-cmdline.patch
proc-convert-proc-pid-wchan-to-seq_file-interface.patch
proc-convert-proc-pid-schedstat-to-seq_file-interface.patch
proc-convert-proc-pid-oom_score-to-seq_file-interface.patch
proc-convert-proc-pid-io-to-seq_file-interface.patch
proc-convert-proc-pid-hardwall-to-seq_file-interface.patch
proc-remove-inf-macro.patch

