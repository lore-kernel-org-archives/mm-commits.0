From: akpm@linux-foundation.org
Subject: [merged] sysctl-refactor-sysctl-string-writing-logic.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:35:42 -0700
Message-ID: <53960c8e.AwxvhkdDZ9lgh1Oq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaFITfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, keescook@chromium.org

Subject: [merged] sysctl-refactor-sysctl-string-writing-logic.patch removed from -mm tree
To: keescook@chromium.org,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:42 -0700


The patch titled
     Subject: sysctl: refactor sysctl string writing logic
has been removed from the -mm tree.  Its filename was
     sysctl-refactor-sysctl-string-writing-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1717,21 +1717,18 @@ static int _proc_do_string(char *data, i
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

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

