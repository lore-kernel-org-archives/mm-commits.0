From: akpm@linux-foundation.org
Subject: [merged]
 change-current_is_single_threaded-to-use-for_each_thread.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:12:46 -0800
Message-ID: <5640fe3e.0DY2Qjl/RRL35lry%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbbKIUMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:12:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/is_single_threaded.c: change current_is_single_threaded() to use for_each_thread()
has been removed from the -mm tree.  Its filename was
     change-current_is_single_threaded-to-use-for_each_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: lib/is_single_threaded.c: change current_is_single_threaded() to use for_each_thread()

Change current_is_single_threaded() to use for_each_thread() rather than
deprecated while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/is_single_threaded.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN lib/is_single_threaded.c~change-current_is_single_threaded-to-use-for_each_thread lib/is_single_threaded.c
--- a/lib/is_single_threaded.c~change-current_is_single_threaded-to-use-for_each_thread
+++ a/lib/is_single_threaded.c
@@ -36,8 +36,7 @@ bool current_is_single_threaded(void)
 		if (unlikely(p == task->group_leader))
 			continue;
 
-		t = p;
-		do {
+		for_each_thread(p, t) {
 			if (unlikely(t->mm == mm))
 				goto found;
 			if (likely(t->mm))
@@ -48,7 +47,7 @@ bool current_is_single_threaded(void)
 			 * forked before exiting.
 			 */
 			smp_rmb();
-		} while_each_thread(p, t);
+		}
 	}
 	ret = true;
 found:
_

Patches currently in -mm which might be from oleg@redhat.com are


