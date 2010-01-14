From: akpm@linux-foundation.org
Subject: + memory-hotplug-add-0x-prefix-to-hex-block_size_bytes.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:30:34 -0800
Message-ID: <201001142330.o0ENUYdD006193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859Ab0ANXbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:31:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi@firstfloor.org, greg@kroah.com


The patch titled
     memory-hotplug: add 0x prefix to HEX block_size_bytes
has been added to the -mm tree.  Its filename is
     memory-hotplug-add-0x-prefix-to-hex-block_size_bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory-hotplug: add 0x prefix to HEX block_size_bytes
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory-hotplug-add-0x-prefix-to-hex-block_size_bytes drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-0x-prefix-to-hex-block_size_bytes
+++ a/drivers/base/memory.c
@@ -311,7 +311,7 @@ static SYSDEV_ATTR(removable, 0444, show
 static ssize_t
 print_block_size(struct class *class, char *buf)
 {
-	return sprintf(buf, "%lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
+	return sprintf(buf, "%#lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
 }
 
 static CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch
memory-hotplug-add-0x-prefix-to-hex-block_size_bytes.patch
sysdev-fix-prototype-for-memory_sysdev_class-show-store-functions.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch

