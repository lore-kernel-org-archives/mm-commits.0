From: akpm@linux-foundation.org
Subject: [merged] mark-protection_map-as-__ro_after_init.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:08:11 -0700
Message-ID: <20170707190811.THKB2msVF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdGGTIM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danielmicay@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: mark protection_map as __ro_after_init
has been removed from the -mm tree.  Its filename was
     mark-protection_map-as-__ro_after_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Micay <danielmicay@gmail.com>
Subject: mm/mmap.c: mark protection_map as __ro_after_init

The protection map is only modified by per-arch init code so it can be
protected from writes after the init code runs.

This change was extracted from PaX where it's part of KERNEXEC.

Link: http://lkml.kernel.org/r/20170510174441.26163-1-danielmicay@gmail.com
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mark-protection_map-as-__ro_after_init mm/mmap.c
--- a/mm/mmap.c~mark-protection_map-as-__ro_after_init
+++ a/mm/mmap.c
@@ -94,7 +94,7 @@ static void unmap_region(struct mm_struc
  *								w: (no) no
  *								x: (yes) yes
  */
-pgprot_t protection_map[16] = {
+pgprot_t protection_map[16] __ro_after_init = {
 	__P000, __P001, __P010, __P011, __P100, __P101, __P110, __P111,
 	__S000, __S001, __S010, __S011, __S100, __S101, __S110, __S111
 };
_

Patches currently in -mm which might be from danielmicay@gmail.com are

include-linux-stringh-add-the-option-of-fortified-stringh-functions.patch

