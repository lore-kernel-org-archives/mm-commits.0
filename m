From: akpm@linux-foundation.org
Subject: + make-debug_bugverbose-default-to-y.patch added to -mm tree
Date: Mon, 09 Nov 2009 14:22:50 -0800
Message-ID: <200911092222.nA9MMoIw015241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064AbZKIWXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 17:23:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, mingo@elte.hu, sam@ravnborg.org


The patch titled
     Make DEBUG_BUGVERBOSE default to y
has been added to the -mm tree.  Its filename is
     make-debug_bugverbose-default-to-y.patch

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
Subject: Make DEBUG_BUGVERBOSE default to y
From: Alexey Dobriyan <adobriyan@gmail.com>

It's easy to lose useful DEBUG_BUGVERBOSE by switching EMBEDDED left and right.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN lib/Kconfig.debug~make-debug_bugverbose-default-to-y lib/Kconfig.debug
--- a/lib/Kconfig.debug~make-debug_bugverbose-default-to-y
+++ a/lib/Kconfig.debug
@@ -588,7 +588,7 @@ config DEBUG_BUGVERBOSE
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
 		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300
-	default !EMBEDDED
+	default y
 	help
 	  Say Y here to make BUG() panics output the file name and line number
 	  of the BUG call as well as the EIP and oops trace.  This aids
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
uml-irq-register-race-condition.patch
linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

