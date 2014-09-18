From: akpm@linux-foundation.org
Subject: + fs-check-bh-blocknr-earlier-when-searching-lru.patch added to
 -mm tree
Date: Thu, 18 Sep 2014 12:25:38 -0700
Message-ID: <541b31b2.7IZLtQgtNLZadGuM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbaIRTZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 15:25:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zab@zabbo.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: check bh blocknr earlier when searching lru
has been added to the -mm tree.  Its filename is
     fs-check-bh-blocknr-earlier-when-searching-lru.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-check-bh-blocknr-earlier-when-searching-lru.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-check-bh-blocknr-earlier-when-searching-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zach Brown <zab@zabbo.net>
Subject: fs: check bh blocknr earlier when searching lru

It's very common for the buffer heads in the lru to have different block
numbers.  By comparing the blocknr before the bdev and size we can reduce
the cost of searching in the very common case where all the entries have
the same bdev and size.

In quick hot cache cycle counting tests on a single fs workstation this
cut the cost of a miss by about 20%.

A diff of the disassembly shows the reordering of the bdev and blocknr
comparisons.  This is in such a tiny loop that skipping one comparison is
a meaningful portion of the total work being done:

     1628:      83 c1 01                add    $0x1,%ecx
     162b:      83 f9 08                cmp    $0x8,%ecx
     162e:      74 60                   je     1690 <__find_get_block+0xa0>
     1630:      89 c8                   mov    %ecx,%eax
     1632:      65 4c 8b 04 c5 00 00    mov    %gs:0x0(,%rax,8),%r8
     1639:      00 00
     163b:      4d 85 c0                test   %r8,%r8
     163e:      4c 89 c3                mov    %r8,%rbx
     1641:      74 e5                   je     1628 <__find_get_block+0x38>
-    1643:      4d 3b 68 30             cmp    0x30(%r8),%r13
+    1643:      4d 3b 68 18             cmp    0x18(%r8),%r13
     1647:      75 df                   jne    1628 <__find_get_block+0x38>
-    1649:      4d 3b 60 18             cmp    0x18(%r8),%r12
+    1649:      4d 3b 60 30             cmp    0x30(%r8),%r12
     164d:      75 d9                   jne    1628 <__find_get_block+0x38>
     164f:      49 39 50 20             cmp    %rdx,0x20(%r8)
     1653:      75 d3                   jne    1628 <__find_get_block+0x38>

Signed-off-by: Zach Brown <zab@zabbo.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/buffer.c~fs-check-bh-blocknr-earlier-when-searching-lru fs/buffer.c
--- a/fs/buffer.c~fs-check-bh-blocknr-earlier-when-searching-lru
+++ a/fs/buffer.c
@@ -1331,8 +1331,8 @@ lookup_bh_lru(struct block_device *bdev,
 	for (i = 0; i < BH_LRU_SIZE; i++) {
 		struct buffer_head *bh = __this_cpu_read(bh_lrus.bhs[i]);
 
-		if (bh && bh->b_bdev == bdev &&
-				bh->b_blocknr == block && bh->b_size == size) {
+		if (bh && bh->b_blocknr == block && bh->b_bdev == bdev &&
+		    bh->b_size == size) {
 			if (i) {
 				while (i) {
 					__this_cpu_write(bh_lrus.bhs[i],
_

Patches currently in -mm which might be from zab@zabbo.net are

fs-check-bh-blocknr-earlier-when-searching-lru.patch

