From: akpm@linux-foundation.org
Subject: + x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch added to -mm tree
Date: Fri, 11 May 2007 15:38:33 -0700
Message-ID: <200705112238.l4BMcXeB028527@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbXEKWiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 18:38:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, roland@redhat.com


The patch titled
     x86-use-elfnoteh-to-generate-vsyscall-notes fix
has been added to the -mm tree.  Its filename is
     x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-use-elfnoteh-to-generate-vsyscall-notes fix
From: Jeremy Fitzhardinge <jeremy@goop.org>

Roland McGrath <roland@redhat.com>:
> I used .balign because .align has inconsistent meaning on some platforms
> (matches .p2align instead of .balign).  Using .align in a
> machine-independent file seems questionable.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elfnote.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/elfnote.h~x86-use-elfnoteh-to-generate-vsyscall-notes-fix include/linux/elfnote.h
--- a/include/linux/elfnote.h~x86-use-elfnoteh-to-generate-vsyscall-notes-fix
+++ a/include/linux/elfnote.h
@@ -40,16 +40,16 @@
  */
 #define ELFNOTE_START(name, type, flags)	\
 .pushsection .note.name, flags,@note	;	\
-  .align 4				;	\
+  .balign 4				;	\
   .long 2f - 1f		/* namesz */	;	\
   .long 4484f - 3f	/* descsz */	;	\
   .long type				;	\
 1:.asciz #name				;	\
-2:.align 4				;	\
+2:.balign 4				;	\
 3:
 
 #define ELFNOTE_END				\
-4484:.align 4				;	\
+4484:.balign 4				;	\
 .popsection				;
 
 #define ELFNOTE(name, type, desc)		\
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
loop_probe-fix-return-value.patch
x86-use-elfnoteh-to-generate-vsyscall-notes.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
i386-move-common-parts-of-smp-into-their-own-file.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
add-kstrndup.patch
add-kstrndup-fix.patch
add-argv_split.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
tidy-up-usermode-helper-waiting-a-bit.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
lguest-the-guest-code.patch
