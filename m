From: akpm@linux-foundation.org
Subject: [merged]
 x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet.patch removed
 from -mm tree
Date: Tue, 27 May 2014 13:22:33 -0700
Message-ID: <5384f409.ApyS+w582d6ZdvMI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaE0UWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 16:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, stefani@seibold.net, stable@vger.kernel.org, sasha.levin@oracle.com, mingo@elte.hu, hpa@linux.intel.com, luto@amacapital.net

Subject: [merged] x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet.patch removed from -mm tree
To: luto@amacapital.net,hpa@linux.intel.com,mingo@elte.hu,sasha.levin@oracle.com,stable@vger.kernel.org,stefani@seibold.net,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 13:22:33 -0700


The patch titled
     Subject: x86,vdso: fix an OOPS accessing the hpet mapping w/o an hpet
has been removed from the -mm tree.  Its filename was
     x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@amacapital.net>
Subject: x86,vdso: fix an OOPS accessing the hpet mapping w/o an hpet

The oops can be triggered in qemu using -no-hpet (but not nohpet) by
reading a couple of pages past the end of the vdso text.  This should send
SIGBUS instead of OOPSing.

The bug was introduced by:

commit 7a59ed415f5b57469e22e41fc4188d5399e0b194
Author: Stefani Seibold <stefani@seibold.net>
Date:   Mon Mar 17 23:22:09 2014 +0100

    x86, vdso: Add 32 bit VDSO time support for 32 bit kernel

which is new in 3.15.

This will be fixed separately in 3.15, but that patch will not apply to
tip/x86/vdso.  This is the equivalent fix for tip/x86/vdso and,
presumably, 3.16.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: <stable@vger.kernel.org>	[needs rework for 3.15 and earlier]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/vdso/vma.c~x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet arch/x86/vdso/vma.c
--- a/arch/x86/vdso/vma.c~x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet
+++ a/arch/x86/vdso/vma.c
@@ -90,6 +90,7 @@ static int map_vdso(const struct vdso_im
 	struct vm_area_struct *vma;
 	unsigned long addr;
 	int ret = 0;
+	static struct page *no_pages[] = {NULL};
 
 	if (calculate_addr) {
 		addr = vdso_addr(current->mm->start_stack,
@@ -125,7 +126,7 @@ static int map_vdso(const struct vdso_im
 				       addr + image->size,
 				       image->sym_end_mapping - image->size,
 				       VM_READ,
-				       NULL);
+				       no_pages);
 
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
_

Patches currently in -mm which might be from luto@amacapital.net are

linux-next.patch

