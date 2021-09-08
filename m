Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5650DC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A16D61178
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 22:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhIHWT2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 18:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234941AbhIHWT1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Sep 2021 18:19:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28F5860F5B;
        Wed,  8 Sep 2021 22:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631139498;
        bh=/a8vHUdjnvVWNlw3c1xN/pv7+6h4tXT3Y3H5NTYWSHc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YkKnEZyjkBzvW1EPrQLOQcRe5UmVRqXhuwZVdiTNAboGNC5SyjKaeSKc6Pm7dTcRb
         h7TWgXndHnKgMrIDXzZOOx363kxKAL8T9oKisxAYglxcDdV8WfG+gIg9/6BHHrr2LM
         Uq3iUYwdgZ4yfsEe1VG3O+QDThARij6a/D/c+beM=
Date:   Wed, 08 Sep 2021 15:18:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        davem@davemloft.net, deller@gmx.de, ebiederm@xmission.com,
        feng.tang@intel.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hch@infradead.org, hch@lst.de, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, linux-mm@kvack.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paulus@samba.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        viro@zeniv.linux.org.uk, will@kernel.org
Subject:  [patch 07/10] mm: simplify compat_sys_move_pages
Message-ID: <20210908221817.j2XwhR14b%akpm@linux-foundation.org>
In-Reply-To: <20210908151729.c9a15a9508ba0aed22289c76@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: simplify compat_sys_move_pages

The compat move_pages() implementation uses compat_alloc_user_space() for
converting the pointer array.  Moving the compat handling into the
function itself is a bit simpler and lets us avoid the
compat_alloc_user_space() call.

Link: https://lkml.kernel.org/r/20210727144859.4150043-4-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

--- a/mm/migrate.c~mm-simplify-compat_sys_move_pages
+++ a/mm/migrate.c
@@ -1900,6 +1900,23 @@ set_status:
 	mmap_read_unlock(mm);
 }
 
+static int get_compat_pages_array(const void __user *chunk_pages[],
+				  const void __user * __user *pages,
+				  unsigned long chunk_nr)
+{
+	compat_uptr_t __user *pages32 = (compat_uptr_t __user *)pages;
+	compat_uptr_t p;
+	int i;
+
+	for (i = 0; i < chunk_nr; i++) {
+		if (get_user(p, pages32 + i))
+			return -EFAULT;
+		chunk_pages[i] = compat_ptr(p);
+	}
+
+	return 0;
+}
+
 /*
  * Determine the nodes of a user array of pages and store it in
  * a user array of status.
@@ -1919,8 +1936,15 @@ static int do_pages_stat(struct mm_struc
 		if (chunk_nr > DO_PAGES_STAT_CHUNK_NR)
 			chunk_nr = DO_PAGES_STAT_CHUNK_NR;
 
-		if (copy_from_user(chunk_pages, pages, chunk_nr * sizeof(*chunk_pages)))
-			break;
+		if (in_compat_syscall()) {
+			if (get_compat_pages_array(chunk_pages, pages,
+						   chunk_nr))
+				break;
+		} else {
+			if (copy_from_user(chunk_pages, pages,
+				      chunk_nr * sizeof(*chunk_pages)))
+				break;
+		}
 
 		do_pages_stat_array(mm, chunk_nr, chunk_pages, chunk_status);
 
@@ -2025,23 +2049,14 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE6(move_pages, pid_t, pid, compat_ulong_t, nr_pages,
-		       compat_uptr_t __user *, pages32,
+		       compat_uptr_t __user *, pages,
 		       const int __user *, nodes,
 		       int __user *, status,
 		       int, flags)
 {
-	const void __user * __user *pages;
-	int i;
-
-	pages = compat_alloc_user_space(nr_pages * sizeof(void *));
-	for (i = 0; i < nr_pages; i++) {
-		compat_uptr_t p;
-
-		if (get_user(p, pages32 + i) ||
-			put_user(compat_ptr(p), pages + i))
-			return -EFAULT;
-	}
-	return kernel_move_pages(pid, nr_pages, pages, nodes, status, flags);
+	return kernel_move_pages(pid, nr_pages,
+				 (const void __user *__user *)pages,
+				 nodes, status, flags);
 }
 #endif /* CONFIG_COMPAT */
 
_
