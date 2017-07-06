From: akpm@linux-foundation.org
Subject: [patch 019/108] fs/file.c: replace alloc_fdmem() with
 kvmalloc() alternative
Date: Thu, 06 Jul 2017 15:36:19 -0700
Message-ID: <20170706223619._xIS8aqyK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34678 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752327AbdGFWgU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:36:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Michal Hocko <mhocko@suse.com>
Subject: fs/file.c: replace alloc_fdmem() with kvmalloc() alternative

There is no real reason to duplicate kvmalloc* helpers so drop alloc_fdmem
and replace it with the appropriate library function.

Link: http://lkml.kernel.org/r/20170531155145.17111-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff -puN fs/file.c~fs-file-replace-alloc_fdmem-with-kvmalloc-alternative fs/file.c
--- a/fs/file.c~fs-file-replace-alloc_fdmem-with-kvmalloc-alternative
+++ a/fs/file.c
@@ -30,21 +30,6 @@ unsigned int sysctl_nr_open_min = BITS_P
 unsigned int sysctl_nr_open_max =
 	__const_min(INT_MAX, ~(size_t)0/sizeof(void *)) & -BITS_PER_LONG;
 
-static void *alloc_fdmem(size_t size)
-{
-	/*
-	 * Very large allocations can stress page reclaim, so fall back to
-	 * vmalloc() if the allocation size will be considered "large" by the VM.
-	 */
-	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
-		void *data = kmalloc(size, GFP_KERNEL_ACCOUNT |
-				     __GFP_NOWARN | __GFP_NORETRY);
-		if (data != NULL)
-			return data;
-	}
-	return __vmalloc(size, GFP_KERNEL_ACCOUNT, PAGE_KERNEL);
-}
