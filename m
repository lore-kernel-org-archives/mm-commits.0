From: akpm@linux-foundation.org
Subject: [obsolete] epoll-support-for-disabling-items-and-a-self-test-app-fix.patch removed from -mm tree
Date: Mon, 15 Apr 2013 15:08:19 -0700
Message-ID: <20130415220820.0CCF731C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45764 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3DOWIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 18:08:21 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so192054qab.3
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 15:08:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, dshadowwolf@gmail.com, palewis@adobe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: stop comparing pointers with 0 in self-test app
has been removed from the -mm tree.  Its filename was
     epoll-support-for-disabling-items-and-a-self-test-app-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: epoll: stop comparing pointers with 0 in self-test app

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Reviewed-by: Daniel Hazelton <dshadowwolf@gmail.com>
Cc: "Paton J. Lewis" <palewis@adobe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/epoll/test_epoll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/epoll/test_epoll.c~epoll-support-for-disabling-items-and-a-self-test-app-fix tools/testing/selftests/epoll/test_epoll.c
--- a/tools/testing/selftests/epoll/test_epoll.c~epoll-support-for-disabling-items-and-a-self-test-app-fix
+++ a/tools/testing/selftests/epoll/test_epoll.c
@@ -199,8 +199,8 @@ int main(int argc, char **argv)
 
 	epoll_items = malloc(n_epoll_items * sizeof(struct epoll_item_private));
 
-	if (epoll_set < 0 || epoll_items == 0 || write_thread_data.fds == 0 ||
-		read_thread_data == 0 || read_threads == 0)
+	if (epoll_set < 0 || !epoll_items || write_thread_data.fds == NULL ||
+		!read_thread_data || !read_threads)
 		goto error;
 
 	if (sysconf(_SC_NPROCESSORS_ONLN) < 2) {
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

linux-next.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch

