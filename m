From: akpm@linux-foundation.org
Subject: [merged]
 tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly.patch removed from -mm tree
Date: Tue, 11 Mar 2014 11:25:12 -0700
Message-ID: <531f5508.Uq1lvhMHbvxO4Pkl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaCKSZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 14:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, skinsbursky@parallels.com, davidlohr@hp.com, colin.king@canonical.com

Subject: [merged] tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly.patch removed from -mm tree
To: colin.king@canonical.com,davidlohr@hp.com,skinsbursky@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 11:25:12 -0700


The patch titled
     Subject: tools/testing/selftests/ipc/msgque.c: handle msgget failure return correctly
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-ipc-msgquec-handle-msgget-failure-return-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

