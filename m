Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19581DEFDA
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 00:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744764866; cv=none; b=ZBKh4XHdlHCtacJRy8KoeVWV/m0k5erReaGdqKT7+Qlv3dALL5iz7HminDAHgcxzfnJATWUQ4ASTfA70fx5pn2eBrknfOHLlt8KNm2d+1PDhvlTwOJNZKI1vVySSo78XdaFl/mYTys8SXqsT/WVwIgRtRPufinzQobbMwl+i3ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744764866; c=relaxed/simple;
	bh=borsO5wszstNS9P2ILhGINq71+KPiivcNndFfugUSfg=;
	h=Date:To:From:Subject:Message-Id; b=HbIPDdf21P8FCGfxD1hGRXY0zNFf+gCf5LisymS8Zo0hvehUvtzIqBaOVyIkOjg+M3lpqvI13N6PPmFJ2PKGMr4/fJ6O5G1t/YxJSRKYZy5eejnpCCrcuhVC1ndxBAR4qIerRSvC+UR41qrwHGsQg8r7qVqaaNFtuU3KYKSy5Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l11vJcun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l11vJcun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAD3C4CEEC;
	Wed, 16 Apr 2025 00:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744764866;
	bh=borsO5wszstNS9P2ILhGINq71+KPiivcNndFfugUSfg=;
	h=Date:To:From:Subject:From;
	b=l11vJcun02CThL1dH/ki1sTPofZyVlKtHvH0s6And+rjy59Oj2tqjzEVSNqZiLC0R
	 d24YixMamQ1q6b3fm23HHHGvSI75yscygNQtvF8UvY90F/0v4wAHXMp2LQ7cS/jKvP
	 zLpmW76IVCTs6ews4zxMZsm8P5L1Ia37gRqBNXVo=
Date: Tue, 15 Apr 2025 17:54:25 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,gregkh@linuxfoundation.org,donettom@linux.ibm.com,david@redhat.com,dakr@kernel.org,adityag@linux.ibm.com,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] drivers-base-memory-avoid-overhead-from-for_each_present_section_nr.patch removed from -mm tree
Message-Id: <20250416005425.EEAD3C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/memory: avoid overhead from for_each_present_section_nr()
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-avoid-overhead-from-for_each_present_section_nr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: drivers/base/memory: avoid overhead from for_each_present_section_nr()
Date: Thu, 10 Apr 2025 22:51:10 +1000

