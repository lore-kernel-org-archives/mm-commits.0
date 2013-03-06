From: akpm@linux-foundation.org
Subject: + memblock-add-assertion-for-zero-allocation-alignment.patch added to -mm tree
Date: Wed, 06 Mar 2013 14:44:05 -0800
Message-ID: <20130306224405.8160D5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:49570 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab3CFWoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 17:44:07 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so927371ves.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 14:44:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Vineet.Gupta1@synopsys.com, liwanp@linux.vnet.ibm.com, mingo@kernel.org, tj@kernel.org, vgupta@synopsys.com, yinghai@kernel.org


The patch titled
     Subject: memblock: add assertion for zero allocation alignment
has been added to the -mm tree.  Its filename is
     memblock-add-assertion-for-zero-allocation-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memblock-add-assertion-for-zero-allocation-alignment.patch

