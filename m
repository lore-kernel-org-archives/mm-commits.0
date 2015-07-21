From: akpm@linux-foundation.org
Subject: + mm-mmap-add-mmap-flag-to-request-vm_lockonfault-fix.patch added to -mm tree
Date: Tue, 21 Jul 2015 12:54:51 -0700
Message-ID: <55aea38b.2bw4bRmB1jo4yF21%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbbGUTyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 15:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, emunson@akamai.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: add missing definition of MAP_LOCKONFAULT
has been added to the -mm tree.  Its filename is
     mm-mmap-add-mmap-flag-to-request-vm_lockonfault-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-add-mmap-flag-to-request-vm_lockonfault-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-add-mmap-flag-to-request-vm_lockonfault-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: tile: add missing definition of MAP_LOCKONFAULT

Commit c5827483ad6b ("mm: mmap: add mmap flag to request VM_LOCKONFAULT")
defines and uses MAP_LOCKONFAULT, but does not to add the definition for
the tile architecture. This results in the following build error.

include/linux/mman.h: In function 'calc_vm_flag_bits':
include/linux/mman.h:90:9: error: 'MAP_LOCKONFAULT' undeclared

Fixes: c5827483ad6b ("mm: mmap: add mmap flag to request VM_LOCKONFAULT")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/uapi/asm/mman.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/tile/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault-fix arch/tile/include/uapi/asm/mman.h
--- a/arch/tile/include/uapi/asm/mman.h~mm-mmap-add-mmap-flag-to-request-vm_lockonfault-fix
+++ a/arch/tile/include/uapi/asm/mman.h
@@ -29,7 +29,7 @@
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
 #define MAP_HUGETLB	0x4000		/* create a huge page mapping */
