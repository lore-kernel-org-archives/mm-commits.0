From: akpm@linux-foundation.org
Subject: [merged] memblock-add-assertion-for-zero-allocation-alignment.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:38 -0700
Message-ID: <20130430184438.8C3585A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:41602 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab3D3Soj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:39 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so75311veb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, liwanp@linux.vnet.ibm.com, mingo@kernel.org, tj@kernel.org, vgupta@synopsys.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: add assertion for zero allocation alignment
has been removed from the -mm tree.  Its filename was
     memblock-add-assertion-for-zero-allocation-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: memblock: add assertion for zero allocation alignment

This came to light when calling memblock allocator from arc port (for
copying flattended DT).  If a "0" alignment is passed, the allocator
round_up() call incorrectly rounds up the size to 0.

round_up(num, alignto) => ((num - 1) | (alignto -1)) + 1

While the obvious allocation failure causes kernel to panic, it is better
to warn the caller to fix the code.

Tejun suggested that instead of BUG_ON(!align) - which might be
ineffective due to pending console init and such, it is better to WARN_ON,
and continue the boot with a reasonable default align.

Caller passing @size need not be handled similarly as the subsequent
panic will indicate that anyhow.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memblock.c~memblock-add-assertion-for-zero-allocation-alignment mm/memblock.c
--- a/mm/memblock.c~memblock-add-assertion-for-zero-allocation-alignment
+++ a/mm/memblock.c
@@ -771,6 +771,9 @@ static phys_addr_t __init memblock_alloc
 {
 	phys_addr_t found;
 
+	if (WARN_ON(!align))
+		align = __alignof__(long long);
+
 	/* align @size to avoid excessive fragmentation on reserved array */
 	size = round_up(size, align);
 
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

origin.patch
linux-next.patch

