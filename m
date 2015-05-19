From: akpm@linux-foundation.org
Subject: + omfs-fix-potential-integer-overflow-in-allocator.patch added to -mm tree
Date: Tue, 19 May 2015 16:20:19 -0700
Message-ID: <555bc533.kz+OJ8grlY6SFrqt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbESXUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 19:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@bobcopeland.com, mm-commits@vger.kernel.org


The patch titled
     Subject: omfs: fix potential integer overflow in allocator
has been added to the -mm tree.  Its filename is
     omfs-fix-potential-integer-overflow-in-allocator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/omfs-fix-potential-integer-overflow-in-allocator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/omfs-fix-potential-integer-overflow-in-allocator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Copeland <me@bobcopeland.com>
Subject: omfs: fix potential integer overflow in allocator

Both 'i' and 'bits_per_entry' are signed integers but the result is a u64
block number.  Cast i to u64 to avoid truncation on 32-bit targets.

Found by Coverity (CID 200679).

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/omfs/bitmap.c~omfs-fix-potential-integer-overflow-in-allocator fs/omfs/bitmap.c
--- a/fs/omfs/bitmap.c~omfs-fix-potential-integer-overflow-in-allocator
+++ a/fs/omfs/bitmap.c
@@ -159,7 +159,7 @@ int omfs_allocate_range(struct super_blo
 	goto out;
 
 found:
-	*return_block = i * bits_per_entry + bit;
+	*return_block = (u64) i * bits_per_entry + bit;
 	*return_size = run;
 	ret = set_run(sb, i, bits_per_entry, bit, run, 1);
 
_

Patches currently in -mm which might be from me@bobcopeland.com are

fs-omfs-add-null-terminator-in-the-end-up-the-token-list.patch
omfs-set-error-return-when-d_make_root-fails.patch
omfs-fix-sign-confusion-for-bitmap-loop-counter.patch
omfs-fix-potential-integer-overflow-in-allocator.patch
linux-next.patch

