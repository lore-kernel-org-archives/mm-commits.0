From: akpm@linux-foundation.org
Subject: + lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool.patch
 added to -mm tree
Date: Mon, 22 Dec 2014 13:05:57 -0800
Message-ID: <549887b5.nqsqSGiodVMB4HkV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbaLVVF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Dec 2014 16:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshik@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc.c: fix the end addr check in addr_in_gen_pool()
has been added to the -mm tree.  Its filename is
     lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kikuchi <toshik@chromium.org>
Subject: lib/genalloc.c: fix the end addr check in addr_in_gen_pool()

Since chunk->end_addr is (chunk->start_addr + size - 1), the end address
to compare should be (start + size - 1).

Signed-off-by: Toshi Kikuchi <toshik@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/genalloc.c~lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool
+++ a/lib/genalloc.c
@@ -415,7 +415,7 @@ bool addr_in_gen_pool(struct gen_pool *p
 			size_t size)
 {
 	bool found = false;
-	unsigned long end = start + size;
+	unsigned long end = start + size - 1;
 	struct gen_pool_chunk *chunk;
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from toshik@chromium.org are

lib-genallocc-fix-the-end-addr-check-in-addr_in_gen_pool.patch
linux-next.patch

