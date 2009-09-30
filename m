From: akpm@linux-foundation.org
Subject: + sscanf-fix-%s%n.patch added to -mm tree
Date: Wed, 30 Sep 2009 14:00:48 -0700
Message-ID: <200909302100.n8UL0m6j021226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbZI3VA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 17:00:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy753421@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     sscanf(): fix %*s%n
has been added to the -mm tree.  Its filename is
     sscanf-fix-%s%n.patch

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
Subject: sscanf(): fix %*s%n
From: Andy Spencer <andy753421@gmail.com>

When using %*s, sscanf should honor conversion specifiers immediately
following the %*s.  For example, the following code should find the
position of the end of the string "hello".

  int end;
  char buf[] = "hello    world";
  sscanf(buf, "%*s%n", &end);
  printf("%d\n", end);

Ideally, sscanf would advance the fmt and str pointers the same as it
would without the *, but the code for that is rather complicated and is
not included in the patch.

Signed-off-by: Andy Spencer <andy753421@gmail.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~sscanf-fix-%s%n lib/vsprintf.c
--- a/lib/vsprintf.c~sscanf-fix-%s%n
+++ a/lib/vsprintf.c
@@ -1771,7 +1771,7 @@ int vsscanf(const char * buf, const char
 		 * advance both strings to next white space
 		 */
 		if (*fmt == '*') {
-			while (!isspace(*fmt) && *fmt)
+			while (!isspace(*fmt) && *fmt != '%' && *fmt)
 				fmt++;
 			while (!isspace(*str) && *str)
 				str++;
_

Patches currently in -mm which might be from andy753421@gmail.com are

sscanf-fix-%s%n.patch

