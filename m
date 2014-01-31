From: akpm@linux-foundation.org
Subject: +
 vmcore-prevent-pt_note-p_memsz-overflow-during-header-update.patch added to -mm tree
Date: Fri, 31 Jan 2014 15:14:24 -0800
Message-ID: <52ec2e50.fUXA6vZCOe8BT4ja%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129AbaAaXOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 18:14:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, holzheu@linux.vnet.ibm.com, d.hatayama@jp.fujitsu.com, greg.pearson@hp.com

Subject: + vmcore-prevent-pt_note-p_memsz-overflow-during-header-update.patch added to -mm tree
To: greg.pearson@hp.com,d.hatayama@jp.fujitsu.com,holzheu@linux.vnet.ibm.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 15:14:24 -0800


The patch titled
     Subject: vmcore: prevent PT_NOTE p_memsz overflow during header update
has been added to the -mm tree.  Its filename is
     vmcore-prevent-pt_note-p_memsz-overflow-during-header-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmcore-prevent-pt_note-p_memsz-overflow-during-header-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmcore-prevent-pt_note-p_memsz-overflow-during-header-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Pearson <greg.pearson@hp.com>
Subject: vmcore: prevent PT_NOTE p_memsz overflow during header update

Currently, update_note_header_size_elf64() and
update_note_header_size_elf32() will add the size of a PT_NOTE entry to
real_sz even if that causes real_sz to exceeds max_sz.  This patch
corrects the while loop logic in those routines to ensure that does not
happen.

One possible negative side effect of exceeding the max_sz limit is an
allocation failure in merge_note_headers_elf64() or
merge_note_headers_elf32() which would produce console output such as the
following while booting the crash kernel.

vmalloc: allocation failure: 14076997632 bytes
swapper/0: page allocation failure: order:0, mode:0x80d2
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-gbp1 #7
ffffffff817dcc30 ffff88003025fc28 ffffffff815bdb0b ffff88003025fcb0
ffffffff8113b3d0 ffffffff817dcc30 ffff88003025fc48 ffffc90000000018
ffff88003025fcc0 ffff88003025fc60 ffff88003025fc80 ffff88002b5df980
Call Trace:
[<ffffffff815bdb0b>] dump_stack+0x19/0x1b
[<ffffffff8113b3d0>] warn_alloc_failed+0xf0/0x160
[<ffffffff81a1267d>] ? merge_note_headers_elf64.constprop.9+0x116/0x24a
[<ffffffff8116d34e>] __vmalloc_node_range+0x19e/0x250
[<ffffffff81210454>] ? read_from_oldmem.part.0+0xa4/0xe0
[<ffffffff8116d4ec>] vmalloc_user+0x4c/0x70
[<ffffffff81a1267d>] ? merge_note_headers_elf64.constprop.9+0x116/0x24a
[<ffffffff81a1267d>] merge_note_headers_elf64.constprop.9+0x116/0x24a
[<ffffffff81a12cce>] vmcore_init+0x2d4/0x76c
[<ffffffff8120f9f0>] ? kcore_update_ram+0x1f0/0x1f0
[<ffffffff81063b92>] ? walk_system_raange+0x112/0x130
[<ffffffff81a129fa>] ? merge_note_headers_elf32.constprop.8+0x249/0x249
[<ffffffff810020e2>] do_one_initcall+0xe2/0x190
[<ffffffff819e20c4>] kernel_init_freeable+0x17c/0x207
[<ffffffff819e18d0>] ? do_early_param+0x88/0x88
[<ffffffff815a0d20>] ? rest_init+0x80/0x80
[<ffffffff815a0d2e>] kernel_init+0xe/0x180
[<ffffffff815cd8ac>] ret_from_fork+0x7c/0xb0
[<ffffffff815a0d20>] ? rest_init+0x80/0x80

Kdump: vmcore not initialized

kdump: dump target is /dev/sda4
kdump: saving to /sysroot//var/crash/127.0.0.1-2014.01.28-13:58:52/
kdump: saving vmcore-dmesg.txt
Cannot open /proc/vmcore: No such file or directory
kdump: saving vmcore-dmesg.txt failed
kdump: saving vmcore
kdump: saving vmcore failed

This type of failure has been seen on a four socket prototype
system with certain memory configurations. Most PT_NOTE sections
have a single entry similar to:

  n_namesz = 0x5
  n_descsz = 0x150
  n_type   = 0x1

Occasionally, a second entry is encountered with very
large n_namesz and n_descsz sizes:

  n_namesz = 0x80000008
  n_descsz = 0x510ae163
  n_type   = 0x80000008

Not yet sure of the source of these extra entries, they
seem bogus, but they shouldn't cause crash dump to fail.

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-prevent-pt_note-p_memsz-overflow-during-header-update fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-prevent-pt_note-p_memsz-overflow-during-header-update
+++ a/fs/proc/vmcore.c
@@ -468,12 +468,13 @@ static int __init update_note_header_siz
 			return rc;
 		}
 		nhdr_ptr = notes_section;
-		while (real_sz < max_sz) {
-			if (nhdr_ptr->n_namesz == 0)
-				break;
+		while (nhdr_ptr->n_namesz != 0) {
 			sz = sizeof(Elf64_Nhdr) +
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
+			/* Silently drop further PT_NOTE entries */
+			if ((real_sz + sz) > max_sz)
+				break;
 			real_sz += sz;
 			nhdr_ptr = (Elf64_Nhdr*)((char*)nhdr_ptr + sz);
 		}
@@ -648,12 +649,13 @@ static int __init update_note_header_siz
 			return rc;
 		}
 		nhdr_ptr = notes_section;
-		while (real_sz < max_sz) {
-			if (nhdr_ptr->n_namesz == 0)
-				break;
+		while (nhdr_ptr->n_namesz != 0) {
 			sz = sizeof(Elf32_Nhdr) +
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
+			/* Silently drop further PT_NOTE entries */
+			if ((real_sz + sz) > max_sz)
+				break;
 			real_sz += sz;
 			nhdr_ptr = (Elf32_Nhdr*)((char*)nhdr_ptr + sz);
 		}
_

Patches currently in -mm which might be from greg.pearson@hp.com are

vmcore-prevent-pt_note-p_memsz-overflow-during-header-update.patch

