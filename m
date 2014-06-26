From: akpm@linux-foundation.org
Subject: +
 tools-msgque-improve-error-handling-when-not-running-as-root.patch added to -mm tree
Date: Thu, 26 Jun 2014 14:44:14 -0700
Message-ID: <53ac942e.b37wQ0pF30WzVgF9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaFZVoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 17:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuah.kh@samsung.com, colin.king@canonical.com, davidlohr@hp.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: msgque improve error handling when not running as root
has been added to the -mm tree.  Its filename is
     tools-msgque-improve-error-handling-when-not-running-as-root.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-msgque-improve-error-handling-when-not-running-as-root.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-msgque-improve-error-handling-when-not-running-as-root.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: tools: msgque improve error handling when not running as root

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

tools-cpu-hotplug-fix-unexpected-operator-error.patch
tools-memory-hotplug-fix-unexpected-operator-error.patch
tools-msgque-improve-error-handling-when-not-running-as-root.patch

