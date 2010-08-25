From: akpm@linux-foundation.org
Subject: + core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch added to -mm tree
Date: Wed, 25 Aug 2010 12:23:29 -0700
Message-ID: <201008251923.o7PJNTIt011222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474Ab0HYTXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 15:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com, akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com, oleg@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2
has been added to the -mm tree.  Its filename is
     core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch

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
Subject: core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2
From: Xiaotian Feng <dfeng@redhat.com>

Changes since v4:
cn_printf needs to take trailing '\0' into account. Then we don't need to
copy extra '\0' while parsing pat_ptr.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2 fs/exec.c
--- a/fs/exec.c~core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2
+++ a/fs/exec.c
@@ -1477,7 +1477,7 @@ static int cn_printf(struct core_name *c
 	need = vsnprintf(NULL, 0, fmt, arg);
 	va_end(arg);
 
-	if (likely(need < cn->size - cn->used))
+	if (likely(need < cn->size - cn->used -1))
 		goto out_printf;
 
 	ret = expand_corename(cn);
@@ -1519,14 +1519,13 @@ static int format_corename(struct core_n
 	   space */
 	while (*pat_ptr) {
 		if (*pat_ptr != '%') {
+			if (*pat_ptr == 0)
+				goto out;
 			err = cn_printf(cn, "%c", *pat_ptr++);
 		} else {
 			switch (*++pat_ptr) {
 			/* single % at the end, drop that */
 			case 0:
-				err = cn_printf(cn, "%c", '\0');
-				if (err)
-					break;
 				goto out;
 			/* Double percent, output one percent */
 			case '%':
_

Patches currently in -mm which might be from dfeng@redhat.com are

linux-next.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch

