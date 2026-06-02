Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580DA30C37A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439017; cv=none; b=sIo72QDrXM3Re1MRh4puuxhG9dpYGjL0uYyDGX3Tn+0iNWAhTsz4lXAspGevgqhKA/LvXUqF5KrzRTykYYnKoWXEIz4Vxodi3dgDvp7cRg6jA4g8xhze9fURvvjbac65Q0/aZpeqSZxJkdfQrSpJDV8scJyAIagriLcdsCK+KIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439017; c=relaxed/simple;
	bh=U6I79EDowuIoRcVY+YaYBg9CPgDGTMINi2lxjEncMDE=;
	h=Date:To:From:Subject:Message-Id; b=bpDHOw9dx/AwUeqtfCdwtmJ35BJQvKtf1vAaiUfunRbxQLR7NrfnPrnOo1Tm0qEP7Q7LVIkdW7ayvD9oA9dv0BWKJlxNaCyU/JiFXRsJEdBbKYaBax4/T1n8H0k5XWsnQ/ZAgKoXTEks03HTBwL5NVlZpyePK6Uf9CFi5krG4GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZxV1X7pY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZxV1X7pY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA62A1F00893;
	Tue,  2 Jun 2026 22:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439016;
	bh=jwPRe69Grz1LfcOH5OneriKTY0rJVKJs9ZFGm2TNyDk=;
	h=Date:To:From:Subject;
	b=ZxV1X7pYmkRhOJ+t2U5+48RAmTShamR8KLGy1aoocL0YB/YPiqF62ZFO6LdRBu/DS
	 ewBMU3kBlbYfvTtjPUvG/JpyM2ViG0asftU2kkCjGJNDs6yyBOvIzxNe3dUfYJIkuv
	 T3Lfw7bDfJL/g2bbsU4crkkWM7WdWdCHcojZHlXY=
Date: Tue, 02 Jun 2026 15:23:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bootmem_info-stop-using-pg_private.patch removed from -mm tree
Message-Id: <20260602222335.EA62A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/bootmem_info: stop using PG_private
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-stop-using-pg_private.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: stop using PG_private
Date: Mon, 11 May 2026 16:05:31 +0200

Nobody checks PG_private for these pages, and we can happily use
set_page_private() without setting PG_private. So let's just stop
setting/clearing PG_private.

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-3-3fb0be6fc688@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
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
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem_info.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/bootmem_info.c~mm-bootmem_info-stop-using-pg_private
+++ a/mm/bootmem_info.c
@@ -19,7 +19,6 @@ void get_page_bootmem(unsigned long info
 {
 	BUG_ON(type > 0xf);
 	BUG_ON(info > (ULONG_MAX >> 4));
-	SetPagePrivate(page);
 	set_page_private(page, info << 4 | type);
 	page_ref_inc(page);
 }
@@ -32,7 +31,6 @@ void put_page_bootmem(struct page *page)
 	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
 
 	if (page_ref_dec_return(page) == 1) {
-		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 		free_reserved_page(page);
_

Patches currently in -mm which might be from david@kernel.org are


