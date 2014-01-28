From: akpm@linux-foundation.org
Subject: + memblock-add-limit-checking-to-memblock_virt_alloc.patch added
 to -mm tree
Date: Tue, 28 Jan 2014 14:08:49 -0800
Message-ID: <52e82a71.c6N4+khOODVxQuA8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaA1WIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 17:08:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, santosh.shilimkar@ti.com, olof@lixom.net, mingo@elte.hu, konrad.wilk@oracle.com, khilman@linaro.org, hpa@zytor.com, grygorii.strashko@ti.com, dave.hansen@intel.com, yinghai@kernel.org

Subject: + memblock-add-limit-checking-to-memblock_virt_alloc.patch added to -mm tree
To: yinghai@kernel.org,dave.hansen@intel.com,grygorii.strashko@ti.com,hpa@zytor.com,khilman@linaro.org,konrad.wilk@oracle.com,mingo@elte.hu,olof@lixom.net,santosh.shilimkar@ti.com
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 14:08:49 -0800


The patch titled
     Subject: memblock: Add limit checking to memblock_virt_alloc
has been added to the -mm tree.  Its filename is
     memblock-add-limit-checking-to-memblock_virt_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-add-limit-checking-to-memblock_virt_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-add-limit-checking-to-memblock_virt_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: memblock: Add limit checking to memblock_virt_alloc

In original bootmem wrapper for memblock, we have limit checking.

Add it to memblock_virt_alloc, to address arm and x86 booting crash.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Reported-by: Kevin Hilman <khilman@linaro.org>
Reported-by: Olof Johansson <olof@lixom.net>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Strashko, Grygorii" <grygorii.strashko@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memblock.c~memblock-add-limit-checking-to-memblock_virt_alloc mm/memblock.c
--- a/mm/memblock.c~memblock-add-limit-checking-to-memblock_virt_alloc
+++ a/mm/memblock.c
@@ -1077,6 +1077,9 @@ static void * __init memblock_virt_alloc
 	if (!align)
 		align = SMP_CACHE_BYTES;
 
+	if (max_addr > memblock.current_limit)
+		max_addr = memblock.current_limit;
+
 again:
 	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
 					    nid);
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
memblock-add-limit-checking-to-memblock_virt_alloc.patch
linux-next.patch

