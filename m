From: akpm@linux-foundation.org
Subject: + uml-cow_userc-warning-corrections.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:55:07 -0700
Message-ID: <201107222255.p6MMt7Sg020022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab1GVWzP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:55:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vitalivanov@gmail.com, richard@nod.at


The patch titled
     uml: cow_user.c warning corrections
has been added to the -mm tree.  Its filename is
     uml-cow_userc-warning-corrections.patch

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
Subject: uml: cow_user.c warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>

arch/um/drivers/cow_user.c: In function `absolutize':
arch/um/drivers/cow_user.c:189:7: warning: ignoring return value of `chdir', declared with attribute warn_unused_result

[richard@nod.at: happens only with -D_FORTIFY_SOURCE=2]
Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/cow_user.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/um/drivers/cow_user.c~uml-cow_userc-warning-corrections arch/um/drivers/cow_user.c
--- a/arch/um/drivers/cow_user.c~uml-cow_userc-warning-corrections
+++ a/arch/um/drivers/cow_user.c
@@ -186,7 +186,11 @@ static int absolutize(char *to, int size
 		strcat(to, "/");
 		strcat(to, from);
 	}
-	chdir(save_cwd);
+	if (chdir(save_cwd)) {
+		cow_printf("absolutize : Can't cd to '%s' - "
+			   "errno = %d\n", save_cwd, errno);
+		return -1;
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from vitalivanov@gmail.com are

linux-next.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
uml-drivers-net_userc-memory-leak-fix.patch
uml-cow_userc-warning-corrections.patch
uml-helperc-warning-corrections.patch
uml-drivers-slip_userc-memory-leak-fix.patch
uml-free-resources.patch
gcov-disable-constructors-for-uml.patch

