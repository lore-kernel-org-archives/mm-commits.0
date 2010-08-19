From: akpm@linux-foundation.org
Subject: + scripts-mod-modpostc-fix-commentary-accordingly-to-last-changes.patch added to -mm tree
Date: Thu, 19 Aug 2010 16:27:48 -0700
Message-ID: <201008192327.o7JNRmcD014729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab0HSX1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 19:27:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy.shevchenko@gmail.com, ext-andriy.shevchenko@nokia.com, rusty@rustcorp.com.au


The patch titled
     scripts/mod/modpost.c: fix commentary accordingly to last changes
has been added to the -mm tree.  Its filename is
     scripts-mod-modpostc-fix-commentary-accordingly-to-last-changes.patch

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
Subject: scripts/mod/modpost.c: fix commentary accordingly to last changes
From: Andy Shevchenko <andy.shevchenko@gmail.com>

The commits 37ed19d5cce ("scripts/mod/modpost.c: fix memory leak") and
5003bab82d ("fix "scripts/mod/modpost.c: fix memory leak"") introduced new
behaviour of sec2annotation() method.  However, the commentary inside the
method was left as before.  Let's fix it accordingly.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/mod/modpost.c~scripts-mod-modpostc-fix-commentary-accordingly-to-last-changes scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~scripts-mod-modpostc-fix-commentary-accordingly-to-last-changes
+++ a/scripts/mod/modpost.c
@@ -1208,6 +1208,9 @@ static Elf_Sym *find_elf_symbol2(struct 
  * .cpuinit.data => __cpudata
  * .memexitconst => __memconst
  * etc.
+ *
+ * The memory of returned value has been allocated on a heap. The user of this
+ * method should free it after usage.
 */
 static char *sec2annotation(const char *s)
 {
@@ -1230,7 +1233,7 @@ static char *sec2annotation(const char *
 			strcat(p, "data ");
 		else
 			strcat(p, " ");
-		return r; /* we leak her but we do not care */
+		return r;
 	} else {
 		return strdup("");
 	}
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

linux-next.patch
scripts-mod-modpostc-fix-commentary-accordingly-to-last-changes.patch
mmc-make-dev_to_mmc_card-macro-public.patch

