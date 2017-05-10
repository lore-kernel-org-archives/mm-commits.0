From: akpm@linux-foundation.org
Subject: + mark-protection_map-as-__ro_after_init.patch added to -mm tree
Date: Wed, 10 May 2017 13:42:33 -0700
Message-ID: <59137b39.SOEkiZYIPbOIvzMB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932073AbdEJUmj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 16:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danielmicay@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: mark protection_map as __ro_after_init
has been added to the -mm tree.  Its filename is
     mark-protection_map-as-__ro_after_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mark-protection_map-as-__ro_after_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mark-protection_map-as-__ro_after_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mark-protection_map-as-__ro_after_init.patch

