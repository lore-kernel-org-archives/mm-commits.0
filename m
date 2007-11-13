From: akpm@linux-foundation.org
Subject: + sysctl-check-length-at-deprecated_sysctl_warning.patch added to -mm tree
Date: Mon, 12 Nov 2007 17:44:23 -0800
Message-ID: <200711130144.lAD1iNjk020467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757031AbXKMBo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 20:44:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@i-love.sakura.ne.jp, ebiederm@xmission.compenguin-kernel@i-love.sakura.ne.jp


The patch titled
     Subject: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
has been added to the -mm tree.  Its filename is
     sysctl-check-length-at-deprecated_sysctl_warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Subject: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

Original patch assumed args->nlen < CTL_MAXNAME, but it can be false.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/sysctl.c~sysctl-check-length-at-deprecated_sysctl_warning kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-check-length-at-deprecated_sysctl_warning
+++ a/kernel/sysctl.c
@@ -2609,6 +2609,10 @@ static int deprecated_sysctl_warning(str
 	int name[CTL_MAXNAME];
 	int i;
 
+	/* Check args->nlen. */
+	if (args->nlen < 0 || args->nlen > CTL_MAXNAME)
+		return -EFAULT;
+
 	/* Read in the sysctl name for better debug message logging */
 	for (i = 0; i < args->nlen; i++)
 		if (get_user(name[i], args->name + i))
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

sysctl-check-length-at-deprecated_sysctl_warning.patch
