Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40FA2DA742
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 20:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750883201; cv=none; b=Jo/DEn8ax6pNL2T5go09Eu0GMlt8ALqxVqQBcF9cLojNUkIAK/y+i4eoYPR/UuMgJW/bHbPwesM5gJ5+92KqJGUjVX2d8MH9g3JtFEfP1wZKe8+9J4JbqSIpT5Uf4xXsrqoBVvYjPd8vtzaZoi27Y9yQSBoGrrniGaHGFRM3ILQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750883201; c=relaxed/simple;
	bh=z72b3GOeECmnxE9aoC+gekhMzKMoNqs3c1eksazwqMM=;
	h=Date:To:From:Subject:Message-Id; b=UL8O/rreeX1N5D0aQdFfteUXi7I4SS5md3hrmc3NDNL+7biN97q6YYRWoK4vvOOvEapO0gOs7EYlvPjWkeIUXda+mNmqHZIsIJI1kHNOrnr9tgWxHwSN4JLjONgdt6orcR4mNQzY1yprk1J0TfTpgDR9OBM1jZK4sQ894O1dAlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zXWv2MhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zXWv2MhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EEAC4CEEA;
	Wed, 25 Jun 2025 20:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750883201;
	bh=z72b3GOeECmnxE9aoC+gekhMzKMoNqs3c1eksazwqMM=;
	h=Date:To:From:Subject:From;
	b=zXWv2MhVbS/9kA+XE3yuFZMzoIXU2OtBOUzSjIj6mSAmLs5dm+opkP/EoAgb1n6Rc
	 75LJN2jcyxXirWQ87MLVib15vfOdrbikdPNnDzVJIRT8UmEzVO6S3r/c4fF00WWNqe
	 mQcBjFATXpLOTbVwLgRRLZtBh8GmPt+XSIyqeeX0=
Date: Wed, 25 Jun 2025 13:26:40 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,willy@infradead.org,tj@kernel.org,surenb@google.com,mszeredi@redhat.com,mpatlasov@parallels.com,mhocko@suse.com,kirill.shutemov@linux.intel.com,joannelkoong@gmail.com,jlayton@kernel.org,jefflexu@linux.alibaba.com,jack@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,corbet@lwn.net,axboe@kernel.dk,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter.patch added to mm-new branch
Message-Id: <20250625202641.32EEAC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, vmstat: remove the NR_WRITEBACK_TEMP node_stat_item counter
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, vmstat: remove the NR_WRITEBACK_TEMP node_stat_item counter
Date: Wed, 25 Jun 2025 17:51:52 +0200

The only user of the counter (FUSE) was removed in commit 0c58a97f919c
("fuse: remove tmp folio for writebacks and internal rb tree") so follow
the established pattern of removing the counter and hardcoding 0 in
meminfo output, as done recently with NR_BOUNCE.  Update documentation for
procfs, including for the value for Bounce that was missed when removing
its counter.

Link: https://lkml.kernel.org/r/20250625-nr_writeback_removal-v1-1-7f2a0df70faa@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    8 +++++---
 drivers/base/node.c                |    2 +-
 fs/proc/meminfo.c                  |    3 +--
 include/linux/mmzone.h             |    1 -
 mm/show_mem.c                      |    2 --
 mm/vmstat.c                        |    1 -
 6 files changed, 7 insertions(+), 10 deletions(-)

--- a/Documentation/filesystems/proc.rst~mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter
+++ a/Documentation/filesystems/proc.rst
@@ -1196,12 +1196,14 @@ SecPageTables
               Memory consumed by secondary page tables, this currently includes
               KVM mmu and IOMMU allocations on x86 and arm64.
 NFS_Unstable
-              Always zero. Previous counted pages which had been written to
+              Always zero. Previously counted pages which had been written to
               the server, but has not been committed to stable storage.
 Bounce
-              Memory used for block device "bounce buffers"
+              Always zero. Previously memory used for block device
+              "bounce buffers".
 WritebackTmp
-              Memory used by FUSE for temporary writeback buffers
+              Always zero. Previously memory used by FUSE for temporary
+              writeback buffers.
 CommitLimit
               Based on the overcommit ratio ('vm.overcommit_ratio'),
               this is the total amount of  memory currently available to
--- a/drivers/base/node.c~mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter
+++ a/drivers/base/node.c
@@ -500,7 +500,7 @@ static ssize_t node_read_meminfo(struct
 			     nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
 			     nid, 0UL,
 			     nid, 0UL,
-			     nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
+			     nid, 0UL,
 			     nid, K(sreclaimable +
 				    node_page_state(pgdat, NR_KERNEL_MISC_RECLAIMABLE)),
 			     nid, K(sreclaimable + sunreclaimable),
--- a/fs/proc/meminfo.c~mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter
+++ a/fs/proc/meminfo.c
@@ -121,8 +121,7 @@ static int meminfo_proc_show(struct seq_
 
 	show_val_kb(m, "NFS_Unstable:   ", 0);
 	show_val_kb(m, "Bounce:         ", 0);
-	show_val_kb(m, "WritebackTmp:   ",
-		    global_node_page_state(NR_WRITEBACK_TEMP));
+	show_val_kb(m, "WritebackTmp:   ", 0);
 	show_val_kb(m, "CommitLimit:    ", vm_commit_limit());
 	show_val_kb(m, "Committed_AS:   ", committed);
 	seq_printf(m, "VmallocTotal:   %8lu kB\n",
--- a/include/linux/mmzone.h~mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter
+++ a/include/linux/mmzone.h
@@ -206,7 +206,6 @@ enum node_stat_item {
 	NR_FILE_PAGES,
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
-	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
 	NR_SHMEM_THPS,
 	NR_SHMEM_PMDMAPPED,
--- a/mm/show_mem.c~mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter
+++ a/mm/show_mem.c
@@ -246,7 +246,6 @@ static void show_free_areas(unsigned int
 			" shmem_pmdmapped:%lukB"
 			" anon_thp:%lukB"
 #endif
-			" writeback_tmp:%lukB"
 			" kernel_stack:%lukB"
 #ifdef CONFIG_SHADOW_CALL_STACK
 			" shadow_call_stack:%lukB"
@@ -273,7 +272,6 @@ static void show_free_areas(unsigned int
 			K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)),
 			K(node_page_state(pgdat, NR_ANON_THPS)),
 #endif
-			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			node_page_state(pgdat, NR_KERNEL_STACK_KB),
 #ifdef CONFIG_SHADOW_CALL_STACK
 			node_page_state(pgdat, NR_KERNEL_SCS_KB),
--- a/mm/vmstat.c~mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter
+++ a/mm/vmstat.c
@@ -1251,7 +1251,6 @@ const char * const vmstat_text[] = {
 	[I(NR_FILE_PAGES)]			= "nr_file_pages",
 	[I(NR_FILE_DIRTY)]			= "nr_dirty",
 	[I(NR_WRITEBACK)]			= "nr_writeback",
-	[I(NR_WRITEBACK_TEMP)]			= "nr_writeback_temp",
 	[I(NR_SHMEM)]				= "nr_shmem",
 	[I(NR_SHMEM_THPS)]			= "nr_shmem_hugepages",
 	[I(NR_SHMEM_PMDMAPPED)]			= "nr_shmem_pmdmapped",
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-madvise-simplify-anon_name-handling.patch
mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch
mm-madvise-move-madvise_set_anon_name-down-the-file.patch
mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch
mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter.patch

