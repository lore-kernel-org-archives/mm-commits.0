Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B49E784BC
	for <mm-commits@archiver.kernel.org>; Mon,  2 Oct 2023 15:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbjJBPcz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbjJBPcy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2023 11:32:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F232BD
        for <mm-commits@vger.kernel.org>; Mon,  2 Oct 2023 08:32:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEE4C433C8;
        Mon,  2 Oct 2023 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696260768;
        bh=vrltsHPO6KJAUjqWCmoR0Pu4+KK1zO0CA9l6gkx8DVM=;
        h=Date:To:From:Subject:From;
        b=Z8yAVg7gNq+D3ATiCrlGbxxmVL4G/vXyOufBESi6bmtaZsWfz8l6440GqYZwQqTdy
         1HFsvSlV0WqrchjkP+IvnuRiOGUFx1yhydHkdZK4w3HF3jOdN5MYtwpOv1rBwPjt8C
         9+GFyGIPuO0aMk3pAMs8c+9gxPuGzC+6qG1UiR2Q=
Date:   Mon, 02 Oct 2023 08:32:48 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, hughd@google.com,
        adobriyan@gmail.com, swarupkotikalapudi@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-proc-add-proc-pid-statm-output-validation.patch removed from -mm tree
Message-Id: <20231002153248.BAEE4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: proc: add /proc/$(pid)/statm output validation
has been removed from the -mm tree.  Its filename was
     selftests-proc-add-proc-pid-statm-output-validation.patch

This patch was dropped because an updated version will be merged

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
@@ -302,6 +302,37 @@ static int test_proc_pid_smaps_rollup(pi
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
@@ -388,11 +419,8 @@ int main(void)
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


