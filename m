From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?binfmt=5Fflat-delete-two-error-messages-for-a-failed-memory?=
 =?US-ASCII?Q?-allocation-in-decompress=5Fexec.patch?= removed from -mm
 tree
Date: Mon, 11 Sep 2017 12:42:55 -0700
Message-ID: <20170911194255.gIegNizmD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50350 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdIKTm4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_flat: delete two error messages for a failed memory allocation in decompress_exec()
has been removed from the -mm tree.  Its filename was
     binfmt_flat-delete-two-error-messages-for-a-failed-memory-allocation-in-decompress_exec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


