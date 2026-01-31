Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1C720CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898251; cv=none; b=MfaFA7Sywm/24bT8vsEueP5oc6IKHx9xWRJWluJwAnzFmEElPIfHVZdU9Uaqn79CU7rXRQ33MOCkTqJg111+GCSH8mddr3tsrrzhgX6iOrnLqlcpb2o2B2UI/R49N+OTgS9P1HuH/s7FYuVnBj7F99XRe3pLB/I9etzblKK1DqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898251; c=relaxed/simple;
	bh=DN7sseSDbl++OlzQNXNOE7kf+5d6hXDf7R3Jn2aadVc=;
	h=Date:To:From:Subject:Message-Id; b=qouGJ6dfPXjcZVeV/5VZIUTC2KxVjcAMBe1EDVmS398rw9ZksEe6PHwQOLTmy4xjiSBXXu+c+aE83vGjNUAgtF0gcYJjCjMziB3R/x8Dl8zBAAgbD7eELjd5aCMEHzVt8kAEKeBvSTSJBE+CIHJSprTseKUQjvMd13e5IIdKhcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kVJ/llxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kVJ/llxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E574BC4CEF1;
	Sat, 31 Jan 2026 22:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898251;
	bh=DN7sseSDbl++OlzQNXNOE7kf+5d6hXDf7R3Jn2aadVc=;
	h=Date:To:From:Subject:From;
	b=kVJ/llxG5e1uHf7eLFS8LF2ppOxtzjXpjdu24xelyDSnpuPuqte+9LaV4ursdxO4X
	 67cTm6pP6jtYbqMpvG8thqMpWprXzFLeRRbwP3rJH90TTNmlb0EgLv8oGlfGH1wa67
	 AkHWUwryU0Jqk4/sAYpISQdbd1Nl/tepuyxEVLI8=
Date: Sat, 31 Jan 2026 14:24:10 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmw_balloon-stop-using-the-balloon_dev_info-lock.patch removed from -mm tree
Message-Id: <20260131222410.E574BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmw_balloon: stop using the balloon_dev_info lock
has been removed from the -mm tree.  Its filename was
     vmw_balloon-stop-using-the-balloon_dev_info-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: vmw_balloon: stop using the balloon_dev_info lock
Date: Tue, 20 Jan 2026 00:01:15 +0100

Let's not piggy-back on the existing lock and use a separate lock for the
huge page list.  Now that we use a separate lock, there is no need to
disable interrupts, so use the non-irqsave variants.  We only required the
irqsave variants because of the balloon device lock.

This is a preparation for changing the locking used to protect
balloon_dev_info.

While at it, talk about "page migration" instead of "page compaction". 
We'll change that in core code soon as well.

Link: https://lkml.kernel.org/r/20260119230133.3551867-8-david@kernel.org
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

 drivers/misc/vmw_balloon.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/misc/vmw_balloon.c~vmw_balloon-stop-using-the-balloon_dev_info-lock
+++ a/drivers/misc/vmw_balloon.c
@@ -354,11 +354,16 @@ struct vmballoon {
 	/**
 	 * @huge_pages - list of the inflated 2MB pages.
 	 *
-	 * Protected by @b_dev_info.pages_lock .
+	 * Protected by @huge_pages_lock.
 	 */
 	struct list_head huge_pages;
 
 	/**
+	 * @huge_pages_lock: lock for the list of inflated 2MB pages.
+	 */
+	spinlock_t huge_pages_lock;
+
+	/**
 	 * @vmci_doorbell.
 	 *
 	 * Protected by @conf_sem.
@@ -987,7 +992,6 @@ static void vmballoon_enqueue_page_list(
 					unsigned int *n_pages,
 					enum vmballoon_page_size_type page_size)
 {
-	unsigned long flags;
 	struct page *page;
 
 	if (page_size == VMW_BALLOON_4K_PAGE) {
@@ -995,9 +999,9 @@ static void vmballoon_enqueue_page_list(
 	} else {
 		/*
 		 * Keep the huge pages in a local list which is not available
-		 * for the balloon compaction mechanism.
+		 * for the balloon page migration.
 		 */
-		spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
+		spin_lock(&b->huge_pages_lock);
 
 		list_for_each_entry(page, pages, lru) {
 			vmballoon_mark_page_offline(page, VMW_BALLOON_2M_PAGE);
@@ -1006,7 +1010,7 @@ static void vmballoon_enqueue_page_list(
 		list_splice_init(pages, &b->huge_pages);
 		__count_vm_events(BALLOON_INFLATE, *n_pages *
 				  vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
-		spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
+		spin_unlock(&b->huge_pages_lock);
 	}
 
 	*n_pages = 0;
@@ -1033,7 +1037,6 @@ static void vmballoon_dequeue_page_list(
 {
 	struct page *page, *tmp;
 	unsigned int i = 0;
-	unsigned long flags;
 
 	/* In the case of 4k pages, use the compaction infrastructure */
 	if (page_size == VMW_BALLOON_4K_PAGE) {
@@ -1043,7 +1046,7 @@ static void vmballoon_dequeue_page_list(
 	}
 
 	/* 2MB pages */
-	spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
+	spin_lock(&b->huge_pages_lock);
 	list_for_each_entry_safe(page, tmp, &b->huge_pages, lru) {
 		vmballoon_mark_page_online(page, VMW_BALLOON_2M_PAGE);
 
@@ -1054,7 +1057,7 @@ static void vmballoon_dequeue_page_list(
 
 	__count_vm_events(BALLOON_DEFLATE,
 			  i * vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
-	spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
+	spin_unlock(&b->huge_pages_lock);
 	*n_pages = i;
 }
 
@@ -1828,6 +1831,7 @@ static int __init vmballoon_init(void)
 		balloon.b_dev_info.migratepage = vmballoon_migratepage;
 
 	INIT_LIST_HEAD(&balloon.huge_pages);
+	spin_lock_init(&balloon.huge_pages_lock);
 	spin_lock_init(&balloon.comm_lock);
 	init_rwsem(&balloon.conf_sem);
 	balloon.vmci_doorbell = VMCI_INVALID_HANDLE;
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

