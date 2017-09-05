From: akpm@linux-foundation.org
Subject: +
 binfmt_flat-delete-two-error-messages-for-a-failed-memory-allocation-in-decompress_exec.patch added to -mm tree
Date: Tue, 05 Sep 2017 15:49:22 -0700
Message-ID: <59af29f2.gGm7PkaoBIXAO+I5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752909AbdIEWtX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 18:49:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_flat: delete two error messages for a failed memory allocation in decompress_exec()
has been added to the -mm tree.  Its filename is
     binfmt_flat-delete-two-error-messages-for-a-failed-memory-allocation-in-decompress_exec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_flat-delete-two-error-messages-for-a-failed-memory-allocation-in-decompress_exec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_flat-delete-two-error-messages-for-a-failed-memory-allocation-in-decompress_exec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: binfmt_flat: delete two error messages for a failed memory allocation in decompress_exec()

Omit extra messages for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://lkml.kernel.org/r/f92aac79-b05e-321a-1a19-d38c7159ee9c@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/binfmt_flat.c~binfmt_flat-delete-two-error-messages-for-a-failed-memory-allocation-in-decompress_exec fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~binfmt_flat-delete-two-error-messages-for-a-failed-memory-allocation-in-decompress_exec
+++ a/fs/binfmt_flat.c
@@ -192,13 +192,11 @@ static int decompress_exec(
 
 	memset(&strm, 0, sizeof(strm));
 	strm.workspace = kmalloc(zlib_inflate_workspacesize(), GFP_KERNEL);
-	if (strm.workspace == NULL) {
-		pr_debug("no memory for decompress workspace\n");
+	if (!strm.workspace)
 		return -ENOMEM;
-	}
+
 	buf = kmalloc(LBUFSIZE, GFP_KERNEL);
-	if (buf == NULL) {
-		pr_debug("no memory for read buffer\n");
+	if (!buf) {
 		retval = -ENOMEM;
 		goto out_free;
 	}
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

binfmt_flat-delete-two-error-messages-for-a-failed-memory-allocation-in-decompress_exec.patch

