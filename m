From: akpm@linux-foundation.org
Subject: [patch 024/124] mm: fix comments for mmap_init()
Date: Fri, 24 Feb 2017 14:56:44 -0800
Message-ID: <58b0ba2c.zw1JZWMHGN/ylHX3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37666 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751407AbdBXW4q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamyooon@gmail.com

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
