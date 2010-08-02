From: akpm@linux-foundation.org
Subject: + l2tp-fix-export-of-header-file-for-userspace.patch added to -mm tree
Date: Mon, 02 Aug 2010 14:46:33 -0700
Message-ID: <201008022146.o72LkX22013008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab0HBVrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Aug 2010 17:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james@bert.katalix.com, davem@davemloft.net, jchapman@katalix.com, stable@kernel.org


The patch titled
     l2tp: fix export of header file for userspace
has been added to the -mm tree.  Its filename is
     l2tp-fix-export-of-header-file-for-userspace.patch

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
Subject: l2tp: fix export of header file for userspace
From: James Chapman <james@bert.katalix.com>

The header file l2tp.h should be exported to the installed include/linux/
tree for userspace programs.

This patch fixes compilation errors in L2TP userspace apps which want to
use the new L2TP support introduced in 2.6.35.

Signed-off-by: James Chapman <jchapman@katalix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/Kbuild~l2tp-fix-export-of-header-file-for-userspace include/linux/Kbuild
--- a/include/linux/Kbuild~l2tp-fix-export-of-header-file-for-userspace
+++ a/include/linux/Kbuild
@@ -278,6 +278,7 @@ ifneq ($(wildcard $(srctree)/arch/$(SRCA
 		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
 unifdef-y += kvm_para.h
 endif
+unifdef-y += l2tp.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
_

Patches currently in -mm which might be from james@bert.katalix.com are

l2tp-fix-export-of-header-file-for-userspace.patch

