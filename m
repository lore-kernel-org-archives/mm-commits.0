From: akpm@linux-foundation.org
Subject: + coredump-format_corename-dont-append-%pid-if-multi-threaded.patch added to -mm tree
Date: Mon, 28 Jul 2008 21:07:53 -0700
Message-ID: <200807290407.m6T47rRG013315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880AbYG2EJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 00:09:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, mtk.manpages@googlemail.com, roland@redhat.com


The patch titled
     coredump: format_corename: don't append .%pid if multi-threaded
has been added to the -mm tree.  Its filename is
     coredump-format_corename-dont-append-%pid-if-multi-threaded.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: format_corename: don't append .%pid if multi-threaded
From: Oleg Nesterov <oleg@tv-sign.ru>

If the coredumping is multi-threaded, format_corename() appends .%pid to
the corename.  This was needed before the proper multi-thread core dump
support, now all the threads in the mm go into a single unified core file.

Remove this special case, it is not even documented and we have "%p"
and core_uses_pid.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~coredump-format_corename-dont-append-%pid-if-multi-threaded fs/exec.c
--- a/fs/exec.c~coredump-format_corename-dont-append-%pid-if-multi-threaded
+++ a/fs/exec.c
@@ -1391,7 +1391,7 @@ EXPORT_SYMBOL(set_binfmt);
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static int format_corename(char *corename, int nr_threads, long signr)
+static int format_corename(char *corename, long signr)
 {
 	const char *pat_ptr = core_pattern;
 	int ispipe = (*pat_ptr == '|');
@@ -1498,8 +1498,7 @@ static int format_corename(char *corenam
 	 * If core_pattern does not include a %p (as is the default)
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
-	if (!ispipe && !pid_in_pattern
-	    && (core_uses_pid || nr_threads)) {
+	if (!ispipe && !pid_in_pattern && core_uses_pid) {
 		rc = snprintf(out_ptr, out_end - out_ptr,
 			      ".%d", task_tgid_vnr(current));
 		if (rc > out_end - out_ptr)
@@ -1762,7 +1761,7 @@ int do_coredump(long signr, int exit_cod
 	 * uses lock_kernel()
 	 */
  	lock_kernel();
-	ispipe = format_corename(corename, retval, signr);
+	ispipe = format_corename(corename, signr);
 	unlock_kernel();
 	/*
 	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch

