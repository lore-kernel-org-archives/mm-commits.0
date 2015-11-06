From: akpm@linux-foundation.org
Subject: [merged] mm-mmapc-do-not-initialize-retval-in-mmap_pgoff.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:09:08 -0800
Message-ID: <563d08e4.KZejNNh/2lVk6UuG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033748AbbKFUJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:09:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xili_gchen_5257@hotmail.com, gang.chen.5i5j@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: do not initialize retval in mmap_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-mmapc-do-not-initialize-retval-in-mmap_pgoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


