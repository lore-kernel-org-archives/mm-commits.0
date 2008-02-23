From: akpm@linux-foundation.org
Subject: + m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:29:39 -0800
Message-ID: <200802230730.m1N7US1V017942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbYBWHau (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:30:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org, takata@linux-m32r.org


The patch titled
     m32r: cleanup: drop .data.idt section in vmlinux.lds script
has been added to the -mm tree.  Its filename is
     m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch

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
Subject: m32r: cleanup: drop .data.idt section in vmlinux.lds script
From: Cyrill Gorcunov <gorcunov@gmail.com>

The section .data.idt is not used at all - so drop it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/vmlinux.lds.S |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/m32r/kernel/vmlinux.lds.S~m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S~m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script
+++ a/arch/m32r/kernel/vmlinux.lds.S
@@ -60,9 +60,6 @@ SECTIONS
   . = ALIGN(4096);
   __nosave_end = .;
 
-  . = ALIGN(4096);
-  .data.page_aligned : { *(.data.idt) }
-
   . = ALIGN(32);
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-avr32.patch
git-dvb.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch
