Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6A63B8920
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439024; cv=none; b=AUeNz0uaZLDnB/BZ1/JiDgZwUkANleqGtYLuajtG6fGpL4cqZRLPF0g/74g+XUXmaL0thsTexEXmelQVXoTu1+8d+b9+9mYrWoVc8hhw3cshirtVBewNKSAMp5v9qULGSxhx9gMNM57AX0SwCA/IQE3TK0qeNo1ZdgoQkoVrGFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439024; c=relaxed/simple;
	bh=xfNVv+fH54xDQtn/L9Qm6taY/373a8dr1/LuMVewZtg=;
	h=Date:To:From:Subject:Message-Id; b=ohYcaW57E5OdRUYnkk7zJU+MqV4WSseRSaSao68IdGk0zUmVWDC2FayK5VGat5pXdi5R2vo6bM41vQr9wsk3PEl/Pk7z9kUnQanp48Wes6L/Stav/Kvv5A9Vu4UzPDdjEann7jPmq8Z4WlnGMH0liepZZGd9diMXBuYipoW4BCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hr4AJ40/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hr4AJ40/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59301F0089A;
	Tue,  2 Jun 2026 22:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439022;
	bh=b8MkEu2H1QjvItUkAoqerWmTtEv4o9gaT0YKg2uk/rE=;
	h=Date:To:From:Subject;
	b=hr4AJ40/ddw99SI7/VddRVvPXQW4E8ivApbUikhGxH6jeSG9Qs9vMDg/ZVOHAf74g
	 ocy/ftpV+wWVuwtCVUS0cBuRFv4/KetM1Clk2g+6O+SBX7LZYRTRAgoi21/RjD02V5
	 Vp6RA+VjIU3/tkd2Ld7yxupQkS8eNTag34qxUrO8=
Date: Tue, 02 Jun 2026 15:23:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-remove-config_have_bootmem_info_node.patch removed from -mm tree
Message-Id: <20260602222342.C59301F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
has been removed from the -mm tree.  Its filename was
     powerpc-mm-remove-config_have_bootmem_info_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
Date: Mon, 11 May 2026 16:05:36 +0200

register_page_bootmem_info_node() essentially only calls
register_page_bootmem_memmap(). However, on powerpc that function is a
nop. So there is not benefit in using CONFIG_HAVE_BOOTMEM_INFO_NODE
anymore, let's just drop it.

We can stop including bootmem_info.h.

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/init_64.c |    8 --------
 mm/Kconfig                |    2 +-
 2 files changed, 1 insertion(+), 9 deletions(-)

--- a/arch/powerpc/mm/init_64.c~powerpc-mm-remove-config_have_bootmem_info_node
+++ a/arch/powerpc/mm/init_64.c
@@ -41,7 +41,6 @@
 #include <linux/libfdt.h>
 #include <linux/memremap.h>
 #include <linux/memory.h>
-#include <linux/bootmem_info.h>
 
 #include <asm/pgalloc.h>
 #include <asm/page.h>
@@ -388,13 +387,6 @@ void __ref vmemmap_free(unsigned long st
 
 #endif
 
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-}
-#endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
-
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 #ifdef CONFIG_PPC_BOOK3S_64
--- a/mm/Kconfig~powerpc-mm-remove-config_have_bootmem_info_node
+++ a/mm/Kconfig
@@ -537,7 +537,7 @@ endchoice
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
-	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
+	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on MEMORY_HOTPLUG
 	select MIGRATION
 
_

Patches currently in -mm which might be from david@kernel.org are


