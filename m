From: akpm@linux-foundation.org
Subject: + pagemap-update-documentation.patch added to -mm tree
Date: Thu, 16 Jul 2015 14:19:28 -0700
Message-ID: <55a81fe0.HtoW9ceG/tl0fLmM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbGPVT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jul 2015 17:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, mwilliamson@undo-software.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: update documentation
has been added to the -mm tree.  Its filename is
     pagemap-update-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagemap-update-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagemap-update-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: pagemap: update documentation

Notes about recent changes.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Mark Williamson <mwilliamson@undo-software.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/pagemap.txt~pagemap-update-documentation Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-update-documentation
+++ a/Documentation/vm/pagemap.txt
@@ -16,12 +16,17 @@ There are three components to pagemap:
     * Bits 0-4   swap type if swapped
     * Bits 5-54  swap offset if swapped
     * Bit  55    pte is soft-dirty (see Documentation/vm/soft-dirty.txt)
-    * Bit  56    page exclusively mapped
+    * Bit  56    page exclusively mapped (since 4.2)
     * Bits 57-60 zero
-    * Bit  61    page is file-page or shared-anon
+    * Bit  61    page is file-page or shared-anon (since 3.5)
     * Bit  62    page swapped
     * Bit  63    page present
 
+   Since Linux 4.0 only users with the CAP_SYS_ADMIN capability can get PFNs:
+   for unprivileged users from 4.0 till 4.2 open fails with -EPERM, starting
+   from from 4.2 PFN field is zeroed if user has no CAP_SYS_ADMIN capability.
+   Reason: information about PFNs helps in exploiting Rowhammer vulnerability.
+
    If the page is not present but in swap, then the PFN contains an
    encoding of the swap file number and the page's offset into the
    swap. Unmapped pages return a null PFN. This allows determining
@@ -160,3 +165,8 @@ Other notes:
 Reading from any of the files will return -EINVAL if you are not starting
 the read on an 8-byte boundary (e.g., if you sought an odd number of bytes
 into the file), or if the size of the read is not a multiple of 8 bytes.
+
+Before Linux 3.11 pagemap bits 55-60 were used for "page-shift" (which is
+always 12 at most architectures). Since Linux 3.11 their meaning changes
+after first clear of soft-dirty bits. Since Linux 4.2 they are used for
+flags unconditionally.
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

mm-slub-fix-slab-double-free-in-case-of-duplicate-sysfs-filename.patch
pagemap-check-permissions-and-capabilities-at-open-time.patch
pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
pagemap-rework-hugetlb-and-thp-report.patch
pagemap-hide-physical-addresses-from-non-privileged-users.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation.patch
linux-next.patch

