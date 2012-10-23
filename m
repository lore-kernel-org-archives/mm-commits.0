From: akpm@linux-foundation.org
Subject: + tools-testing-selftests-epoll-test_epollc-fix-build.patch added to -mm tree
Date: Tue, 23 Oct 2012 15:12:14 -0700
Message-ID: <20121023221214.8D8661E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57421 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab2JWWMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 18:12:16 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so547660vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 15:12:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dshadowwolf@gmail.com, palewis@adobe.com


The patch titled
     Subject: tools/testing/selftests/epoll/test_epoll.c: fix build
has been added to the -mm tree.  Its filename is
     tools-testing-selftests-epoll-test_epollc-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+       while (!thread_data->stop)
 		for (index = 0;
 		     !thread_data->stop && (index < thread_data->n_fds);
 		     ++index)
 			if ((write(thread_data->fds[index], &data, 1) < 1) &&
 				(errno != EAGAIN) &&
 				(errno != EWOULDBLOCK)) {
-				write_thread_data->status = errno;
+                               thread_data->status = errno;
 				return;
 			}
 }
_

Patches currently in -mm which might be from dshadowwolf@gmail.com are

uapi-fix-tools-vm-page-typesc.patch
tools-testing-selftests-epoll-test_epollc-fix-build.patch

