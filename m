Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4144E256C79;
	Mon, 12 May 2025 21:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747086362; cv=none; b=T5HJmEiGZtijYNvEc8/RqHA1S9SJvKe3tCOKefo/fqNa0iYhmFU492M/XjF//8LIMRbOoZl9Fz0kbM2ifQnOcYBX/jxob4eaplU9MO7ZR4ee9Vdi5ggv5GbF+p5QSJzZmDcd8sHkqCICHTF8v9ZQFqcmn6+141mwFIj3HkCqQZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747086362; c=relaxed/simple;
	bh=7a3V2t6lae5BMtplt8y8PoNceu2bDnG6gOwNc16h3nk=;
	h=Date:To:From:Subject:Message-Id; b=i/pmKM+JJM4PLwnhuZroFghBzwKyJNYiAJ4qHUEtLDxRdQYkVCB45kqv6TaVUPPs+eiLaa7CvsN6NjWrzZmoq0UM87AcRiq0suEIGpa/ZwcAABTtPG1pBBnsk1B8MtuNmJ49uzYkkveFpmxpoktJomavl0WWA2t9ua+H3M2e8Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gLRkTuqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gLRkTuqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914E7C4CEE7;
	Mon, 12 May 2025 21:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747086361;
	bh=7a3V2t6lae5BMtplt8y8PoNceu2bDnG6gOwNc16h3nk=;
	h=Date:To:From:Subject:From;
	b=gLRkTuqYMpG4wEn7hnDGj3b6ko//cOyBQKs3sNimKSD9S43B6ALAg7ubvetED+8Ik
	 UOkr5K0QBNivIGdjpVjeRb41Sak+4IAn/L9CIWnI4FzNshBdnPYWYfMU9IpEHidNQU
	 tfrca+I0G1krDVmuVDO+nC2ZQofsB3tT7PeSL9xw=
Date: Mon, 12 May 2025 14:46:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,catalin.marinas@arm.com,jkangas@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-fix-kmemleak-false-positive-in-xas_shrink.patch added to mm-hotfixes-unstable branch
Message-Id: <20250512214601.914E7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: XArray: fix kmemleak false positive in xas_shrink()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     xarray-fix-kmemleak-false-positive-in-xas_shrink.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-fix-kmemleak-false-positive-in-xas_shrink.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jared Kangas <jkangas@redhat.com>
Subject: XArray: fix kmemleak false positive in xas_shrink()
Date: Mon, 12 May 2025 12:17:07 -0700

Kmemleak periodically produces a false positive report that resembles
the following:

unreferenced object 0xffff0000c105ed08 (size 576):
  comm "swapper/0", pid 1, jiffies 4294937478
  hex dump (first 32 bytes):
    00 00 03 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    d8 e7 0a 8b 00 80 ff ff 20 ed 05 c1 00 00 ff ff  ........ .......
  backtrace (crc 69e99671):
    kmemleak_alloc+0xb4/0xc4
    kmem_cache_alloc_lru+0x1f0/0x244
    xas_alloc+0x2a0/0x3a0
    xas_expand.constprop.0+0x144/0x4dc
    xas_create+0x2b0/0x484
    xas_store+0x60/0xa00
    __xa_alloc+0x194/0x280
    __xa_alloc_cyclic+0x104/0x2e0
    dev_index_reserve+0xd8/0x18c
    register_netdevice+0x5e8/0xf90
    register_netdev+0x28/0x50
    loopback_net_init+0x68/0x114
    ops_init+0x90/0x2c0
    register_pernet_operations+0x20c/0x554
    register_pernet_device+0x3c/0x8c
    net_dev_init+0x5cc/0x7d8

This transient leak can be traced to xas_shrink(): when the xarray's
head is reassigned, kmemleak may have already started scanning the
xarray. When this happens, if kmemleak fails to scan the new xa_head
before it moves, kmemleak will see it as a leak until the xarray is
scanned again.

The report can be reproduced by running the xdp_bonding BPF selftest,
although it doesn't appear consistently due to the bug's transience.
In my testing, the following script has reliably triggered the report in
under an hour on a debug kernel with kmemleak enabled, where KSELFTESTS
is set to the install path for the kernel selftests:

        #!/bin/sh
        set -eu

        echo 1 >/sys/module/kmemleak/parameters/verbose
        echo scan=1 >/sys/kernel/debug/kmemleak

        while :; do
                $KSELFTESTS/bpf/test_progs -t xdp_bonding
        done

To prevent this false positive report, mark the new xa_head in
xas_shrink() as a transient leak.

Link: https://lkml.kernel.org/r/20250512191707.245153-1-jkangas@redhat.com
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jared Kangas <jkangas@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/xarray.c~xarray-fix-kmemleak-false-positive-in-xas_shrink
+++ a/lib/xarray.c
@@ -8,6 +8,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/export.h>
+#include <linux/kmemleak.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/xarray.h>
@@ -476,6 +477,7 @@ static void xas_shrink(struct xa_state *
 			break;
 		node = xa_to_node(entry);
 		node->parent = NULL;
+		kmemleak_transient_leak(node);
 	}
 }
 
_

Patches currently in -mm which might be from jkangas@redhat.com are

xarray-fix-kmemleak-false-positive-in-xas_shrink.patch

