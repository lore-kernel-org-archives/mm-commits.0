From: akpm@linux-foundation.org
Subject: + fs-bioc-add-missing-__user-annotation.patch added to -mm tree
Date: Mon, 04 May 2009 14:30:49 -0700
Message-ID: <200905042130.n44LUnC1005778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021AbZEDVdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: monstr@monstr.eu, jens.axboe@oracle.com


The patch titled
     fs/bio.c: add missing __user annotation
has been added to the -mm tree.  Its filename is
     fs-bioc-add-missing-__user-annotation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -721,7 +721,7 @@ static int __bio_copy_iov(struct bio *bi
 
 		while (bv_len && iov_idx < iov_count) {
 			unsigned int bytes;
-			char *iov_addr;
+			char __user *iov_addr;
 
 			bytes = min_t(unsigned int,
 				      iov[iov_idx].iov_len - iov_off, bv_len);
_

Patches currently in -mm which might be from monstr@monstr.eu are

origin.patch
fs-remove-sparse-errors-in-proc_devtreec.patch
fs-bioc-add-missing-__user-annotation.patch

