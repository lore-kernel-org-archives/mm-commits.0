From: akpm@linux-foundation.org
Subject: + page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:33:51 -0700
Message-ID: <200806302233.m5UMXpAn029071__48133.6240111434$1214865297$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757000AbYF3Wdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com, linux-arch@vger.kernel.org


The patch titled
     page_align-correctly-handle-64-bit-values-on-32-bit-architectures x86_64 fix
has been added to the -mm tree.  Its filename is
     page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix.patch

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
Subject: page_align-correctly-handle-64-bit-values-on-32-bit-architectures x86_64 fix
From: Andrea Righi <righi.andrea@gmail.com>

x86_64 allmodconfig build failed due to a missing #include <linux/mm.h>
in arch/x86/kernel/module_64.c.

Following patch resolves (on top of the previous one).

Except this, no errors for x86_64.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/module_64.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/module_64.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix arch/x86/kernel/module_64.c
--- a/arch/x86/kernel/module_64.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix
+++ a/arch/x86/kernel/module_64.c
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/bug.h>
 
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix.patch
distinct-tgid-tid-i-o-statistics.patch

