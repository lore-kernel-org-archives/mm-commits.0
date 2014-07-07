From: akpm@linux-foundation.org
Subject: [merged]
 tools-msgque-improve-error-handling-when-not-running-as-root.patch removed
 from -mm tree
Date: Mon, 07 Jul 2014 11:11:34 -0700
Message-ID: <53bae2d6./G+BUubnXJz0jXCS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:52476 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaGGSLf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:35 -0400
Received: by mail-ie0-f202.google.com with SMTP id rd18so805850iec.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuah.kh@samsung.com, colin.king@canonical.com, davidlohr@hp.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/ipc/msgque.c: improve error handling when not running as root
has been removed from the -mm tree.  Its filename was
     tools-msgque-improve-error-handling-when-not-running-as-root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: tools/testing/selftests/ipc/msgque.c: improve error handling when not running as root

The test fails in the middle when it is not run as root while accessing
/proc/sys/kernel/msg_next_id.  Changed it to check for root at the
beginning of the test and exit if not root.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ipc/msgque.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN tools/testing/selftests/ipc/msgque.c~tools-msgque-improve-error-handling-when-not-running-as-root tools/testing/selftests/ipc/msgque.c
--- a/tools/testing/selftests/ipc/msgque.c~tools-msgque-improve-error-handling-when-not-running-as-root
+++ a/tools/testing/selftests/ipc/msgque.c
@@ -193,6 +193,11 @@ int main(int argc, char **argv)
 	int msg, pid, err;
 	struct msgque_data msgque;
 
+	if (getuid() != 0) {
+		printf("Please run the test as root - Exiting.\n");
+		exit(1);
+	}
+
 	msgque.key = ftok(argv[0], 822155650);
 	if (msgque.key == -1) {
 		printf("Can't make key\n");
_

Patches currently in -mm which might be from shuah.kh@samsung.com are


