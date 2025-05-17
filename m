Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600CA136A;
	Sat, 17 May 2025 15:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747495375; cv=none; b=fK37BdbC21QtBgBFyB7sDM0n/OCY7SfhyGX42Pyu398BcIvOq8bKz/k4j5OZaAmsUCAXmOoG9vmqo3aA+MswgqgZZHqjvPTrYfHMOEj1GnDg1M2baTICkIHzHkmHuAiZv3urb3m6XtrurgvZmsiM95SLKPo15DG7Jl0RRo4oFWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747495375; c=relaxed/simple;
	bh=i2lOTAhCsr9eI82SJj9qtcrR2IbHf29JEopar8oR/S8=;
	h=Date:To:From:Subject:Message-Id; b=Kj0gyujvNgdB6gxvCegLDYuwL+HGsqSnP1erhgbZ8zkLdQWatF9uflU/39VDDYUE95ST14gc/rnDHBX3PCdazQKHI5SKOFfTnGD7VbbLgY+T8kQCu3hKF7JiUrq12x3epU4807qMmQ3wHu6Y3ymV2LG32OV7RkMqC5ThHR1YHAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MO94nzIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MO94nzIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6947C4CEEA;
	Sat, 17 May 2025 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747495374;
	bh=i2lOTAhCsr9eI82SJj9qtcrR2IbHf29JEopar8oR/S8=;
	h=Date:To:From:Subject:From;
	b=MO94nzIEbe+r4mfBYAjvXbMtGot7Gy9B0CafYkL7ZL1TcJdeuhdQ2AzQ4U2fnoyxZ
	 aIXACVkewSmLaNe5m4h7w1IDH60ZvJWErloOr0xJhLX6q331+Jc1AQ8+rCJvx8tKNr
	 w4yDTn7gqFVcydho7aP67FCjkC3Z+dHAw84awnf4=
Date: Sat, 17 May 2025 08:22:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,catalin.marinas@arm.com,jkangas@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] xarray-fix-kmemleak-false-positive-in-xas_shrink.patch removed from -mm tree
Message-Id: <20250517152254.A6947C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: XArray: fix kmemleak false positive in xas_shrink()
has been removed from the -mm tree.  Its filename was
     xarray-fix-kmemleak-false-positive-in-xas_shrink.patch

This patch was dropped because an updated version will be issued

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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

radix-tree-fix-kmemleak-false-positive-in-radix_tree_shrink.patch

