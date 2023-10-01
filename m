Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232F1E78488
	for <mm-commits@archiver.kernel.org>; Sun,  1 Oct 2023 19:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbjJATho (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Oct 2023 15:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbjJAThn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Oct 2023 15:37:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AA9BF
        for <mm-commits@vger.kernel.org>; Sun,  1 Oct 2023 12:37:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B716AC433C7;
        Sun,  1 Oct 2023 19:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696189060;
        bh=6EPjLlb4OBJAhOkG8auvTmx/3zuxdSU3NHc+usR5alI=;
        h=Date:To:From:Subject:From;
        b=EeGWscLAN4xNFZRaAVmr4erKOj3XAGX/drKwIQSgTTIjfWydQuTsNplnOOPpPfss4
         5XeZXjO9KZYnYWYR5bn/0A6PXU6+yC3Px4c/ZX5pqUkAZl+Jf+lAgEFxl8vRYELAJw
         iGvqNrPNiX7QdJOUWlibDU32YvIYXGhmb+xBT6J0=
Date:   Sun, 01 Oct 2023 12:37:40 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, hughd@google.com,
        adobriyan@gmail.com, swarupkotikalapudi@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-add-proc-pid-statm-output-validation.patch added to mm-nonmm-unstable branch
Message-Id: <20231001193740.B716AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: proc: add /proc/$(pid)/statm output validation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-proc-add-proc-pid-statm-output-validation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-add-proc-pid-statm-output-validation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Subject: selftests: proc: add /proc/$(pid)/statm output validation
Date: Sun, 1 Oct 2023 22:38:16 +0530

Add /proc/${pid}/statm validation

/proc/$(pid)/statm output is expected to be:
 "0 0 0 * 0 0 0\n"
Here * can be any value

Read output of /proc/$(pid)/statm
and compare length of output is
equal or greater than expected output

Link: https://lkml.kernel.org/r/20231001170816.28241-1-swarupkotikalapudi@gmail.com
Signed-off-by: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |   38 ++++++++++++++---
 1 file changed, 33 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~selftests-proc-add-proc-pid-statm-output-validation
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -303,6 +303,37 @@ static int test_proc_pid_smaps_rollup(pi
 	}
 }
 
+static const char g_statm[] = "0 0 0 * 0 0 0\n";
+
+static int test_proc_pid_statm(pid_t pid)
+{
+	char buf[4096];
+
+	snprintf(buf, sizeof(buf), "/proc/%u/statm", pid);
+
+	int fd = open(buf, O_RDONLY);
+
+	if (fd == -1) {
+		if (errno == ENOENT) {
+			/*
+			 * /proc/${pid}/statm is under CONFIG_PROC_PAGE_MONITOR,
+			 * it doesn't necessarily exist.
+			 */
+			return EXIT_SUCCESS;
+		}
+		perror("open /proc/${pid}/statm");
+		return EXIT_FAILURE;
+	} else {
+		ssize_t rv = read(fd, buf, sizeof(buf));
+
+		close(fd);
+		size_t len = strlen(g_statm);
+
+		assert(rv >= len);
+		return EXIT_SUCCESS;
+	}
+}
+
 int main(void)
 {
 	int rv = EXIT_SUCCESS;
@@ -389,11 +420,8 @@ int main(void)
 		if (rv == EXIT_SUCCESS) {
 			rv = test_proc_pid_smaps_rollup(pid);
 		}
-		/*
-		 * TODO test /proc/${pid}/statm, task_statm()
-		 * ->start_code, ->end_code aren't updated by munmap().
-		 * Output can be "0 0 0 2 0 0 0\n" where "2" can be anything.
-		 */
+		if (rv == EXIT_SUCCESS)
+			rv = test_proc_pid_statm(pid);
 
 		/* Cut the rope. */
 		int wstatus;
_

Patches currently in -mm which might be from swarupkotikalapudi@gmail.com are

selftests-proc-add-proc-pid-statm-output-validation.patch

