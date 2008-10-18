From: akpm@linux-foundation.org
Subject: - char-moxac-sparse-annotation.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:00 -0700
Message-ID: <200810182319.m9INJ0li029388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbYJRXTJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     char: moxa.c sparse annotation
has been removed from the -mm tree.  Its filename was
     char-moxac-sparse-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: moxa.c sparse annotation
From: Harvey Harrison <harvey.harrison@gmail.com>

The only use is to pass this to le16_to_cpu, declare as such
drivers/char/moxa.c:548:11: warning: cast to restricted __le16.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/moxa.c~char-moxac-sparse-annotation drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxac-sparse-annotation
+++ a/drivers/char/moxa.c
@@ -513,7 +513,7 @@ static int moxa_real_load_code(struct mo
 		size_t len)
 {
 	void __iomem *baseAddr = brd->basemem;
-	const u16 *uptr = ptr;
+	const __le16 *uptr = ptr;
 	size_t wlen, len2, j;
 	unsigned long key, loadbuf, loadlen, checksum, checksum_ok;
 	unsigned int i, retry;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
byteorder-provide-swabbh-generically-in-asm-byteorderh.patch
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

