From: akpm@linux-foundation.org
Subject: + mm-add-utility-for-early-copy-from-unmapped-ram-v4.patch added
 to -mm tree
Date: Mon, 17 Aug 2015 13:19:21 -0700
Message-ID: <55d241c9.DN+pU1WDkUbWAFvg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbbHQUTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 16:19:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-utility-for-early-copy-from-unmapped-ram-v4
has been added to the -mm tree.  Its filename is
     mm-add-utility-for-early-copy-from-unmapped-ram-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-utility-for-early-copy-from-unmapped-ram-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-utility-for-early-copy-from-unmapped-ram-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: mm-add-utility-for-early-copy-from-unmapped-ram-v4

Fixed sparse warning in copy_from_early_mem()

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/early_ioremap.c~mm-add-utility-for-early-copy-from-unmapped-ram-v4 mm/early_ioremap.c
--- a/mm/early_ioremap.c~mm-add-utility-for-early-copy-from-unmapped-ram-v4
+++ a/mm/early_ioremap.c
@@ -232,7 +232,7 @@ void __init copy_from_early_mem(void *de
 			clen = MAX_MAP_CHUNK - slop;
 		p = early_memremap(src & PAGE_MASK, clen + slop);
 		memcpy(dest, p + slop, clen);
-		early_iounmap(p, clen + slop);
+		early_memunmap(p, clen + slop);
 		dest += clen;
 		src += clen;
 		size -= clen;
_

Patches currently in -mm which might be from msalter@redhat.com are

mm-add-utility-for-early-copy-from-unmapped-ram.patch
mm-add-utility-for-early-copy-from-unmapped-ram-v4.patch
arm64-support-initrd-outside-kernel-linear-map.patch
arm64-support-initrd-outside-kernel-linear-map-v4.patch
x86-use-generic-early-mem-copy.patch
x86-use-generic-early-mem-copy-fix.patch
linux-next.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch

