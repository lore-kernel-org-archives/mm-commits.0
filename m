From: akpm@linux-foundation.org
Subject: + aio-fix-io_getevents-documentation.patch added to -mm tree
Date: Tue, 14 May 2013 12:39:38 -0700
Message-ID: <519292fa.ubpcf7zxFNmf/CSB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3ENTjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 May 2013 15:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, chrubis@suse.cz, bcrl@kvack.org, jmoyer@redhat.com

Subject: + aio-fix-io_getevents-documentation.patch added to -mm tree
To: jmoyer@redhat.com,bcrl@kvack.org,chrubis@suse.cz,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 14 May 2013 12:39:38 -0700


The patch titled
     Subject: aio: fix io_getevents documentation
has been added to the -mm tree.  Its filename is
     aio-fix-io_getevents-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

aio-fix-io_getevents-documentation.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch

