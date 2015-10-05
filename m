From: akpm@linux-foundation.org
Subject: + mm-mmapc-do-not-initialize-retval-in-mmap_pgoff.patch added to
 -mm tree
Date: Mon, 05 Oct 2015 13:38:06 -0700
Message-ID: <5612dfae.ZGo7CH9ifrxfLzSF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbbJEUiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 16:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xili_gchen_5257@hotmail.com, gang.chen.5i5j@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: do not initialize retval in mmap_pgoff()
has been added to the -mm tree.  Its filename is
     mm-mmapc-do-not-initialize-retval-in-mmap_pgoff.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-do-not-initialize-retval-in-mmap_pgoff.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-do-not-initialize-retval-in-mmap_pgoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <xili_gchen_5257@hotmail.com>
Subject: mm/mmap.c: do not initialize retval in mmap_pgoff()

When fget() fails we can return -EBADF directly.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-do-not-initialize-retval-in-mmap_pgoff mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-do-not-initialize-retval-in-mmap_pgoff
+++ a/mm/mmap.c
@@ -1412,13 +1412,13 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 		unsigned long, fd, unsigned long, pgoff)
 {
 	struct file *file = NULL;
-	unsigned long retval = -EBADF;
+	unsigned long retval;
 
 	if (!(flags & MAP_ANONYMOUS)) {
 		audit_mmap_fd(fd, flags);
 		file = fget(fd);
 		if (!file)
-			goto out;
+			return -EBADF;
 		if (is_file_hugepages(file))
 			len = ALIGN(len, huge_page_size(hstate_file(file)));
 		retval = -EINVAL;
@@ -1453,7 +1453,6 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 out_fput:
 	if (file)
 		fput(file);
-out:
 	return retval;
 }
 
_

Patches currently in -mm which might be from xili_gchen_5257@hotmail.com are

mm-mmapc-remove-redundant-statement-error-=-enomem.patch
mm-mmapc-do-not-initialize-retval-in-mmap_pgoff.patch

