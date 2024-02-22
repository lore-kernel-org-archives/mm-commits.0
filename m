Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EDB171A1
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560061; cv=none; b=MUWtWi6nRb70cdlh6TRhawJwjJOxCTDal/80OogiajIVRcxAi0QdUgnU6YZjwuGxY21zJzORKUK7Qtsp5ijvXscwCnAUopuTOaXvIl5EFmQP+FL3j8ZHqyJc0Y7yFyhMN4NUmesmkey1q8cHloEc02Gw+cfTPMjk2YWxy4sLJlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560061; c=relaxed/simple;
	bh=xp4WHCINLNtFlKhTryHI6BbT81o8DYRFGLho3fojLlI=;
	h=Date:To:From:Subject:Message-Id; b=rkfvb4n5nh54+cB0WtWZ2P6wOHiX32O0fCk5/eB+VIPGEkXa8O8nKZn5jjqieVgVdp9Fq4EKkwtUONGSLYCchyxDBNKDZMop3MBjHpnE9ZnBSYRZpCxNxcu3ino7Hq+/Z1KMnsvkb1RXAuiOOFhG+TGp3c2tTfs047xUPBVcyac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S1vI+caD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S1vI+caD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B400FC43390;
	Thu, 22 Feb 2024 00:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560060;
	bh=xp4WHCINLNtFlKhTryHI6BbT81o8DYRFGLho3fojLlI=;
	h=Date:To:From:Subject:From;
	b=S1vI+caDsLJE+kH0akvXCXPWlFJEH39/29Z0kIMznSES7nz15X/BlYFfCoO+Yc1s1
	 sPVuKIoSqZ/k+lzws/y4d295NAK78BgbolWJHwPeyhVa9PDXxapMLzq/3Iteg6PhLF
	 I1fExnQrIH8pcsCMM4Zc5njGCDcg/UBqk3l0kCfI=
Date: Wed, 21 Feb 2024 16:01:00 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch removed from -mm tree
Message-Id: <20240222000100.B400FC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/mm: implement MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers
has been removed from the -mm tree.  Its filename was
     s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: s390/mm: implement MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers
Date: Mon, 8 Jan 2024 14:27:46 +0100

MEM_PREPARE_ONLINE memory notifier makes memory block physical
accessible via sclp assign command. The notifier ensures self-contained
memory maps are accessible and hence enabling the "memmap on memory" on
s390.

MEM_FINISH_OFFLINE memory notifier shifts the memory block to an
inaccessible state via sclp unassign command.

Implementation considerations:
* When MHP_MEMMAP_ON_MEMORY is disabled, the system retains the old
  behavior. This means the memory map is allocated from default memory.
* If MACHINE_HAS_EDAT1 is unavailable, MHP_MEMMAP_ON_MEMORY is
  automatically disabled. This ensures that vmemmap pagetables do not
  consume additional memory from the default memory allocator.
* The MEM_GOING_ONLINE notifier has been modified to perform no
  operation, as MEM_PREPARE_ONLINE already executes the sclp assign
  command.
* The MEM_CANCEL_ONLINE/MEM_OFFLINE notifier now performs no operation, as
  MEM_FINISH_OFFLINE already executes the sclp unassign command.

Link: https://lkml.kernel.org/r/20240108132747.3238763-5-sumanthk@linux.ibm.com
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/sclp_cmd.c |   41 ++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 6 deletions(-)

--- a/drivers/s390/char/sclp_cmd.c~s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers
+++ a/drivers/s390/char/sclp_cmd.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/memory.h>
+#include <linux/memory_hotplug.h>
 #include <linux/module.h>
 #include <asm/ctlreg.h>
 #include <asm/chpid.h>
@@ -26,6 +27,7 @@
 #include <asm/sclp.h>
 #include <asm/numa.h>
 #include <asm/facility.h>
+#include <asm/page-states.h>
 
 #include "sclp.h"
 
@@ -340,13 +342,38 @@ static int sclp_mem_notifier(struct noti
 		if (contains_standby_increment(start, start + size))
 			rc = -EPERM;
 		break;
-	case MEM_GOING_ONLINE:
+	case MEM_PREPARE_ONLINE:
+		/*
+		 * Access the altmap_start_pfn and altmap_nr_pages fields
+		 * within the struct memory_notify specifically when dealing
+		 * with only MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers.
+		 *
+		 * When altmap is in use, take the specified memory range
+		 * online, which includes the altmap.
+		 */
+		if (arg->altmap_nr_pages) {
+			start = PFN_PHYS(arg->altmap_start_pfn);
+			size += PFN_PHYS(arg->altmap_nr_pages);
+		}
 		rc = sclp_mem_change_state(start, size, 1);
+		if (rc || !arg->altmap_nr_pages)
+			break;
+		/*
+		 * Set CMMA state to nodat here, since the struct page memory
+		 * at the beginning of the memory block will not go through the
+		 * buddy allocator later.
+		 */
+		__arch_set_page_nodat((void *)__va(start), arg->altmap_nr_pages);
 		break;
-	case MEM_CANCEL_ONLINE:
-		sclp_mem_change_state(start, size, 0);
-		break;
-	case MEM_OFFLINE:
+	case MEM_FINISH_OFFLINE:
+		/*
+		 * When altmap is in use, take the specified memory range
+		 * offline, which includes the altmap.
+		 */
+		if (arg->altmap_nr_pages) {
+			start = PFN_PHYS(arg->altmap_start_pfn);
+			size += PFN_PHYS(arg->altmap_nr_pages);
+		}
 		sclp_mem_change_state(start, size, 0);
 		break;
 	default:
@@ -397,7 +424,9 @@ static void __init add_memory_merged(u16
 	if (!size)
 		goto skip_add;
 	for (addr = start; addr < start + size; addr += block_size)
-		add_memory(0, addr, block_size, MHP_NONE);
+		add_memory(0, addr, block_size,
+			   MACHINE_HAS_EDAT1 ?
+			   MHP_MEMMAP_ON_MEMORY | MHP_OFFLINE_INACCESSIBLE : MHP_NONE);
 skip_add:
 	first_rn = rn;
 	num = 1;
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are


