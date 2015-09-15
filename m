From: akpm@linux-foundation.org
Subject: + userfaultfd-add-missing-mmput-in-error-path.patch added to -mm
 tree
Date: Tue, 15 Sep 2015 12:38:40 -0700
Message-ID: <55f873c0.tCwaMWADJLsN2Nro%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbIOTil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 15:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers3@gmail.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: add missing mmput() in error path
has been added to the -mm tree.  Its filename is
     userfaultfd-add-missing-mmput-in-error-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-add-missing-mmput-in-error-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-add-missing-mmput-in-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers3@gmail.com>
Subject: userfaultfd: add missing mmput() in error path

This fixes a memleak if anon_inode_getfile() fails in userfaultfd().

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-add-missing-mmput-in-error-path fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-add-missing-mmput-in-error-path
+++ a/fs/userfaultfd.c
@@ -1287,8 +1287,10 @@ static struct file *userfaultfd_file_cre
 
 	file = anon_inode_getfile("[userfaultfd]", &userfaultfd_fops, ctx,
 				  O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
-	if (IS_ERR(file))
+	if (IS_ERR(file)) {
+		mmput(ctx->mm);
 		kmem_cache_free(userfaultfd_ctx_cachep, ctx);
+	}
 out:
 	return file;
 }
_

Patches currently in -mm which might be from ebiggers3@gmail.com are

userfaultfd-add-missing-mmput-in-error-path.patch

