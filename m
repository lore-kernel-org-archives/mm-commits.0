Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9B0C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69C2760FDB
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhG0UZU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232140AbhG0UZS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:25:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A420960F9D;
        Tue, 27 Jul 2021 20:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627417518;
        bh=+ysEyf5VYGtbdXzNnHNm7u9cH3SSgN3/E10/hoTCyic=;
        h=Date:From:To:Subject:From;
        b=N4a73lv4Q7rijJPiij5D3z0U3QCq/C9fYBYzzgB6mmZxSMwOosL1dW/cKVrYwQ9HD
         qLIoyJMKqAemHRBgw/Szkk1Lq8ElEDYlWuJwH/S0dPsdBj966IQKwZpHy+GfOs9pt9
         u525O00qq7a9C39aXxkUcHqzKJawhwvktvi8ms9U=
Date:   Tue, 27 Jul 2021 13:25:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        viro@zeniv.linux.org.uk, tsbogend@alpha.franken.de,
        tglx@linutronix.de, paulus@samba.org, mpe@ellerman.id.au,
        mingo@redhat.com, James.Bottomley@HansenPartnership.com,
        hpa@zytor.com, hch@lst.de, hch@infradead.org, hca@linux.ibm.com,
        gor@linux.ibm.com, feng.tang@intel.com, ebiederm@xmission.com,
        deller@gmx.de, davem@davemloft.net, catalin.marinas@arm.com,
        bp@alien8.de, borntraeger@de.ibm.com, benh@kernel.crashing.org,
        arnd@arndb.de
Subject:  + mm-simplify-compat_sys_move_pages.patch added to -mm tree
Message-ID: <20210727202517.PDcV0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify compat_sys_move_pages
has been added to the -mm tree.  Its filename is
     mm-simplify-compat_sys_move_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-compat_sys_move_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-compat_sys_move_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1899,6 +1899,23 @@ set_status:
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
@@ -1918,8 +1935,15 @@ static int do_pages_stat(struct mm_struc
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
 
@@ -2024,23 +2048,14 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 
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

Patches currently in -mm which might be from arnd@arndb.de are

kexec-move-locking-into-do_kexec_load.patch
kexec-avoid-compat_alloc_user_space.patch
mm-simplify-compat_sys_move_pages.patch
mm-simplify-compat-numa-syscalls.patch
compat-remove-some-compat-entry-points.patch
arch-remove-compat_alloc_user_space.patch

