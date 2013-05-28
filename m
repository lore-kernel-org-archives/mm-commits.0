From: akpm@linux-foundation.org
Subject: [merged] aio-fix-io_getevents-documentation.patch removed from
 -mm tree
Date: Tue, 28 May 2013 12:37:03 -0700
Message-ID: <51a5075f.3oj/R2Mbo95vrp0T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3E1ThE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, chrubis@suse.cz, bcrl@kvack.org, jmoyer@redhat.com

Subject: [merged] aio-fix-io_getevents-documentation.patch removed from -mm tree
To: jmoyer@redhat.com,bcrl@kvack.org,chrubis@suse.cz,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:03 -0700


The patch titled
     Subject: aio: fix io_getevents documentation
has been removed from the -mm tree.  Its filename was
     aio-fix-io_getevents-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Moyer <jmoyer@redhat.com>
Subject: aio: fix io_getevents documentation

In reviewing man pages, I noticed that io_getevents is documented to
update the timeout that gets passed into the library call.  This doesn't
happen in kernel space or in the library (even though it's documented to
do so in both places).  Unless there is objection, I'd like to fix the
comments/docs to match the code (I will also update the man page upon
consensus).

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Acked-by: Cyril Hrubis <chrubis@suse.cz>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/aio.c~aio-fix-io_getevents-documentation fs/aio.c
--- a/fs/aio.c~aio-fix-io_getevents-documentation
+++ a/fs/aio.c
@@ -1299,8 +1299,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
  *	< min_nr if the timeout specified by timeout has elapsed
  *	before sufficient events are available, where timeout == NULL
  *	specifies an infinite timeout. Note that the timeout pointed to by
- *	timeout is relative and will be updated if not NULL and the
- *	operation blocks. Will fail with -ENOSYS if not implemented.
+ *	timeout is relative.  Will fail with -ENOSYS if not implemented.
  */
 SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 		long, min_nr,
_

Patches currently in -mm which might be from jmoyer@redhat.com are


