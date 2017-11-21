From: akpm@linux-foundation.org
Subject: + mm-introduce-get_user_pages_longterm-fix.patch added to -mm
 tree
Date: Tue, 21 Nov 2017 15:13:25 -0800
Message-ID: <5a14b315.on5PbkJ99yodpyt9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39168 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdKUXN0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 18:13:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-get_user_pages_longterm-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-get_user_pages_longterm-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-get_user_pages_longterm-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-get_user_pages_longterm-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-introduce-get_user_pages_longterm-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

