From: akpm@linux-foundation.org
Subject: + drivers-memstick-core-mspro_block-use-kmemdup-fix.patch added
 to -mm tree
Date: Mon, 23 May 2016 15:15:49 -0700
Message-ID: <57438115.CNci0jIP1Ot+lB45%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbcEWWPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 18:15:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, falakreyaz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-memstick-core-mspro_block-use-kmemdup-fix
has been added to the -mm tree.  Its filename is
     drivers-memstick-core-mspro_block-use-kmemdup-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-memstick-core-mspro_block-use-kmemdup-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-memstick-core-mspro_block-use-kmemdup-fix.patch

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
Subject: drivers-memstick-core-mspro_block-use-kmemdup-fix

remove unneeded cast to void*

Cc: Muhammad Falak R Wani <falakreyaz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/mspro_block.c~drivers-memstick-core-mspro_block-use-kmemdup-fix drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~drivers-memstick-core-mspro_block-use-kmemdup-fix
+++ a/drivers/memstick/core/mspro_block.c
@@ -1033,7 +1033,7 @@ static int mspro_block_read_attributes(s
 	}
 	msb->attr_group.name = "media_attributes";
 
-	buffer = kmemdup((char *)attr, attr_len, GFP_KERNEL);
+	buffer = kmemdup(attr, attr_len, GFP_KERNEL);
 	if (!buffer) {
 		rc = -ENOMEM;
 		goto out_free_attr;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch
drivers-memstick-core-mspro_block-use-kmemdup-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

