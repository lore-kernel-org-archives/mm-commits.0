From: akpm@linux-foundation.org
Subject: + kmemleak-remove-redundant-code.patch added to -mm tree
Date: Fri, 21 Mar 2014 14:30:12 -0700
Message-ID: <532caf64.FjOFiM/tYP1h55j3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaCUVaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Mar 2014 17:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: + kmemleak-remove-redundant-code.patch added to -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com
From: akpm@linux-foundation.org
Date: Fri, 21 Mar 2014 14:30:12 -0700


The patch titled
     Subject: kmemleak: remove redundant code
has been added to the -mm tree.  Its filename is
     kmemleak-remove-redundant-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemleak-remove-redundant-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-remove-redundant-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kmemleak: remove redundant code

- remove kmemleak_padding().
- remove kmemleak_release().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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
@@ -1545,11 +1545,6 @@ static int kmemleak_open(struct inode *i
 	return seq_open(file, &kmemleak_seq_ops);
 }
 
-static int kmemleak_release(struct inode *inode, struct file *file)
-{
-	return seq_release(inode, file);
-}
