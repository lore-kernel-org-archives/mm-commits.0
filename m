From: akpm@linux-foundation.org
Subject: [merged]
 fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:18:13 -0800
Message-ID: <54e25085.DavdgpSoRAErP9Wy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbbBPUSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: dcache: manually unpoison dname after allocation to shut up kasan's reports
has been removed from the -mm tree.  Its filename was
     fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: fs: dcache: manually unpoison dname after allocation to shut up kasan's reports

We need to manually unpoison rounded up allocation size for dname to avoid
kasan's reports in dentry_string_cmp().  When CONFIG_DCACHE_WORD_ACCESS=y
dentry_string_cmp may access few bytes beyound requested in kmalloc()
size.

dentry_string_cmp() relates on that fact that dentry allocated using
kmalloc and kmalloc internally round up allocation size.  So this is not a
bug, but this makes kasan to complain about such accesses.  To avoid such
reports we mark rounded up allocation size in shadow as accessible.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Signed-off-by: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/dcache.c~fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports fs/dcache.c
--- a/fs/dcache.c~fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports
+++ a/fs/dcache.c
@@ -38,6 +38,8 @@
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
+#include <linux/kasan.h>
+
 #include "internal.h"
 #include "mount.h"
 
@@ -1429,6 +1431,9 @@ struct dentry *__d_alloc(struct super_bl
 		}
 		atomic_set(&p->u.count, 1);
 		dname = p->name;
+		if (IS_ENABLED(CONFIG_DCACHE_WORD_ACCESS))
+			kasan_unpoison_shadow(dname,
+				round_up(name->len + 1,	sizeof(unsigned long)));
 	} else  {
 		dname = dentry->d_iname;
 	}	
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch

