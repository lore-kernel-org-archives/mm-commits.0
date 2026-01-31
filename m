Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A4820CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898271; cv=none; b=hZCd/v4AVb+mkWdh7Yz0I86cZT2rEfBlxacCH78bYU5axUjm9cPI0NNOJ7/K2yX5NKsXZkYPNlJgUYW/BoRyH6LhdCzewTrjmuccSPX5SAMLuP0JUwRDhMM/HghhUkzFlqmx/IZRUwXEoWUujCXzvYfNT2czMe0IDs7kgH2b+q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898271; c=relaxed/simple;
	bh=z8tYafunsxAY5HQWNHd9IIybEBJKAcTDz4ALg5/Jtdw=;
	h=Date:To:From:Subject:Message-Id; b=PM5Umqg6zKxLct5ffaYQz3UbTlvdpzhiZcXxKWxiyzL0U1snjpjnX7dq7TokebMAK7Y9cGBWiera8TO8d6G/XeULh5fVI3EtpRjCSQro50MCdTMa/TDHq1J/CXC5txqjuN2qTs984pZVmbORDseGWTn15ProT7u5yCQz22uVnoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bv8+F2hc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bv8+F2hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EAFC4CEF1;
	Sat, 31 Jan 2026 22:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898271;
	bh=z8tYafunsxAY5HQWNHd9IIybEBJKAcTDz4ALg5/Jtdw=;
	h=Date:To:From:Subject:From;
	b=bv8+F2hcTWZpvvSoxmkp8Nc26ECxoela459BYXA8NJdz7JnTvUQhHIzQR0SwlkeJS
	 DbNO4CP6k9pD5OfEMom7fenbSyBlijIrrSZhrMLaN6i4vgIXI4ciAsodzHxqNijPDy
	 MfYjenMEEx4a5r+sWhhKB6Rji9YvG7K493mJM67c=
Date: Sat, 31 Jan 2026 14:24:30 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-balloon_compaction-remove-extern-from-functions.patch removed from -mm tree
Message-Id: <20260131222430.E9EAFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/balloon_compaction: remove "extern" from functions
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-remove-extern-from-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/balloon_compaction: remove "extern" from functions
Date: Tue, 20 Jan 2026 00:01:26 +0100

Adding "extern" to functions is frowned-upon.  Let's just get rid of it
for all functions here.

Link: https://lkml.kernel.org/r/20260119230133.3551867-19-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-remove-extern-from-functions
+++ a/include/linux/balloon_compaction.h
@@ -59,14 +59,14 @@ struct balloon_dev_info {
 	bool adjust_managed_page_count;
 };
 
-extern struct page *balloon_page_alloc(void);
-extern void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
-				 struct page *page);
-extern struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
-extern size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
-				      struct list_head *pages);
-extern size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
-				     struct list_head *pages, size_t n_req_pages);
+struct page *balloon_page_alloc(void);
+void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
+		struct page *page);
+struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
+size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
+		struct list_head *pages);
+size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
+		struct list_head *pages, size_t n_req_pages);
 
 static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 {
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

