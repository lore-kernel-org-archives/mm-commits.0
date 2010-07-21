From: akpm@linux-foundation.org
Subject: + lib-vsprintf-useless-strlen-removed.patch added to -mm tree
Date: Wed, 21 Jul 2010 16:51:30 -0700
Message-ID: <201007212351.o6LNpUTe022126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755340Ab0GUXvi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 19:51:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mina86@mina86.com, yi.y.yang@intel.com


The patch titled
     lib: vsprintf: useless strlen() removed
has been added to the -mm tree.  Its filename is
     lib-vsprintf-useless-strlen-removed.patch

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
Subject: lib: vsprintf: useless strlen() removed
From: Michal Nazarewicz <mina86@mina86.com>

The strict_strtoul() and strict_strtoull() functions used strlen() to
check argument's length in a situation where it wasn't strictly necessary

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: "Yi Yang" <yi.y.yang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-useless-strlen-removed lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-useless-strlen-removed
+++ a/lib/vsprintf.c
@@ -146,19 +146,16 @@ int strict_strtoul(const char *cp, unsig
 {
 	char *tail;
 	unsigned long val;
-	size_t len;
 
 	*res = 0;
-	len = strlen(cp);
-	if (len == 0)
+	if (!*cp)
 		return -EINVAL;
 
 	val = simple_strtoul(cp, &tail, base);
 	if (tail == cp)
 		return -EINVAL;
 
-	if ((*tail == '\0') ||
-		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
+	if ((tail[0] == '\0') || (tail[0] == '\n' && tail[1] == '\0')) {
 		*res = val;
 		return 0;
 	}
@@ -220,18 +217,15 @@ int strict_strtoull(const char *cp, unsi
 {
 	char *tail;
 	unsigned long long val;
-	size_t len;
 
 	*res = 0;
-	len = strlen(cp);
-	if (len == 0)
+	if (!*cp)
 		return -EINVAL;
 
 	val = simple_strtoull(cp, &tail, base);
 	if (tail == cp)
 		return -EINVAL;
-	if ((*tail == '\0') ||
-		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
+	if ((tail[0] == '\0') || (tail[0] == '\n' && tail[1] == '\0')) {
 		*res = val;
 		return 0;
 	}
_

Patches currently in -mm which might be from mina86@mina86.com are

lib-vsprintf-useless-strlen-removed.patch

