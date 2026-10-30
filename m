Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793399178;
	b=oWiAfGTneA3RXCC+YPF3Fch7u5vaw3Lzv0lhq1mzaXdJ0BCW942EwOqxH/+MY4styXK+
	 qtug0t0ItlbG20mVTWQPrW9gU2HnhzTqTUwpAySUPYIYZ5zgocm2gwlC0QBAVU4p4CfO1
	 3R8tWzQhfb/GVNHYKkc0m5k0s009HsAys67IbJYpKBLjHCFmRY31TDWidHeqiloQ4rZ8f
	 HCCmm54zhF6WabTjaiVXGIlC0t3Z3SYS9ivWX00zsJOkv9sK0oeBLm1qeT/Ds28YnSTbY
	 GC5Vv+C7oj4dLi6lk2ns4KZQ6AKsZaS9dgETGp44VVRG2nKpZychflSZQs8pyW5cFew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793399178;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NyCnztSFRVJPPe2xugAIV9P48Ypt2f5tkeiLr+tmcHk=;
	b=ZcpfmhlWI11R2bVfw3sMlN9nVYGbv4BgJ1/nODRwi0H1g72lAk09XQfDKV3rTGMfdjLV
	 Vf9IXWBJ1HakQXEjptI9YBqA2fYI32CdmpkvDydnDK/YZ5iJmFitVIgCpyUH1WZY4MUb6
	 5MhcgKMSFYjiWmjwsZns8ThseW/EXhn0gDr1uMGl6md4Ak/5FpPjalyLHlYfWAU0+/oF6
	 00NHNPE94AE9yuOvCmhAsSBPmUPY4qp/r6JFqLiuBaIg7EzcB4fal5n6b0KeZayPoomUW
	 5+objvVRzisgUXuP0X86ffJdTP+nesu5cwMGC0DS0MVTROnSO+vjSq8HOgeepW4dVvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vmstbP89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061C0606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 22:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vmstbP89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694331F000C1;
	Fri, 30 Oct 2026 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793399177;
	bh=NyCnztSFRVJPPe2xugAIV9P48Ypt2f5tkeiLr+tmcHk=;
	h=Date:To:From:Subject;
	b=vmstbP89kQwYZ9khrzkf733uUY4gUY7FnisTdxufWWM58Yd//o688j2QsGAdHmQtY
	 PlnRLybxYI498LNlzZGwDDgytRcfYmKd7b71wgsIL5CiwhJXXb6mhjn+a29f3Bf9O6
	 xY8VXClMV+gOzYRWM7uaBblE6v3VfWk+HJ9LI5Lw=
Date: Fri, 30 Oct 2026 15:26:16 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,
	david@kernel.org,corbet@lwn.net,akpm@linux-foundation.org,
	kmehltretter@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-docs-fix-an-error-code-two-names-and-the-pollerr-cause.patch added to mm-new branch
Message-Id: <20261030222617.694331F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: userfaultfd: docs: fix an error code, two names and the POLLERR cause
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-docs-fix-an-error-code-two-names-and-the-pollerr-cause.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-docs-fix-an-error-code-two-names-and-the-pollerr-cause.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: userfaultfd: docs: fix an error code, two names and the POLLERR cause
Date: Sat,  3 Oct 2026 13:01:37 +0200

Four statements in userfaultfd.rst do not match the code:

- UFFDIO_COPY is said to return -ENOSPC when the monitored process
  exits at the time of the copy. That error is -ESRCH since
  commit e86b298bebf7 ("userfaultfd: replace ENOSPC with ESRCH in case
  mm has gone during copy/zeropage"), and userfaultfd_copy() still
  returns -ESRCH when mmget_not_zero() fails.
- the postcopy example says that UFFDIO_ZEROCOPY is used for zero pages.
  The ioctl is UFFDIO_ZEROPAGE, as the same sentence says a line
  earlier.
- the write protect section says to clear UFFDIO_WRITEPROTECT_MODE_WP in
  pagefault.mode. struct uffd_msg's pagefault has no mode field. The
  flag goes in the mode field of struct uffdio_writeprotect, as the
  paragraph says when it sets the flag.
- poll() is said to report POLLERR "when ranges supplied were
  incorrect". userfaultfd_poll() never looks at ranges, and an ioctl
  with a bad range fails on its own. It returns EPOLLERR when the
  UFFDIO_API handshake has not been done yet and when the file does not
  have O_NONBLOCK set, and it did so when the sentence was written.

Say -ESRCH, UFFDIO_ZEROPAGE and mode, and name the two POLLERR cases.

Link: https://lore.kernel.org/20261003110137.88619-1-kmehltretter@gmail.com
Fixes: e86b298bebf7 ("userfaultfd: replace ENOSPC with ESRCH in case mm has gone during copy/zeropage")
Fixes: 25edd8bffd0f ("userfaultfd: linux/Documentation/vm/userfaultfd.txt")
Fixes: 57e5d4f278b9 ("userfaultfd: wp: UFFDIO_REGISTER_MODE_WP documentation update")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
---

 Documentation/admin-guide/mm/userfaultfd.rst |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/userfaultfd.rst~userfaultfd-docs-fix-an-error-code-two-names-and-the-pollerr-cause
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -199,8 +199,9 @@ Notes:
   those IOCTLs wakes up the faulting thread.
 
 - Be sure to test for all errors including
-  (``pollfd[0].revents & POLLERR``).  This can happen, e.g. when ranges
-  supplied were incorrect.
+  (``pollfd[0].revents & POLLERR``).  This happens if the userfaultfd
+  does not have ``O_NONBLOCK`` set, or if it is polled before the
+  ``UFFDIO_API`` handshake.
 
 Write Protect Notifications
 ---------------------------
@@ -218,7 +219,7 @@ protect as many ranges as you like (insi
 Then, in the thread reading from uffd the struct will have
 ``msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP`` set. Now you send
 ``ioctl(uffd, UFFDIO_WRITEPROTECT, struct *uffdio_writeprotect)``
-again while ``pagefault.mode`` does not have ``UFFDIO_WRITEPROTECT_MODE_WP``
+again while ``mode`` does not have ``UFFDIO_WRITEPROTECT_MODE_WP``
 set. This wakes up the thread which will continue to run with writes. This
 allows you to do the bookkeeping about the write in the uffd reading
 thread before the ioctl.
@@ -584,7 +585,7 @@ The QEMU in the source node writes all p
 in the destination node, into the socket, and the migration thread of
 the QEMU running in the destination node runs ``UFFDIO_COPY|ZEROPAGE``
 ioctls on the ``userfaultfd`` in order to map the received pages into the
-guest (``UFFDIO_ZEROCOPY`` is used if the source page was a zero page).
+guest (``UFFDIO_ZEROPAGE`` is used if the source page was a zero page).
 
 A different postcopy thread in the destination node listens with
 poll() to the ``userfaultfd`` in parallel. When a ``POLLIN`` event is
@@ -672,7 +673,7 @@ asynchronously and the non-cooperative p
 soon as manager executes read(). The ``userfaultfd`` manager should
 carefully synchronize calls to ``UFFDIO_COPY`` with the events
 processing. To aid the synchronization, the ``UFFDIO_COPY`` ioctl will
-return ``-ENOSPC`` when the monitored process exits at the time of
+return ``-ESRCH`` when the monitored process exits at the time of
 ``UFFDIO_COPY``, and ``-ENOENT``, when the non-cooperative process has changed
 its virtual memory layout simultaneously with outstanding ``UFFDIO_COPY``
 operation.
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

userfaultfd-docs-fix-an-error-code-two-names-and-the-pollerr-cause.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

