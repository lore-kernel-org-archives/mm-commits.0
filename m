From: akpm@linux-foundation.org
Subject: + mm-bootmemc-cosmetic-improvement-of-code-readability.patch
 added to -mm tree
Date: Mon, 09 Jan 2017 14:43:54 -0800
Message-ID: <5874122a.8n3YWioJPVSbVJdq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755826AbdAIWm1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 17:42:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ondar07@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/bootmem.c: cosmetic improvement of code readability
has been added to the -mm tree.  Its filename is
     mm-bootmemc-cosmetic-improvement-of-code-readability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-bootmemc-cosmetic-improvement-of-code-readability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-bootmemc-cosmetic-improvement-of-code-readability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ondar07@gmail.com are

mm-bootmemc-cosmetic-improvement-of-code-readability.patch

