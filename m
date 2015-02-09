From: akpm@linux-foundation.org
Subject: + mm-actually-remap-enough-memory.patch added to -mm tree
Date: Mon, 09 Feb 2015 13:24:00 -0800
Message-ID: <54d92570.7u1wJP8SwxftoJym%akpm__9051.24193891442$1423517049$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760736AbbBIVYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2015 16:24:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: notasas@gmail.com, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: actually remap enough memory
has been added to the -mm tree.  Its filename is
     mm-actually-remap-enough-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-actually-remap-enough-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-actually-remap-enough-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Grazvydas Ignotas <notasas@gmail.com>
Subject: mm/memory.c: actually remap enough memory

For whatever reason, generic_access_phys() only remaps one page, but
actually allows to access arbitrary size.  It's quite easy to trigger
large reads, like printing out large structure with gdb, which leads to a
crash.  Fix it by remapping correct size.

Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-actually-remap-enough-memory mm/memory.c
--- a/mm/memory.c~mm-actually-remap-enough-memory
+++ a/mm/memory.c
@@ -3460,7 +3460,7 @@ int generic_access_phys(struct vm_area_s
 	if (follow_phys(vma, addr, write, &prot, &phys_addr))
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
+	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
 	if (write)
 		memcpy_toio(maddr + offset, buf, len);
 	else
_

Patches currently in -mm which might be from notasas@gmail.com are

mm-actually-remap-enough-memory.patch

