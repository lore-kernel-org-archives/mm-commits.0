From: akpm@linux-foundation.org
Subject: [merged] resource-fix-the-case-of-null-pointer-access.patch
 removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:19 -0700
Message-ID: <5407567f.S89q9VnZiYoTWdim%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaICR5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, richard@nod.at, sahne@0x90.at, toralf.foerster@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: resource: fix the case of null pointer access
has been removed from the -mm tree.  Its filename was
     resource-fix-the-case-of-null-pointer-access.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Vivek Goyal <vgoyal@redhat.com>
Subject: resource: fix the case of null pointer access

Richard and Daniel reported that UML is broken due to changes to resour=
ce
traversal functions.  Problem is that iomem_resource.child can be null =
and
new code does not consider that possibility.  Old code used a for loop =
and
that loop will not even execute if p was null.

Revert back to for() loop logic and bail out if p is null.

I also moved sibling_only check out of resource_lock. There is no
reason to keep it inside the lock.

=46ollowing is backtrace of the UML crash.

RIP: 0033:[<0000000060039b9f>]
RSP: 0000000081459da0  EFLAGS: 00010202
RAX: 0000000000000000 RBX: 00000000219b3fff RCX: 000000006010d1d9
RDX: 0000000000000001 RSI: 00000000602dfb94 RDI: 0000000081459df8
RBP: 0000000081459de0 R08: 00000000601b59f4 R09: ffffffff0000ff00
R10: ffffffff0000ff00 R11: 0000000081459e88 R12: 0000000081459df8
R13: 00000000219b3fff R14: 00000000602dfb94 R15: 0000000000000000
Kernel panic - not syncing: Segfault with no mm
CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-10454-g58d08e3 #13
Stack:
 00000000 000080d0 81459df0 219b3fff
 81459e70 6010d1d9 ffffffff 6033e010
 81459e50 6003a269 81459e30 00000000
Call Trace:
 [<6010d1d9>] ? kclist_add_private+0x0/0xe7
 [<6003a269>] walk_system_ram_range+0x61/0xb7
 [<6000e859>] ? proc_kcore_init+0x0/0xf1
 [<6010d574>] kcore_update_ram+0x4c/0x168
 [<6010d72e>] ? kclist_add+0x0/0x2e
 [<6000e943>] proc_kcore_init+0xea/0xf1
 [<6000e859>] ? proc_kcore_init+0x0/0xf1
 [<6000e859>] ? proc_kcore_init+0x0/0xf1
 [<600189f0>] do_one_initcall+0x13c/0x204
 [<6004ca46>] ? parse_args+0x1df/0x2e0
 [<6004c82d>] ? parameq+0x0/0x3a
 [<601b5990>] ? strcpy+0x0/0x18
 [<60001e1a>] kernel_init_freeable+0x240/0x31e
 [<6026f1c0>] kernel_init+0x12/0x148
 [<60019fad>] new_thread_handler+0x81/0xa3

=46ixes 8c86e70acead629aacb4a ("resource: provide new functions to walk
through resources").

Reported-by: Daniel Walter <sahne@0x90.at>
Tested-by: Richard Weinberger <richard@nod.at>
Tested-by: Toralf F=F6rster <toralf.foerster@gmx.de>
Tested-by: Daniel Walter <sahne@0x90.at>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/resource.c~resource-fix-the-case-of-null-pointer-acces=
s kernel/resource.c
--- a/kernel/resource.c~resource-fix-the-case-of-null-pointer-access
+++ a/kernel/resource.c
@@ -351,15 +351,12 @@ static int find_next_iomem_res(struct re
 	end =3D res->end;
 	BUG_ON(start >=3D end);
=20
-	read_lock(&resource_lock);
