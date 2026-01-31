Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD64420CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898242; cv=none; b=obrvauKM5gxwuunUy8lDYqw9MuDC2mUbeNj27+XZOS1ES86winI2DmQHm9EQ7g5gatE3O3AoZ5w5k/r76wCIC9AzcLWO+h0VUxp6tVWWYoV1tnXxss4Co9z8I9OnaT6lkBNiQ3xS8AOYanGZ/xq8xy6/VpC/eRvKlT4Lly29YcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898242; c=relaxed/simple;
	bh=tGW6EFHKIXwY0ARF3xH5rLoSPemaR1irR9QH70Am6J0=;
	h=Date:To:From:Subject:Message-Id; b=eMPNqxT5LBYHHwPltOEDo1qZ0L1rYK3V1ksgMQrwgQCju2XimbYU1diGdgoFlf3Ebhegb5j6rBNGkR6l9IhRn9N8Y26NERFovSQ0KwOM0aZEbRKCjJzLqMaMtLMf+46pJiD6vhSl65H4NknPAiDC19rBFNgsVwdWv6y1qRYxyz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m7BMVj/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m7BMVj/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28F4C4CEF1;
	Sat, 31 Jan 2026 22:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898242;
	bh=tGW6EFHKIXwY0ARF3xH5rLoSPemaR1irR9QH70Am6J0=;
	h=Date:To:From:Subject:From;
	b=m7BMVj/bpCzcI5lyJ3lCpjylzF/uEsEwGls2+bOIrOHw6VakJkJgm56utdC2F0Kbq
	 diqBSKZuvFM3K28KUnebp21RJDpqPE7kq+ILz2DUFnGPh0eYzsLtrEZwlyu56Dz8Pa
	 /bvOm88x28Y+5eH6PoDsmcOw+JR5jl6QrVvEbkBw=
Date: Sat, 31 Jan 2026 14:24:02 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmw_balloon-remove-vmballoon_compaction_init.patch removed from -mm tree
Message-Id: <20260131222402.B28F4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmw_balloon: remove vmballoon_compaction_init()
has been removed from the -mm tree.  Its filename was
     vmw_balloon-remove-vmballoon_compaction_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: vmw_balloon: remove vmballoon_compaction_init()
Date: Tue, 20 Jan 2026 00:01:10 +0100

Now that there is not a lot of logic left, let's just inline setting up
the migration function and drop all these excessive comments that are not
really required (or true) anymore.

To avoid #ifdef in the caller we can instead use IS_ENABLED() and make the
compiler happy by only providing the function declaration.

Link: https://lkml.kernel.org/r/20260119230133.3551867-3-david@kernel.org
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

 drivers/misc/vmw_balloon.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

--- a/drivers/misc/vmw_balloon.c~vmw_balloon-remove-vmballoon_compaction_init
+++ a/drivers/misc/vmw_balloon.c
@@ -1833,27 +1833,10 @@ out_unlock:
 	up_read(&b->conf_sem);
 	return ret;
 }
-
-/**
- * vmballoon_compaction_init() - initialized compaction for the balloon.
- *
- * @b: pointer to the balloon.
- *
- * If during the initialization a failure occurred, this function does not
- * perform cleanup. The caller must call vmballoon_compaction_deinit() in this
- * case.
- *
- * Return: zero on success or error code on failure.
- */
-static __init void vmballoon_compaction_init(struct vmballoon *b)
-{
-	b->b_dev_info.migratepage = vmballoon_migratepage;
-}
-
 #else /* CONFIG_BALLOON_COMPACTION */
-static inline void vmballoon_compaction_init(struct vmballoon *b)
-{
-}
+int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
+			  struct page *newpage, struct page *page,
+			  enum migrate_mode mode);
 #endif /* CONFIG_BALLOON_COMPACTION */
 
 static int __init vmballoon_init(void)
@@ -1873,12 +1856,9 @@ static int __init vmballoon_init(void)
 	if (error)
 		return error;
 
-	/*
-	 * Initialization of compaction must be done after the call to
-	 * balloon_devinfo_init() .
-	 */
 	balloon_devinfo_init(&balloon.b_dev_info);
-	vmballoon_compaction_init(&balloon);
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		balloon.b_dev_info.migratepage = vmballoon_migratepage;
 
 	INIT_LIST_HEAD(&balloon.huge_pages);
 	spin_lock_init(&balloon.comm_lock);
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

