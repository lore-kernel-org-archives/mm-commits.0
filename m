Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C5720CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898244; cv=none; b=SopPz7Vdxihk+/WM7aVJO9muhdDODBrF1C0EulnBUPRPrGvaWDIFyxnn1Slnj3S6mEVwiqrPVdC+5yZ04lzTty/Rw+2eb+IOr6+TIpLnkIotwx+oy+1ouuYSaDAq/AQ+3BPVHz1s++gweWEGa3H6qFNt6nxGr9y2266JfKHEKLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898244; c=relaxed/simple;
	bh=wu0y01+wk9kQuQeoxwx6bdabqP0J5qbWFysdsurTZ30=;
	h=Date:To:From:Subject:Message-Id; b=G5DFSTIdbg1feZSdRK1MBp2HflfU9n2COlX+B/ZT9v2GSDL9tMLENVltYM9FDlsYBxXyyUA1d74ylOKqNnA0XHOvoQCHkPCibHZFMSefkmNzjc6xOwv3N9asdwhFQSAlzSz1qrJaV/i8fzsr8xSZztiThEyQ5WYSpAuAftJNpfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y1xTgkiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y1xTgkiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65183C4CEF1;
	Sat, 31 Jan 2026 22:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898244;
	bh=wu0y01+wk9kQuQeoxwx6bdabqP0J5qbWFysdsurTZ30=;
	h=Date:To:From:Subject:From;
	b=Y1xTgkizxstmM0BkBkOQfKPGImHVmZ3aIVa16UWq2oLkwbi1DCGKVp8hkW4wiMQjw
	 raJV5FZ4y9pFI8Topb60Qtc6tWzLQfIzMTvOS2ut9ZCpX97BHp0CbRAAqL5VEAhUNK
	 aqNHbv7MizSOeZYE/Mr8eFoPjt94LP093rryMDCM=
Date: Sat, 31 Jan 2026 14:24:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-pseries-cmm-remove-cmm_balloon_compaction_init.patch removed from -mm tree
Message-Id: <20260131222404.65183C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/pseries/cmm: remove cmm_balloon_compaction_init()
has been removed from the -mm tree.  Its filename was
     powerpc-pseries-cmm-remove-cmm_balloon_compaction_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: powerpc/pseries/cmm: remove cmm_balloon_compaction_init()
Date: Tue, 20 Jan 2026 00:01:11 +0100

Now that there is not a lot of logic left, let's just inline setting up
the migration function.

To avoid #ifdef in the caller we can instead use IS_ENABLED() and make the
compiler happy by only providing the function declaration.

Now that the function is gone, drop the "out_balloon_compaction" label. 
Note that before commit 68f2736a8583 ("mm: Convert all PageMovable users
to movable_operations") we actually had to undo something, now not
anymore.

Link: https://lkml.kernel.org/r/20260119230133.3551867-4-david@kernel.org
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

 arch/powerpc/platforms/pseries/cmm.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/arch/powerpc/platforms/pseries/cmm.c~powerpc-pseries-cmm-remove-cmm_balloon_compaction_init
+++ a/arch/powerpc/platforms/pseries/cmm.c
@@ -548,15 +548,9 @@ static int cmm_migratepage(struct balloo
 
 	return 0;
 }
-
-static void cmm_balloon_compaction_init(void)
-{
-	b_dev_info.migratepage = cmm_migratepage;
-}
 #else /* CONFIG_BALLOON_COMPACTION */
-static void cmm_balloon_compaction_init(void)
-{
-}
+int cmm_migratepage(struct balloon_dev_info *b_dev_info, struct page *newpage,
+		    struct page *page, enum migrate_mode mode);
 #endif /* CONFIG_BALLOON_COMPACTION */
 
 /**
@@ -573,11 +567,12 @@ static int cmm_init(void)
 		return -EOPNOTSUPP;
 
 	balloon_devinfo_init(&b_dev_info);
-	cmm_balloon_compaction_init();
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		b_dev_info.migratepage = cmm_migratepage;
 
 	rc = register_oom_notifier(&cmm_oom_nb);
 	if (rc < 0)
-		goto out_balloon_compaction;
+		return rc;
 
 	if ((rc = register_reboot_notifier(&cmm_reboot_nb)))
 		goto out_oom_notifier;
@@ -606,7 +601,6 @@ out_reboot_notifier:
 	unregister_reboot_notifier(&cmm_reboot_nb);
 out_oom_notifier:
 	unregister_oom_notifier(&cmm_oom_nb);
-out_balloon_compaction:
 	return rc;
 }
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

