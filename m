Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56D920CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898267; cv=none; b=g1foRB6zk0NRQnJM39D/R8/z+sjegMYWqXzL6ayWfkp49TzsxFWSyvHUwsZkpaPUVou9Nr9KX8uvFztZE3BDCcpYU3mTMN92xWuvvUxazOxENv1Zjlu05F/jnZ//LkVlz5G8TGE86NqERo67qsFDLgprAOVZvypQCRPzBnkU2Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898267; c=relaxed/simple;
	bh=RTVJhJM32Ys+enX+zQd8nq1FTphkp9uehdmu9ncw5es=;
	h=Date:To:From:Subject:Message-Id; b=I/zspI1I7xFqMMCScIkbboR8Hcr7KxIkZTyA7lzcIFTBiURxoyPWlHQIjA7cajHUe5W4ezRiyE8aH7q1EK2w/qAl8vjHMUfRAgcNrYPEK4WqdpiG2fAvZsqVbbAB6suGMXOzpijyTTK73EaR1QCNxCCGaPbKr5aZ91D1dHEQi3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z2j9XhYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z2j9XhYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB28C4CEF1;
	Sat, 31 Jan 2026 22:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898267;
	bh=RTVJhJM32Ys+enX+zQd8nq1FTphkp9uehdmu9ncw5es=;
	h=Date:To:From:Subject:From;
	b=z2j9XhYmlUqFj0Dokv3ZMIeaL3Fr0FygOkxKI0EAff4M7WObbnwfNSxhcczX1tDMP
	 sX/g1dl7PR/CJ5RHsRg3kZEnZTbGkWRpz9mm4+91u9VPq5doslNddflf9Pp9ggeuZD
	 SmhbberXna2QaRB0kMukSCh4wXmITxj4jKgZMoFE=
Date: Sat, 31 Jan 2026 14:24:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-balloon_compaction-assert-that-the-balloon_pages_lock-is-held.patch removed from -mm tree
Message-Id: <20260131222427.8BB28C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/balloon_compaction: assert that the balloon_pages_lock is held
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-assert-that-the-balloon_pages_lock-is-held.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/balloon_compaction: assert that the balloon_pages_lock is held
Date: Tue, 20 Jan 2026 00:01:24 +0100

Let's add some sanity checks for holding the balloon_pages_lock when we're
effectively inflating/deflating a page.

Link: https://lkml.kernel.org/r/20260119230133.3551867-17-david@kernel.org
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

 mm/balloon_compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/balloon_compaction.c~mm-balloon_compaction-assert-that-the-balloon_pages_lock-is-held
+++ a/mm/balloon_compaction.c
@@ -28,6 +28,7 @@ static DEFINE_SPINLOCK(balloon_pages_loc
 static void balloon_page_insert(struct balloon_dev_info *balloon,
 				       struct page *page)
 {
+	lockdep_assert_held(&balloon_pages_lock);
 	__SetPageOffline(page);
 	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
 		SetPageMovableOps(page);
@@ -45,6 +46,7 @@ static void balloon_page_insert(struct b
  */
 static void balloon_page_finalize(struct page *page)
 {
+	lockdep_assert_held(&balloon_pages_lock);
 	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
 		set_page_private(page, 0);
 	/* PageOffline is sticky until the page is freed to the buddy. */
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

