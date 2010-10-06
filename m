From: akpm@linux-foundation.org
Subject: + fcntl-make-exported-headers-use-strict-posix-types.patch added to -mm tree
Date: Wed, 06 Oct 2010 15:03:47 -0700
Message-ID: <201010062203.o96M3lSr024877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427Ab0JFWEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Oct 2010 18:04:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lucian.grijincu@gmail.com, arnd@arndb.de


The patch titled
     fcntl: make exported headers use strict posix types
has been added to the -mm tree.  Its filename is
     fcntl-make-exported-headers-use-strict-posix-types.patch

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
Subject: fcntl: make exported headers use strict posix types
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>

All 'pid_t' were changed to '__kernel_pid_t' in a previous commit:
make exported headers use strict posix types

    A number of standard posix types are used in exported headers,
    which is not allowed if __STRICT_KERNEL_NAMES is defined. In order
    to get rid of the non-__STRICT_KERNEL_NAMES part and to make sane
    headers the default, we have to change them all to safe types.

but a later change introduced 'pid_t' again:
    fcntl: add F_[SG]ETOWN_EX

This makes asm-generic/fcntl.h d use strict posix types again.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/fcntl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/fcntl.h~fcntl-make-exported-headers-use-strict-posix-types include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~fcntl-make-exported-headers-use-strict-posix-types
+++ a/include/asm-generic/fcntl.h
@@ -122,7 +122,7 @@
 
 struct f_owner_ex {
 	int	type;
-	pid_t	pid;
+	__kernel_pid_t	pid;
 };
 
 /* for F_[GET|SET]FL */
_

Patches currently in -mm which might be from lucian.grijincu@gmail.com are

fcntl-make-exported-headers-use-strict-posix-types.patch

