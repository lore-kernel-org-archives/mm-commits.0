From: akpm@linux-foundation.org
Subject: + aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests.patch added to -mm tree
Date: Mon, 03 Dec 2007 11:44:52 -0800
Message-ID: <200712031944.lB3Jiq3m014886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbXLCTq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 14:46:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com, jdike@addtoit.com, miklos@szeredi.hu, zach.brown@oracle.com


The patch titled
     aio: only account I/O wait time in read_events if there are active requests
has been added to the -mm tree.  Its filename is
     aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aio: only account I/O wait time in read_events if there are active requests
From: Jeff Moyer <jmoyer@redhat.com>

On 2.6.24, top started showing 100% iowait on one CPU when a UML instance was
running (but completely idle).  The UML code sits in io_getevents waiting for
an event to be submitted and completed.

Fix this by checking ctx->reqs_active before scheduling to determine whether
or not we are waiting for I/O.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests fs/aio.c
--- a/fs/aio.c~aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests
+++ a/fs/aio.c
@@ -1161,7 +1161,12 @@ retry:
 			ret = 0;
 			if (to.timed_out)	/* Only check after read evt */
 				break;
-			io_schedule();
+			/* Try to only show up in io wait if there are ops
+			 *  in flight */
+			if (ctx->reqs_active)
+				io_schedule();
+			else
+				schedule();
 			if (signal_pending(tsk)) {
 				ret = -EINTR;
 				break;
_

Patches currently in -mm which might be from jmoyer@redhat.com are

aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests.patch
