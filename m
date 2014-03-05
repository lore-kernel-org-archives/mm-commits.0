From: akpm@linux-foundation.org
Subject: +
 tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly.patch added to -mm tree
Date: Wed, 05 Mar 2014 12:19:18 -0800
Message-ID: <531786c6.9ZHU0MgPEayNOoUk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaCEUTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2014 15:19:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, skinsbursky@parallels.com, davidlohr@hp.com, colin.king@canonical.com

Subject: + tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly.patch added to -mm tree
To: colin.king@canonical.com,davidlohr@hp.com,skinsbursky@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 05 Mar 2014 12:19:18 -0800


The patch titled
     Subject: tools/testing/selftests/ipc/msgque.c: handle msgget failure return correctly
has been added to the -mm tree.  Its filename is
     tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: tools/testing/selftests/ipc/msgque.c: handle msgget failure return correctly

A failed msgget causes the test to return an uninitialised value in ret. 
Assign ret to -errno on error exit.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ipc/msgque.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN tools/testing/selftests/ipc/msgque.c~tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly tools/testing/selftests/ipc/msgque.c
--- a/tools/testing/selftests/ipc/msgque.c~tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly
+++ a/tools/testing/selftests/ipc/msgque.c
@@ -201,6 +201,7 @@ int main(int argc, char **argv)
 
 	msgque.msq_id = msgget(msgque.key, IPC_CREAT | IPC_EXCL | 0666);
 	if (msgque.msq_id == -1) {
+		err = -errno;
 		printf("Can't create queue\n");
 		goto err_out;
 	}
_

Patches currently in -mm which might be from colin.king@canonical.com are

tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly.patch
linux-next.patch

