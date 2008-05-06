From: akpm@linux-foundation.org
Subject: + uml-use-div_round_up.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:33 -0700
Message-ID: <200805062049.m46KnXhY026591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763766AbYEFUuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com


The patch titled
     uml: use DIV_ROUND_UP
has been added to the -mm tree.  Its filename is
     uml-use-div_round_up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: use DIV_ROUND_UP
From: Jiri Olsa <olsajiri@gmail.com>

I just saw similar patches in the janitor kernel's list, and spotted place it
fits.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-use-div_round_up arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-use-div_round_up
+++ a/arch/um/drivers/ubd_kern.c
@@ -1178,8 +1178,8 @@ static void cowify_bitmap(__u64 io_offse
 	 * by one word.  Thanks to Lynn Kerby for the fix and James McMechan
 	 * for the original diagnosis.
 	 */
-	if(*cow_offset == ((bitmap_len + sizeof(unsigned long) - 1) /
-			   sizeof(unsigned long) - 1))
+	if (*cow_offset == (DIV_ROUND_UP(bitmap_len,
+					 sizeof(unsigned long)) - 1))
 		(*cow_offset)--;
 
 	bitmap_words[0] = bitmap[*cow_offset];
_

Patches currently in -mm which might be from olsajiri@gmail.com are

uml-use-div_round_up.patch

