From: akpm@linux-foundation.org
Subject: + tpm-increase-default-tpm-buffer.patch added to -mm tree
Date: Thu, 24 Sep 2009 13:47:02 -0700
Message-ID: <200909242047.n8OKl2bR013352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbZIXUra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 16:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com


The patch titled
     tpm: increase default TPM buffer
has been added to the -mm tree.  Its filename is
     tpm-increase-default-tpm-buffer.patch

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
Subject: tpm: increase default TPM buffer
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

The TPM Working Group requested this communication buffer increase given
that a particular TPM vendor can support a TPM_SHA1Start command input
bigger than the current size.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tpm/tpm.c~tpm-increase-default-tpm-buffer drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-increase-default-tpm-buffer
+++ a/drivers/char/tpm/tpm.c
@@ -31,7 +31,7 @@
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
-	TPM_BUFSIZE = 2048,
+	TPM_BUFSIZE = 4096,
 	TPM_NUM_DEVICES = 256,
 };
 
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

origin.patch
tpm-increase-default-tpm-buffer.patch

