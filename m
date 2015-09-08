From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-add-utility-for-early-copy-from-unmapped-ram-v4.patch removed from -mm
 tree
Date: Tue, 08 Sep 2015 14:43:46 -0700
Message-ID: <55ef5692.h3HCnnKcGnFM8av4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbbIHVnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-utility-for-early-copy-from-unmapped-ram-v4
has been removed from the -mm tree.  Its filename was
     mm-add-utility-for-early-copy-from-unmapped-ram-v4.patch

This patch was dropped because it was folded into mm-add-utility-for-early-copy-from-unmapped-ram.patch

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
arm64-support-initrd-outside-kernel-linear-map.patch
arm64-support-initrd-outside-kernel-linear-map-v4.patch
x86-use-generic-early-mem-copy.patch

