From: akpm@linux-foundation.org
Subject: [merged] tools-testing-selftests-epoll-test_epollc-fix-build.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:10 -0700
Message-ID: <20121029195011.1F6E35C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:34369 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2J2TuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:12 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so344293wey.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dshadowwolf@gmail.com, palewis@adobe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/epoll/test_epoll.c: fix build
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-epoll-test_epollc-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Hazelton <dshadowwolf@gmail.com>
Subject: tools/testing/selftests/epoll/test_epoll.c: fix build

Latest Linus head run of "make selftests" in the tools directory failed
with references to undefined variables.  Reference was to
'write_thread_data' which is the name of a struct that is being used, not
the variable itself.  Change reference so it points to the variable.

Signed-off-by: Daniel Hazelton <dshadowwolf@gmail.com>
Cc: "Paton J. Lewis" <palewis@adobe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/epoll/test_epoll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/epoll/test_epoll.c~tools-testing-selftests-epoll-test_epollc-fix-build tools/testing/selftests/epoll/test_epoll.c
--- a/tools/testing/selftests/epoll/test_epoll.c~tools-testing-selftests-epoll-test_epollc-fix-build
+++ a/tools/testing/selftests/epoll/test_epoll.c
@@ -162,14 +162,14 @@ void *write_thread_function(void *functi
 	int index;
 	struct write_thread_data *thread_data =
 		(struct write_thread_data *)function_data;
-	while (!write_thread_data->stop)
+	while (!thread_data->stop)
 		for (index = 0;
 		     !thread_data->stop && (index < thread_data->n_fds);
 		     ++index)
 			if ((write(thread_data->fds[index], &data, 1) < 1) &&
 				(errno != EAGAIN) &&
 				(errno != EWOULDBLOCK)) {
-				write_thread_data->status = errno;
+				thread_data->status = errno;
 				return;
 			}
 }
_

Patches currently in -mm which might be from dshadowwolf@gmail.com are


