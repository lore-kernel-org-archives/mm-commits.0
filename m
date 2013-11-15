From: akpm@linux-foundation.org
Subject: [merged] vsprintf-ignore-%n-again.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:08:59 -0800
Message-ID: <52867f5b.r21d/fxDqOiKojc3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3KOUJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, joe@perches.com, davem@davemloft.net, keescook@chromium.org

Subject: [merged] vsprintf-ignore-%n-again.patch removed from -mm tree
To: keescook@chromium.org,davem@davemloft.net,joe@perches.com,penguin-kernel@I-love.SAKURA.ne.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:59 -0800


The patch titled
     Subject: vsprintf: ignore %n again
has been removed from the -mm tree.  Its filename was
     vsprintf-ignore-%n-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: vsprintf: ignore %n again

This ignores %n in printf again, as was originally documented. 
Implementing %n poses a greater security risk than utility, so it should
stay ignored.  To help anyone attempting to use %n, a warning will be
emitted if it is encountered.

Based on an earlier patch by Joe Perches.

Because %n was designed to write to pointers on the stack, it has been
frequently used as an attack vector when bugs are found that leak
user-controlled strings into functions that ultimately process format
strings.  While this class of bug can still be turned into an information
leak, removing %n eliminates the common method of elevating such a bug
into an arbitrary kernel memory writing primitive, significantly reducing
the danger of this class of bug.

For seq_file users that need to know the length of a written string for
padding, please see seq_setwidth() and seq_pad() instead.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-ignore-%n-again lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-ignore-%n-again
+++ a/lib/vsprintf.c
@@ -1712,18 +1712,16 @@ int vsnprintf(char *buf, size_t size, co
 			break;
 
 		case FORMAT_TYPE_NRCHARS: {
-			u8 qualifier = spec.qualifier;
+			/*
+			 * Since %n poses a greater security risk than
+			 * utility, ignore %n and skip its argument.
+			 */
+			void *skip_arg;
 
-			if (qualifier == 'l') {
-				long *ip = va_arg(args, long *);
-				*ip = (str - buf);
-			} else if (_tolower(qualifier) == 'z') {
-				size_t *ip = va_arg(args, size_t *);
-				*ip = (str - buf);
-			} else {
-				int *ip = va_arg(args, int *);
-				*ip = (str - buf);
-			}
+			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
+					old_fmt);
+
+			skip_arg = va_arg(args, void *);
 			break;
 		}
 
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

