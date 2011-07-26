From: akpm@linux-foundation.org
Subject: [merged] uml-helperc-warning-corrections.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:36 -0700
Message-ID: <201107260753.p6Q7rdBE003250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555Ab1GZHye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalivanov@gmail.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     uml: helper.c warning corrections
has been removed from the -mm tree.  Its filename was
     uml-helperc-warning-corrections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: helper.c warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>

arch/um/os-Linux/helper.c: In function `helper_child':
arch/um/os-Linux/helper.c:38:7: warning: ignoring return value of `write', declared with attribute warn_unused_result

[richard@nod.at: happens only with -D_FORTIFY_SOURCE=2]
Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/helper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/os-Linux/helper.c~uml-helperc-warning-corrections arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-helperc-warning-corrections
+++ a/arch/um/os-Linux/helper.c
@@ -28,14 +28,14 @@ static int helper_child(void *arg)
 {
 	struct helper_data *data = arg;
 	char **argv = data->argv;
-	int err;
+	int err, ret;
 
 	if (data->pre_exec != NULL)
 		(*data->pre_exec)(data->pre_data);
 	err = execvp_noalloc(data->buf, argv[0], argv);
 
 	/* If the exec succeeds, we don't get here */
-	write(data->fd, &err, sizeof(err));
+	CATCH_EINTR(ret = write(data->fd, &err, sizeof(err)));
 
 	return 0;
 }
_

Patches currently in -mm which might be from vitalivanov@gmail.com are

origin.patch
gcov-disable-constructors-for-uml.patch

