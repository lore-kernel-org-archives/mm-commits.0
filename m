From: akpm@linux-foundation.org
Subject: [patch 087/101] mm: optimize copy_page_to/from_iter_iovec
Date: Thu, 28 Jul 2016 15:48:50 -0700
Message-ID: <579a8bd2.Ji/tr4Weydk3T2ey%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbcG1Wsv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:48:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mpatocka@redhat.com, andi@firstfloor.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@kernel.org, viro@zeniv.linux.org.uk

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: mm: optimize copy_page_to/from_iter_iovec

copy_page_to_iter_iovec() and copy_page_from_iter_iovec() copy some data
to userspace or from userspace.  These functions have a fast path where
they map a page using kmap_atomic and a slow path where they use kmap.

kmap is slower than kmap_atomic, so the fast path is preferred.

However, on kernels without highmem support, kmap just calls page_address,
so there is no need to avoid kmap.  On kernels without highmem support,
the fast path just increases code size (and cache footprint) and it
doesn't improve copy performance in any way.

This patch enables the fast path only if CONFIG_HIGHMEM is defined.

Code size reduced by this patch:
x86 (without highmem)	928
x86-64			960
sparc64			848
alpha			1136
pa-risc			1200

[akpm@linux-foundation.org: use IS_ENABLED(), per Andi]
Link: http://lkml.kernel.org/r/alpine.LRH.2.02.1607221711410.4818@file01.intranet.prod.int.rdu2.redhat.com
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN lib/iov_iter.c~mm-optimize-copy_page_to-from_iter_iovec lib/iov_iter.c
--- a/lib/iov_iter.c~mm-optimize-copy_page_to-from_iter_iovec
+++ a/lib/iov_iter.c
@@ -144,7 +144,7 @@ static size_t copy_page_to_iter_iovec(st
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-	if (!fault_in_pages_writeable(buf, copy)) {
+	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_writeable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		from = kaddr + offset;
 
@@ -175,6 +175,7 @@ static size_t copy_page_to_iter_iovec(st
 		copy = min(bytes, iov->iov_len - skip);
 	}
 	/* Too bad - revert to non-atomic kmap */
+
 	kaddr = kmap(page);
 	from = kaddr + offset;
 	left = __copy_to_user(buf, from, copy);
@@ -193,6 +194,7 @@ static size_t copy_page_to_iter_iovec(st
 		bytes -= copy;
 	}
 	kunmap(page);
+
 done:
 	if (skip == iov->iov_len) {
 		iov++;
@@ -225,7 +227,7 @@ static size_t copy_page_from_iter_iovec(
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-	if (!fault_in_pages_readable(buf, copy)) {
+	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_readable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		to = kaddr + offset;
 
@@ -256,6 +258,7 @@ static size_t copy_page_from_iter_iovec(
 		copy = min(bytes, iov->iov_len - skip);
 	}
 	/* Too bad - revert to non-atomic kmap */
+
 	kaddr = kmap(page);
 	to = kaddr + offset;
 	left = __copy_from_user(to, buf, copy);
@@ -274,6 +277,7 @@ static size_t copy_page_from_iter_iovec(
 		bytes -= copy;
 	}
 	kunmap(page);
+
 done:
 	if (skip == iov->iov_len) {
 		iov++;
_
