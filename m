From: akpm@linux-foundation.org
Subject: + sysctl-refactor-sysctl-string-writing-logic.patch added to -mm
 tree
Date: Mon, 05 May 2014 15:00:26 -0700
Message-ID: <536809fa.LOAmGWWDydnK8HFp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbaEEWA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 18:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, keescook@chromium.org

Subject: + sysctl-refactor-sysctl-string-writing-logic.patch added to -mm tree
To: keescook@chromium.org,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 15:00:26 -0700


The patch titled
     Subject: sysctl: refactor sysctl string writing logic
has been added to the -mm tree.  Its filename is
     sysctl-refactor-sysctl-string-writing-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-refactor-sysctl-string-writing-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-refactor-sysctl-string-writing-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: sysctl: refactor sysctl string writing logic

Consolidate buffer length checking with new-line/end-of-line checking. 
Additionally, instead of reading user memory twice, just do the assignment
during the loop.

This change doesn't affect the potential races here.  It was already
possible to read a sysctl that was in the middle of a write.  In both
cases, the string will always be NULL terminated.  The pre-existing race
remains a problem to be solved.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/sysctl.c~sysctl-refactor-sysctl-string-writing-logic kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-refactor-sysctl-string-writing-logic
+++ a/kernel/sysctl.c
@@ -1712,21 +1712,18 @@ static int _proc_do_string(char *data, i
 	}
 
 	if (write) {
+		/* Start writing from beginning of buffer. */
 		len = 0;
+		*ppos += *lenp;
 		p = buffer;
-		while (len < *lenp) {
+		while ((p - buffer) < *lenp && len < maxlen - 1) {
 			if (get_user(c, p++))
 				return -EFAULT;
 			if (c == 0 || c == '\n')
 				break;
-			len++;
+			data[len++] = c;
 		}
-		if (len >= maxlen)
-			len = maxlen-1;
-		if(copy_from_user(data, buffer, len))
-			return -EFAULT;
 		data[len] = 0;
-		*ppos += *lenp;
 	} else {
 		len = strlen(data);
 		if (len > maxlen)
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-vsprintf-add-%pt-format-specifier.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
ptrace-fix-fork-event-messages-across-pid-namespaces.patch
sysctl-clean-up-char-buffer-arguments.patch
sysctl-refactor-sysctl-string-writing-logic.patch
sysctl-allow-for-strict-write-position-handling.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
tools-testing-selftests-sysctl-validate-sysctl_writes_strict.patch
tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix.patch
linux-next.patch

