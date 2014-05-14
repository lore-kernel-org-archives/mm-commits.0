From: akpm@linux-foundation.org
Subject: +
 x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet.patch added to
 -mm tree
Date: Wed, 14 May 2014 16:18:33 -0700
Message-ID: <5373f9c9.Tc8ldHAGeB0kFFMo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaENXSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 19:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, stable@vger.kernel.org, sasha.levin@oracle.com, mingo@elte.hu, hpa@linux.intel.com, luto@amacapital.net

Subject: + x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet.patch added to -mm tree
To: luto@amacapital.net,hpa@linux.intel.com,mingo@elte.hu,sasha.levin@oracle.com,stable@vger.kernel.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 16:18:33 -0700


The patch titled
     Subject: x86,vdso: fix an OOPS accessing the hpet mapping w/o an hpet
has been added to the -mm tree.  Its filename is
     x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Lutomirski <luto@amacapital.net>
Subject: x86,vdso: fix an OOPS accessing the hpet mapping w/o an hpet

The access should fail, but it shouldn't oops.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>	[needs rework for 3.15 and earlier]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86/vdso/vma.c~x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet arch/x86/vdso/vma.c
--- a/arch/x86/vdso/vma.c~x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet
+++ a/arch/x86/vdso/vma.c
@@ -84,6 +84,8 @@ static unsigned long vdso_addr(unsigned
 	return addr;
 }
 
+static struct page *no_pages[] = {NULL};
+
 static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 {
 	struct mm_struct *mm = current->mm;
@@ -125,7 +127,7 @@ static int map_vdso(const struct vdso_im
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
x86vdso-fix-an-oops-accessing-the-hpet-mapping-w-o-an-hpet.patch

