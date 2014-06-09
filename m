From: akpm@linux-foundation.org
Subject: [merged] hfsplus-fix-compiler-warning-on-powerpc.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:32:32 -0700
Message-ID: <53960bd0.oSol/lXlf18zh8xO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaFITce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, saproj@gmail.com, geert@linux-m68k.org, lists@nerdbynature.de

Subject: [merged] hfsplus-fix-compiler-warning-on-powerpc.patch removed from -mm tree
To: lists@nerdbynature.de,geert@linux-m68k.org,saproj@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:32:32 -0700


The patch titled
     Subject: hfsplus: fix compiler warning on PowerPC
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-compiler-warning-on-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christian Kujau <lists@nerdbynature.de>
Subject: hfsplus: fix compiler warning on PowerPC

a99b7069aab8 ("hfsplus: Fix undefined __divdi3 in
hfsplus_init_header_node()") introduced do_div() to xattr.c and the
warning below too.

As Geert remarked: "tmp" is "loff_t" which is "__kernel_loff_t", which is
"long long", i.e.  signed, while include/asm-generic/div64.h compares its
type with "uint64_t".  As inode sizes are positive, it should be safe to
change the type of "tmp" to "u64".

==============================
   CC [M]  fs/hfsplus/xattr_user.o
   CC [M]  fs/hfsplus/xattr_security.o
   CC [M]  fs/hfsplus/xattr.o
   CC [M]  fs/hfsplus/xattr_trusted.o
In file included from
arch/powerpc/include/asm/div64.h:1:0,
                  from include/linux/kernel.h:124,
                  from include/asm-generic/bug.h:13,
                  from arch/powerpc/include/asm/bug.h:127,
                  from include/linux/bug.h:4,
                  from include/linux/thread_info.h:11,
                  from include/asm-generic/preempt.h:4,
                  from arch/powerpc/include/generated/asm/preempt.h:1,
                  from include/linux/preempt.h:18,
                  from include/linux/spinlock.h:50,
                  from include/linux/wait.h:8,
                  from include/linux/fs.h:6,
                  from fs/hfsplus/hfsplus_fs.h:19,
                  from fs/hfsplus/xattr.c:9:
fs/hfsplus/xattr.c: In function
'hfsplus_init_header_node':
include/asm-generic/div64.h:43:28: warning:
comparison of distinct pointer types lacks a cast [enabled by default]
   (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
                             ^
fs/hfsplus/xattr.c:86:2: note: in expansion of
macro 'do_div'
   do_div(tmp, node_size);
   ^
   LD [M]  fs/hfsplus/hfsplus.o
==============================

Signed-off-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Sergei Antonov <saproj@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/xattr.c~hfsplus-fix-compiler-warning-on-powerpc fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-fix-compiler-warning-on-powerpc
+++ a/fs/hfsplus/xattr.c
@@ -67,7 +67,7 @@ static void hfsplus_init_header_node(str
 	char *bmp;
 	u32 used_nodes;
 	u32 used_bmp_bytes;
-	loff_t tmp;
+	u64 tmp;
 
 	hfs_dbg(ATTR_MOD, "init_hdr_attr_file: clump %u, node_size %u\n",
 		clump_size, node_size);
_

Patches currently in -mm which might be from lists@nerdbynature.de are

origin.patch

