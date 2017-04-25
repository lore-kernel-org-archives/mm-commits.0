From: akpm@linux-foundation.org
Subject: + mm-gup-fix-access_ok-argument-type.patch added to -mm tree
Date: Tue, 25 Apr 2017 14:32:12 -0700
Message-ID: <58ffc05c.Dpnj/ObkDRgBKhnH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2993737AbdDYVcO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 17:32:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, kirill.shutemov@linux.intel.com, lstoakes@gmail.com, mhocko@suse.com, mingo@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: fix access_ok() argument type
has been added to the -mm tree.  Its filename is
     mm-gup-fix-access_ok-argument-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fix-access_ok-argument-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fix-access_ok-argument-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/gup.c: fix access_ok() argument type

MIPS just got changed to only accept a pointer argument for access_ok(),
causing one warning in drivers/scsi/pmcraid.c.  I tried changing x86 the
same way and found the same warning in __get_user_pages_fast() and nowhere
else in the kernel during randconfig testing:

mm/gup.c: In function '__get_user_pages_fast':
mm/gup.c:1578:6: error: passing argument 1 of '__chk_range_not_ok' makes pointer from integer without a cast [-Werror=int-conversion]

It would probably be a good idea to enforce type-safety in general, so
let's change this file to not cause a warning if we do that.

I don't know why the warning did not appear on MIPS.

Fixes: 2667f50e8b81 ("mm: introduce a general RCU get_user_pages_fast()")
Link: http://lkml.kernel.org/r/20170421162659.3314521-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/gup.c~mm-gup-fix-access_ok-argument-type mm/gup.c
--- a/mm/gup.c~mm-gup-fix-access_ok-argument-type
+++ a/mm/gup.c
@@ -1481,7 +1481,7 @@ int __get_user_pages_fast(unsigned long
 	end = start + len;
 
 	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
-					start, len)))
+					(void __user *)start, len)))
 		return 0;
 
 	/*
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-gup-fix-access_ok-argument-type.patch
initramfs-use-vfs_stat-lstat-directly.patch

