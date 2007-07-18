From: akpm@linux-foundation.org
Subject: - x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:40 -0700
Message-ID: <200707181852.l6IIqeoA023697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46830 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934809AbXGRSzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     x86-use-elfnoteh-to-generate-vsyscall-notes fix
has been removed from the -mm tree.  Its filename was
     x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-use-elfnoteh-to-generate-vsyscall-notes fix
From: Jeremy Fitzhardinge <jeremy@goop.org>

A fix against xencleanup-use-elfnote_h-to-generate-vsyscall-notes.patch

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
fix-the-softlockup-watchdog-to-actually-work.patch
git-kbuild.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-xen-event-channels.patch
i386-minor-nx-handling-adjustment.patch
x86-fix-iounmaps-use-of-vm_structs-size-field.patch
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
lguest-the-guest-code.patch
