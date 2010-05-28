From: akpm@linux-foundation.org
Subject: + flat-fix-unmap-len-in-load-error-path.patch added to -mm tree
Date: Fri, 28 May 2010 16:26:54 -0700
Message-ID: <201005282326.o4SNQsnS020455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631Ab0E1Xb0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 19:31:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, davidm@snapgear.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org, monstr@monstr.eu, takata@linux-m32r.org


The patch titled
     flat: fix unmap len in load error path
has been added to the -mm tree.  Its filename is
     flat-fix-unmap-len-in-load-error-path.patch

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
Subject: flat: fix unmap len in load error path
From: Mike Frysinger <vapier@gentoo.org>

The data chunk is mmaped with 'len' which remains unchanged, so use that
when unmapping in the error path rather than trying to recalculate (and
incorrectly so) the value used originally.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: David McCullough <davidm@snapgear.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_flat.c~flat-fix-unmap-len-in-load-error-path fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~flat-fix-unmap-len-in-load-error-path
+++ a/fs/binfmt_flat.c
@@ -596,7 +596,7 @@ static int load_flat_file(struct linux_b
 		if (IS_ERR_VALUE(result)) {
 			printk("Unable to read data+bss, errno %d\n", (int)-result);
 			do_munmap(current->mm, textpos, text_len);
-			do_munmap(current->mm, realdatastart, data_len + extra);
+			do_munmap(current->mm, realdatastart, len);
 			ret = result;
 			goto err;
 		}
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
flat-split-the-stack-data-alignments.patch
flat-tweak-default-stack-alignment.patch
flat-fix-unmap-len-in-load-error-path.patch

