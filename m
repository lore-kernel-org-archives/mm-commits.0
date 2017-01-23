From: akpm@linux-foundation.org
Subject: + mm-fix-comments-for-mmap_init.patch added to -mm tree
Date: Mon, 23 Jan 2017 15:38:53 -0800
Message-ID: <5886940d./suFThRlvok4tflh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46404 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdAWXiy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 18:38:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamyooon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix comments for mmap_init()
has been added to the -mm tree.  Its filename is
     mm-fix-comments-for-mmap_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-comments-for-mmap_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-comments-for-mmap_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "seokhoon.yoon" <iamyooon@gmail.com>
Subject: mm: fix comments for mmap_init()

mmap_init() is no longer associated with VMA slab. so fix it.

Link: http://lkml.kernel.org/r/1485182601-9294-1-git-send-email-iamyooon@gmail.com
Signed-off-by: seokhoon.yoon <iamyooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c  |    2 +-
 mm/nommu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-fix-comments-for-mmap_init mm/mmap.c
--- a/mm/mmap.c~mm-fix-comments-for-mmap_init
+++ a/mm/mmap.c
@@ -3446,7 +3446,7 @@ void mm_drop_all_locks(struct mm_struct
 }
 
 /*
- * initialise the VMA slab
+ * initialise the percpu counter for VM
  */
 void __init mmap_init(void)
 {
diff -puN mm/nommu.c~mm-fix-comments-for-mmap_init mm/nommu.c
--- a/mm/nommu.c~mm-fix-comments-for-mmap_init
+++ a/mm/nommu.c
@@ -517,7 +517,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 }
 
 /*
- * initialise the VMA and region record slabs
+ * initialise the percpu counter for VM and region record slabs
  */
 void __init mmap_init(void)
 {
_

Patches currently in -mm which might be from iamyooon@gmail.com are

mm-fix-comments-for-mmap_init.patch

