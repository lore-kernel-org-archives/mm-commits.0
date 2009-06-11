From: akpm@linux-foundation.org
Subject: [merged] fs-bioc-add-missing-__user-annotation.patch removed from -mm tree
Date: Thu, 11 Jun 2009 14:24:57 -0700
Message-ID: <200906112124.n5BLOvbL017925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbZFKVZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 17:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: monstr@monstr.eu, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs/bio.c: add missing __user annotation
has been removed from the -mm tree.  Its filename was
     fs-bioc-add-missing-__user-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/bio.c: add missing __user annotation
From: Michal Simek <monstr@monstr.eu>

As reported by sparse:

fs/bio.c:720:13: warning: incorrect type in assignment (different address spaces)
fs/bio.c:720:13:    expected char *iov_addr
fs/bio.c:720:13:    got void [noderef] <asn:1>*
fs/bio.c:724:36: warning: incorrect type in argument 2 (different address spaces)
fs/bio.c:724:36:    expected void const [noderef] <asn:1>*from
fs/bio.c:724:36:    got char *iov_addr

Signed-off-by: Michal Simek <monstr@monstr.eu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/bio.c~fs-bioc-add-missing-__user-annotation fs/bio.c
--- a/fs/bio.c~fs-bioc-add-missing-__user-annotation
+++ a/fs/bio.c
@@ -722,7 +722,7 @@ static int __bio_copy_iov(struct bio *bi
 
 		while (bv_len && iov_idx < iov_count) {
 			unsigned int bytes;
-			char *iov_addr;
+			char __user *iov_addr;
 
 			bytes = min_t(unsigned int,
 				      iov[iov_idx].iov_len - iov_off, bv_len);
_

Patches currently in -mm which might be from monstr@monstr.eu are

origin.patch
linux-next.patch
fs-remove-sparse-errors-in-proc_devtreec.patch
mb862xxfb-restrict-compliation-of-platform-driver-to-ppc.patch
mb862xxfb-use-config_of-instead-of-config_ppc_of.patch

