From: akpm@linux-foundation.org
Subject: + firmware-memmap-avoid-type-conflicts-with-the-generic-memmap_init.patch added to -mm tree
Date: Mon, 15 Oct 2012 15:21:08 -0700
Message-ID: <20121015222108.A7DAB1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64114 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2JOWVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Oct 2012 18:21:09 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so283617qae.1
        for <mm-commits@vger.kernel.org>; Mon, 15 Oct 2012 15:21:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, bwalle@suse.de, glommer@parallels.com


The patch titled
     Subject: firmware/memmap: avoid type conflicts with the generic memmap_init()
has been added to the -mm tree.  Its filename is
     firmware-memmap-avoid-type-conflicts-with-the-generic-memmap_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: firmware/memmap: avoid type conflicts with the generic memmap_init()

This will fix build error:

drivers/firmware/memmap.c:240:19: error: conflicting types for 'memmap_init'
arch/ia64/include/asm/pgtable.h:565:17: note: previous declaration of 'memmap_init' was here

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Bernhard Walle <bwalle@suse.de>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/memmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/memmap.c~firmware-memmap-avoid-type-conflicts-with-the-generic-memmap_init drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~firmware-memmap-avoid-type-conflicts-with-the-generic-memmap_init
+++ a/drivers/firmware/memmap.c
@@ -237,7 +237,7 @@ static ssize_t memmap_attr_show(struct k
  * firmware_map_add() or firmware_map_add_early() afterwards, the entries
  * are not added to sysfs.
  */
-static int __init memmap_init(void)
+static int __init firmware_memmap_init(void)
 {
 	struct firmware_map_entry *entry;
 
@@ -246,5 +246,5 @@ static int __init memmap_init(void)
 
 	return 0;
 }
-late_initcall(memmap_init);
+late_initcall(firmware_memmap_init);
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
linux-coredumph-needs-asm-siginfoh.patch
firmware-memmap-avoid-type-conflicts-with-the-generic-memmap_init.patch
h8300-select-generic-atomic64_t-support.patch
writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

