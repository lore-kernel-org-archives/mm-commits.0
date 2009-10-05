From: akpm@linux-foundation.org
Subject: [merged] sscanf-fix-%s%n.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:29 -0700
Message-ID: <200910051839.n95IdTUn019184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbZJESkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andy753421@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sscanf(): fix %*s%n
has been removed from the -mm tree.  Its filename was
     sscanf-fix-%s%n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


