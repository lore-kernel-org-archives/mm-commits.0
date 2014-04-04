From: akpm@linux-foundation.org
Subject: [merged] kmemleak-remove-redundant-code.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:29:28 -0700
Message-ID: <533f0818.X3sWCchh8+r0osGm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaDDT32 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: [merged] kmemleak-remove-redundant-code.patch removed from -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:28 -0700


The patch titled
     Subject: kmemleak: remove redundant code
has been removed from the -mm tree.  Its filename was
     kmemleak-remove-redundant-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kmemleak: remove redundant code

- remove kmemleak_padding().
- remove kmemleak_release().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmemleak.h |    2 --
 mm/kmemleak.c            |    7 +------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN include/linux/kmemleak.h~kmemleak-remove-redundant-code include/linux/kmemleak.h
--- a/include/linux/kmemleak.h~kmemleak-remove-redundant-code
+++ a/include/linux/kmemleak.h
@@ -30,8 +30,6 @@ extern void kmemleak_alloc_percpu(const
 extern void kmemleak_free(const void *ptr) __ref;
 extern void kmemleak_free_part(const void *ptr, size_t size) __ref;
 extern void kmemleak_free_percpu(const void __percpu *ptr) __ref;
-extern void kmemleak_padding(const void *ptr, unsigned long offset,
-			     size_t size) __ref;
 extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
diff -puN mm/kmemleak.c~kmemleak-remove-redundant-code mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-remove-redundant-code
+++ a/mm/kmemleak.c
@@ -1549,11 +1549,6 @@ static int kmemleak_open(struct inode *i
 	return seq_open(file, &kmemleak_seq_ops);
 }
 
-static int kmemleak_release(struct inode *inode, struct file *file)
-{
-	return seq_release(inode, file);
-}
