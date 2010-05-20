From: akpm@linux-foundation.org
Subject: + kcore-add-_text-to-kcore_text.patch added to -mm tree
Date: Thu, 20 May 2010 13:34:54 -0700
Message-ID: <201005202034.o4KKYsJR003491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932133Ab0ETUfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 16:35:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     kcore: add _text to KCORE_TEXT
has been added to the -mm tree.  Its filename is
     kcore-add-_text-to-kcore_text.patch

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
Subject: kcore: add _text to KCORE_TEXT
From: Wu Fengguang <fengguang.wu@intel.com>

Extend KCORE_TEXT to cover the pages between _text and _stext, to allow
examining some important page table pages.

`readelf -a` output on x86_64 before and after patch:
	  Type           Offset             VirtAddr           PhysAddr
before    LOAD           0x00007fff8100c000 0xffffffff81009000 0x0000000000000000
after     LOAD           0x00007fff81003000 0xffffffff81000000 0x0000000000000000

The newly covered pages are:

	0xffffffff81000000 <startup_64> etc.
	0xffffffff81001000 <init_level4_pgt>
	0xffffffff81002000 <level3_ident_pgt>
	0xffffffff81003000 <level3_kernel_pgt>
	0xffffffff81004000 <level2_fixmap_pgt>
	0xffffffff81005000 <level1_fixmap_pgt>
	0xffffffff81006000 <level2_ident_pgt>
	0xffffffff81007000 <level2_kernel_pgt>
	0xffffffff81008000 <level2_spare_pgt>

Before patch, /proc/kcore shows outdated contents for the above page
table pages, for example:

	(gdb) p level3_ident_pgt
	$1 = {<text variable, no debug info>} 0xffffffff81002000 <level3_ident_pgt>
	(gdb) p/x *((pud_t *)&level3_ident_pgt)@512
	$2 = {{pud = 0x1006063}, {pud = 0x0} <repeats 511 times>}

while the real content is:

	root@hp /home/wfg# hexdump -s 0x1002000 -n 4096 /dev/mem
	1002000 6063 0100 0000 0000 8067 0000 0000 0000
	1002010 0000 0000 0000 0000 0000 0000 0000 0000
	*
	1003000

That is, on a x86_64 box with 2GB memory, we can see first-1GB / full-2GB
identity mapping before/after patch:

	(gdb) p/x *((pud_t *)&level3_ident_pgt)@512
before  $1 = {{pud = 0x1006063}, {pud = 0x0} <repeats 511 times>}
after   $1 = {{pud = 0x1006063}, {pud = 0x8067}, {pud = 0x0} <repeats 510 times>}

Obviously the content before patch is wrong.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~kcore-add-_text-to-kcore_text fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-add-_text-to-kcore_text
+++ a/fs/proc/kcore.c
@@ -588,7 +588,7 @@ static struct kcore_list kcore_text;
  */
 static void __init proc_kcore_text_init(void)
 {
-	kclist_add(&kcore_text, _stext, _end - _stext, KCORE_TEXT);
+	kclist_add(&kcore_text, _text, _end - _text, KCORE_TEXT);
 }
 #else
 static void __init proc_kcore_text_init(void)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vmscan-prevent-get_scan_ratio-rounding-errors.patch
readaheadc-fix-comment.patch
fs-writeback-check-sync-bit-earlier-in-inode_wait_for_writeback.patch
mem-hotplug-separate-setup_per_cpu_pageset-into-separate-functions.patch
mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset.patch
mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset-fix.patch
mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone.patch
kcore-add-_text-to-kcore_text.patch
radix-tree-fix-radix_tree_prev_hole-underflow-case.patch
vfs-add-super-operation-writeback_inodes.patch

