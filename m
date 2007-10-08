From: akpm@linux-foundation.org
Subject: + correct-makefile-rule-for-generating-custom-keymap.patch added to -mm tree
Date: Mon, 08 Oct 2007 15:58:36 -0700
Message-ID: <200710082258.l98Mwa8D023565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897AbXJHW7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2007 18:59:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mbres@gentoo.org, ralf@linux-mips.org, sam@ravnborg.org, yoichi_yuasa@tripeaks.co.jp


The patch titled
     Correct Makefile rule for generating custom keymap
has been added to the -mm tree.  Its filename is
     correct-makefile-rule-for-generating-custom-keymap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Correct Makefile rule for generating custom keymap
From: Maarten Bressers <mbres@gentoo.org>

When building a custom keymap, after setting GENERATE_KEYMAP := 1 in
drivers/char/Makefile, the kernel build fails like this:

  CC      drivers/char/vt.o
make[2]: *** No rule to make target `drivers/char/%.map', needed by
`drivers/char/defkeymap.c'.  Stop.
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

This was caused by commit af8b128719f5248e542036ea994610a29d0642a6, which
deleted a necessary colon from the Makefile rule that generates the keymap,
since that rule contains both a target and a target-pattern.  The following
patch puts the colon back:

Signed-off-by: Maarten Bressers <mbres@gentoo.org>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/Makefile~correct-makefile-rule-for-generating-custom-keymap drivers/char/Makefile
--- a/drivers/char/Makefile~correct-makefile-rule-for-generating-custom-keymap
+++ a/drivers/char/Makefile
@@ -129,7 +129,7 @@ $(obj)/defkeymap.o:  $(obj)/defkeymap.c
 
 ifdef GENERATE_KEYMAP
 
-$(obj)/defkeymap.c $(obj)/%.c: $(src)/%.map
+$(obj)/defkeymap.c: $(obj)/%.c: $(src)/%.map
 	loadkeys --mktable $< > $@.tmp
 	sed -e 's/^static *//' $@.tmp > $@
 	rm $@.tmp
_

Patches currently in -mm which might be from mbres@gentoo.org are

correct-makefile-rule-for-generating-custom-keymap.patch
