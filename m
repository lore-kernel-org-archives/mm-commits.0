From: akpm@linux-foundation.org
Subject: + devmem-fix-kmem-write-bug-on-memory-holes.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:43:09 -0800
Message-ID: <201001270043.o0R0h9Oh000533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787Ab0A0AoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi@firstfloor.org, benh@kernel.crashing.org, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, npiggin@suse.de, stable@kernel.org, tj@kernel.org


The patch titled
     devmem: fix kmem write bug on memory holes
has been added to the -mm tree.  Its filename is
     devmem-fix-kmem-write-bug-on-memory-holes.patch

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
Subject: devmem: fix kmem write bug on memory holes
From: Wu Fengguang <fengguang.wu@intel.com>

write_kmem() used to assume vwrite() always return the full buffer length.
 However now vwrite() could return 0 to indicate memory hole.  This
creates a bug that "buf" is not advanced accordingly.

Fix it to simply ignore the return value, hence the memory hole.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mem.c~devmem-fix-kmem-write-bug-on-memory-holes drivers/char/mem.c
--- a/drivers/char/mem.c~devmem-fix-kmem-write-bug-on-memory-holes
+++ a/drivers/char/mem.c
@@ -555,7 +555,7 @@ static ssize_t write_kmem(struct file * 
 				err = -EFAULT;
 				break;
 			}
-			sz = vwrite(kbuf, (char *)p, sz);
+			vwrite(kbuf, (char *)p, sz);
 			count -= sz;
 			buf += sz;
 			virtr += sz;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
devmem-check-vmalloc-address-on-kmem-read-write.patch
devmem-fix-kmem-write-bug-on-memory-holes.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
resources-introduce-generic-page_is_ram.patch
resources-introduce-generic-page_is_ram-fix.patch
x86-remove-bios-data-range-from-e820.patch
x86-use-the-generic-page_is_ram.patch
vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch
readahead-introduce-fmode_random-for-posix_fadv_random.patch