for_each_present_section_nr() was introduced to add_boot_memory_block() by
commit 61659efdb35c ("drivers/base/memory: improve
add_boot_memory_block()").  It causes unnecessary overhead when the
present sections are really sparse.  next_present_section_nr() called by
the macro to find the next present section, which is far away from the
spanning sections in the specified block.  Too much time consumed by
next_present_section_nr() in this case, which can lead to softlockup as
observed by Aditya Gupta on IBM Power10 machine.

  watchdog: BUG: soft lockup - CPU#248 stuck for 22s! [swapper/248:1]
  Modules linked in:
  CPU: 248 UID: 0 PID: 1 Comm: swapper/248 Not tainted 6.15.0-rc1-next-20250408 #1 VOLUNTARY
  Hardware name: 9105-22A POWER10 (raw) 0x800200 opal:v7.1-107-gfda75d121942 PowerNV
  NIP:  c00000000209218c LR: c000000002092204 CTR: 0000000000000000
  REGS: c00040000418fa30 TRAP: 0900   Not tainted  (6.15.0-rc1-next-20250408)
  MSR:  9000000002009033 <SF,HV,VEC,EE,ME,IR,DR,RI,LE>  CR: 28000428  XER: 00000000
  CFAR: 0000000000000000 IRQMASK: 0
  GPR00: c000000002092204 c00040000418fcd0 c000000001b08100 0000000000000040
  GPR04: 0000000000013e00 c000c03ffebabb00 0000000000c03fff c000400fff587f80
  GPR08: 0000000000000000 00000000001196f7 0000000000000000 0000000028000428
  GPR12: 0000000000000000 c000000002e80000 c00000000001007c 0000000000000000
  GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  GPR24: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  GPR28: c000000002df7f70 0000000000013dc0 c0000000011dd898 0000000008000000
  NIP [c00000000209218c] memory_dev_init+0x114/0x1e0
  LR [c000000002092204] memory_dev_init+0x18c/0x1e0
  Call Trace:
  [c00040000418fcd0] [c000000002092204] memory_dev_init+0x18c/0x1e0 (unreliable)
  [c00040000418fd50] [c000000002091348] driver_init+0x78/0xa4
  [c00040000418fd70] [c0000000020063ac] kernel_init_freeable+0x22c/0x370
  [c00040000418fde0] [c0000000000100a8] kernel_init+0x34/0x25c
  [c00040000418fe50] [c00000000000cd94] ret_from_kernel_user_thread+0x14/0x1c

Avoid the overhead by folding for_each_present_section_nr() to the outer
loop.  add_boot_memory_block() is dropped after that.

Link: https://lkml.kernel.org/r/20250410125110.1232329-1-gshan@redhat.com
Fixes: 61659efdb35c ("drivers/base/memory: improve add_boot_memory_block()")
Closes: https://lore.kernel.org/linux-mm/20250409180344.477916-1-adityag@linux.ibm.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reported-by: Aditya Gupta <adityag@linux.ibm.com>
Tested-by: Aditya Gupta <adityag@linux.ibm.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   41 ++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-avoid-overhead-from-for_each_present_section_nr
+++ a/drivers/base/memory.c
@@ -816,21 +816,6 @@ static int add_memory_block(unsigned lon
 	return 0;
 }
 
-static int __init add_boot_memory_block(unsigned long base_section_nr)
-{
-	unsigned long nr;
-
-	for_each_present_section_nr(base_section_nr, nr) {
-		if (nr >= (base_section_nr + sections_per_block))
-			break;
-
-		return add_memory_block(memory_block_id(base_section_nr),
-					MEM_ONLINE, NULL, NULL);
-	}
-
-	return 0;
-}
-
 static int add_hotplug_memory_block(unsigned long block_id,
 				    struct vmem_altmap *altmap,
 				    struct memory_group *group)
@@ -957,7 +942,7 @@ static const struct attribute_group *mem
 void __init memory_dev_init(void)
 {
 	int ret;
-	unsigned long block_sz, nr;
+	unsigned long block_sz, block_id, nr;
 
 	/* Validate the configured memory block size */
 	block_sz = memory_block_size_bytes();
@@ -970,15 +955,23 @@ void __init memory_dev_init(void)
 		panic("%s() failed to register subsystem: %d\n", __func__, ret);
 
 	/*
-	 * Create entries for memory sections that were found
-	 * during boot and have been initialized
+	 * Create entries for memory sections that were found during boot
+	 * and have been initialized. Use @block_id to track the last
+	 * handled block and initialize it to an invalid value (ULONG_MAX)
+	 * to bypass the block ID matching check for the first present
+	 * block so that it can be covered.
 	 */
-	for (nr = 0; nr <= __highest_present_section_nr;
-	     nr += sections_per_block) {
-		ret = add_boot_memory_block(nr);
-		if (ret)
-			panic("%s() failed to add memory block: %d\n", __func__,
-			      ret);
+	block_id = ULONG_MAX;
+	for_each_present_section_nr(0, nr) {
+		if (block_id != ULONG_MAX && memory_block_id(nr) == block_id)
+			continue;
+
+		block_id = memory_block_id(nr);
+		ret = add_memory_block(block_id, MEM_ONLINE, NULL, NULL);
+		if (ret) {
+			panic("%s() failed to add memory block: %d\n",
+			      __func__, ret);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-fix-parameter-passed-to-page_mapcount_is_type.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type.patch

