From: akpm@linux-foundation.org
Subject: [patch 105/142] mm/bootmem.c: cosmetic improvement of code
 readability
Date: Wed, 22 Feb 2017 15:44:58 -0800
Message-ID: <58ae227a.XNe/YMJV0hRgnKZG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933785AbdBVXpA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:45:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ondar07@gmail.com

From: Adygzhy Ondar <ondar07@gmail.com>
Subject: mm/bootmem.c: cosmetic improvement of code readability

The obvious number of bits in a byte is replaced
by BITS_PER_BYTE macro in bootmap_bytes()

Link: http://lkml.kernel.org/r/1483781600-5136-1-git-send-email-ondar07@gmail.com
Signed-off-by: Adygzhy Ondar <ondar07@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/bootmem.c~mm-bootmemc-cosmetic-improvement-of-code-readability mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmemc-cosmetic-improvement-of-code-readability
+++ a/mm/bootmem.c
@@ -53,7 +53,7 @@ early_param("bootmem_debug", bootmem_deb
 
 static unsigned long __init bootmap_bytes(unsigned long pages)
 {
-	unsigned long bytes = DIV_ROUND_UP(pages, 8);
+	unsigned long bytes = DIV_ROUND_UP(pages, BITS_PER_BYTE);
 
 	return ALIGN(bytes, sizeof(long));
 }
_
