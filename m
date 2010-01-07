From: akpm@linux-foundation.org
Subject: + nommu-use-copy__user_page-in-access_process_vm.patch added to -mm tree
Date: Wed, 06 Jan 2010 16:23:24 -0800
Message-ID: <201001070023.o070NO5Z027428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932422Ab0AGAXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 19:23:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jie.zhang@analog.com, david_mccullough@mcafee.com, dhowells@redhat.com, gerg@uclinux.org, lethal@linux-sh.org, vapier@gentoo.org


The patch titled
     nommu: use copy_*_user_page() in access_process_vm()
has been added to the -mm tree.  Its filename is
     nommu-use-copy__user_page-in-access_process_vm.patch

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
Subject: nommu: use copy_*_user_page() in access_process_vm()
From: Jie Zhang <jie.zhang@analog.com>

The MMU code uses the copy_*_user_page() variants in access_process_vm()
rather than copy_*_user() as the former includes an icache flush.  This is
important when doing things like setting software breakpoints with gdb. 
So switch the NOMMU code over to do the same.

This patch makes the reasonable assumption that copy_from_user_page()
won't fail - which is probably fine, as we've checked the VMA from which
we're copying is usable, and the copy is not allowed to cross VMAs.  The
one case where it might go wrong is if the VMA is a device rather than
RAM, and that device returns an error which - in which case rubbish will
be returned rather than EIO.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: David McCullough <david_mccullough@mcafee.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/nommu.c~nommu-use-copy__user_page-in-access_process_vm mm/nommu.c
--- a/mm/nommu.c~nommu-use-copy__user_page-in-access_process_vm
+++ a/mm/nommu.c
@@ -1921,9 +1921,11 @@ int access_process_vm(struct task_struct
 
 		/* only read or write mappings where it is permitted */
 		if (write && vma->vm_flags & VM_MAYWRITE)
-			len -= copy_to_user((void *) addr, buf, len);
+			copy_to_user_page(vma, NULL, addr,
+					 (void *) addr, buf, len);
 		else if (!write && vma->vm_flags & VM_MAYREAD)
-			len -= copy_from_user(buf, (void *) addr, len);
+			copy_from_user_page(vma, NULL, addr,
+					    buf, (void *) addr, len);
 		else
 			len = 0;
 	} else {
_

Patches currently in -mm which might be from jie.zhang@analog.com are

fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack.patch
nommu-avoiding-duplicate-icache-flushes-of-shared-maps.patch
nommu-use-copy__user_page-in-access_process_vm.patch

