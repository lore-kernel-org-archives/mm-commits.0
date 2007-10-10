From: akpm@linux-foundation.org
Subject: - correct-makefile-rule-for-generating-custom-keymap.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:20 -0700
Message-ID: <200710102110.l9ALAKkM025921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38908 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756477AbXJJVKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mbres@gentoo.org, ralf@linux-mips.org, sam@ravnborg.org, yoichi_yuasa@tripeaks.co.jp, mm-commits@vger.kernel.org


The patch titled
     Correct Makefile rule for generating custom keymap
has been removed from the -mm tree.  Its filename was
     correct-makefile-rule-for-generating-custom-keymap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
