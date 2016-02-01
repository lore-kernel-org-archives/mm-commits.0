From: akpm@linux-foundation.org
Subject: [merged]
 fs-block-force-direct-i-o-for-dax-enabled-block-devices.patch removed from
 -mm tree
Date: Mon, 01 Feb 2016 13:11:19 -0800
Message-ID: <56afc9f7.+5TrFFPCX7wwqZJs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbcBAVLU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 16:11:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dvyukov@google.com, jack@suse.cz, kirill@shutemov.name, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, block: force direct-I/O for dax-enabled block devices
has been removed from the -mm tree.  Its filename was
     fs-block-force-direct-i-o-for-dax-enabled-block-devices.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: fs, block: force direct-I/O for dax-enabled block devices

Similar to the file I/O path, re-direct all I/O to the DAX path for I/O=
 to
a block-device special file.=A0=A0Both regular files and device special=
 files
can use the common filp->f_mapping->host lookup to determing is DAX is
enabled.

Otherwise, we confuse the DAX code that does not expect to find live
data in the page cache:

=A0=A0=A0=A0------------[ cut here ]------------
=A0=A0=A0=A0WARNING: CPU: 0 PID: 7676 at mm/filemap.c:217
=A0=A0=A0=A0__delete_from_page_cache+0x9f6/0xb60()
=A0=A0=A0=A0Modules linked in:
=A0=A0=A0=A0CPU: 0 PID: 7676 Comm: a.out Not tainted 4.4.0+ #276
=A0=A0=A0=A0Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS=
 Bochs 01/01/2011
=A0=A0=A0=A0=A000000000ffffffff ffff88006d3f7738 ffffffff82999e2d 00000=
00000000000
=A0=A0=A0=A0=A0ffff8800620a0000 ffffffff86473d20 ffff88006d3f7778 fffff=
fff81352089
=A0=A0=A0=A0=A0ffffffff81658d36 ffffffff86473d20 00000000000000d9 ffffe=
a0000009d60
=A0=A0=A0=A0Call Trace:
=A0=A0=A0=A0=A0[<=A0=A0=A0=A0=A0inline=A0=A0=A0=A0=A0>] __dump_stack li=
b/dump_stack.c:15
=A0=A0=A0=A0=A0[<ffffffff82999e2d>] dump_stack+0x6f/0xa2 lib/dump_stack=
=2Ec:50
=A0=A0=A0=A0=A0[<ffffffff81352089>] warn_slowpath_common+0xd9/0x140 ker=
nel/panic.c:482
=A0=A0=A0=A0=A0[<ffffffff813522b9>] warn_slowpath_null+0x29/0x30 kernel=
/panic.c:515
=A0=A0=A0=A0=A0[<ffffffff81658d36>] __delete_from_page_cache+0x9f6/0xb6=
0 mm/filemap.c:217
=A0=A0=A0=A0=A0[<ffffffff81658fb2>] delete_from_page_cache+0x112/0x200 =
mm/filemap.c:244
=A0=A0=A0=A0=A0[<ffffffff818af369>] __dax_fault+0x859/0x1800 fs/dax.c:4=
87
=A0=A0=A0=A0=A0[<ffffffff8186f4f6>] blkdev_dax_fault+0x26/0x30 fs/block=
_dev.c:1730
=A0=A0=A0=A0=A0[<=A0=A0=A0=A0=A0inline=A0=A0=A0=A0=A0>] wp_pfn_shared m=
m/memory.c:2208
=A0=A0=A0=A0=A0[<ffffffff816e9145>] do_wp_page+0xc85/0x14f0 mm/memory.c=
:2307
=A0=A0=A0=A0=A0[<=A0=A0=A0=A0=A0inline=A0=A0=A0=A0=A0>] handle_pte_faul=
t mm/memory.c:3323
=A0=A0=A0=A0=A0[<=A0=A0=A0=A0=A0inline=A0=A0=A0=A0=A0>] __handle_mm_fau=
lt mm/memory.c:3417
=A0=A0=A0=A0=A0[<ffffffff816ecec3>] handle_mm_fault+0x2483/0x4640 mm/me=
mory.c:3446
=A0=A0=A0=A0=A0[<ffffffff8127eff6>] __do_page_fault+0x376/0x960 arch/x8=
6/mm/fault.c:1238
=A0=A0=A0=A0=A0[<ffffffff8127f738>] trace_do_page_fault+0xe8/0x420 arch=
/x86/mm/fault.c:1331
=A0=A0=A0=A0=A0[<ffffffff812705c4>] do_async_page_fault+0x14/0xd0 arch/=
x86/kernel/kvm.c:264
=A0=A0=A0=A0=A0[<ffffffff86338f78>] async_page_fault+0x28/0x30 arch/x86=
/entry/entry_64.S:986
=A0=A0=A0=A0=A0[<ffffffff86336c36>] entry_SYSCALL_64_fastpath+0x16/0x7a
=A0=A0=A0=A0arch/x86/entry/entry_64.S:185
=A0=A0=A0=A0---[ end trace dae21e0f85f1f98c ]---

=46ixes: 5a023cdba50c ("block: enable dax for raw block devices")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Suggested-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~fs-block-force-direct-i-o-for-dax-enabled-=
block-devices include/linux/fs.h
--- a/include/linux/fs.h~fs-block-force-direct-i-o-for-dax-enabled-bloc=
k-devices
+++ a/include/linux/fs.h
@@ -2907,7 +2907,7 @@ extern void replace_mount_options(struct
=20
 static inline bool io_is_direct(struct file *filp)
 {
-	return (filp->f_flags & O_DIRECT) || IS_DAX(file_inode(filp));
+	return (filp->f_flags & O_DIRECT) || IS_DAX(filp->f_mapping->host);
 }
=20
 static inline int iocb_flags(struct file *file)
_

Patches currently in -mm which might be from dan.j.williams@intel.com a=
re

phys_to_pfn_t-use-phys_addr_t.patch
mm-fix-pfn_t-to-page-conversion-in-vm_insert_mixed.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
