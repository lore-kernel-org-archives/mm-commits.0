From: akpm@linux-foundation.org
Subject: [merged] uml-cow_userc-warning-corrections.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:33 -0700
Message-ID: <201107260753.p6Q7raBQ003247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061Ab1GZHyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalivanov@gmail.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     uml: cow_user.c warning corrections
has been removed from the -mm tree.  Its filename was
     uml-cow_userc-warning-corrections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
gcov-disable-constructors-for-uml.patch

