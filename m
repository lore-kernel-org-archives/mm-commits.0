From: akpm@linux-foundation.org
Subject: + epoll-support-for-disabling-items-and-a-self-test-app-fix.patch added to -mm tree
Date: Tue, 08 Jan 2013 16:17:41 -0800
Message-ID: <20130109001742.0AB61200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:35505 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3AIARo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 19:17:44 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so81505lbo.2
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 16:17:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sasha.levin@oracle.com, dshadowwolf@gmail.com, palewis@adobe.com


The patch titled
     Subject: epoll: stop comparing pointers with 0 in self-test app
has been added to the -mm tree.  Its filename is
     epoll-support-for-disabling-items-and-a-self-test-app-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-huge_memory-use-new-hashtable-implementation.patch
mm-memory_hotplug-no-need-to-check-res-twice-in-add_memory.patch
epoll-support-for-disabling-items-and-a-self-test-app-fix.patch

