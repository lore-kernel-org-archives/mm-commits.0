From: akpm@linux-foundation.org
Subject: [folded-merged] mm-introduce-get_user_pages_longterm-fix.patch
 removed from -mm tree
Date: Wed, 29 Nov 2017 16:06:31 -0800
Message-ID: <5a1f4b87.4tFU8yL+/4hmqVb3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60012 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752838AbdK3AGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:06:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-get_user_pages_longterm-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-get_user_pages_longterm-fix.patch

This patch was dropped because it was folded into mm-introduce-get_user_pages_longterm.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-get_user_pages_longterm-fix

use kcalloc()

Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/gup.c~mm-introduce-get_user_pages_longterm-fix mm/gup.c
--- a/mm/gup.c~mm-introduce-get_user_pages_longterm-fix
+++ a/mm/gup.c
@@ -1120,8 +1120,8 @@ long get_user_pages_longterm(unsigned lo
 		return -EINVAL;
 
 	if (!vmas) {
-		vmas = kzalloc(sizeof(struct vm_area_struct *) * nr_pages,
-				GFP_KERNEL);
+		vmas = kcalloc(nr_pages, sizeof(struct vm_area_struct *),
+			       GFP_KERNEL);
 		if (!vmas)
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-introduce-get_user_pages_longterm.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

