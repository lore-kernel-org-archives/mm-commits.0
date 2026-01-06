Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0E654723;
	Tue,  6 Jan 2026 01:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767664110; cv=none; b=ZtgLFHoZoPoedkWdVHo4arFEuv0qM0ccklV7pEzSwirHpAbjeQbBPD1eQi/L5PQiw58nlsrQq9+9WdAoYlYvWc7wdAKsyCDVBPQ/1hSlBkcfDlQ+8j4Xq9qIMuIsgyk6JiHHmQpRdmVfrYQkR+fW2lBTgaWG5n5STIXbmhBu7RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767664110; c=relaxed/simple;
	bh=l53VTd+SUEtW2mClevWwfpcJcMJZXRxVtzOKWmw3DQA=;
	h=Date:To:From:Subject:Message-Id; b=Htah2Ouf+j9p5+5oddGZSqTxZyFy7TnMLmTSBNmLLuMLjzJ85ewkvJtFZFOaeqKbuFHOEo8/AMh4BQeLypxGVGdv70VCb0Cetuak5MTJsoiK7QbFro88o1x6uBZCcNGrwY3RZQgiRFhnAvw+VcFeEIWSmFIQMOPrMC54xx9FCw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aF1jiQcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aF1jiQcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC96C116D0;
	Tue,  6 Jan 2026 01:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767664109;
	bh=l53VTd+SUEtW2mClevWwfpcJcMJZXRxVtzOKWmw3DQA=;
	h=Date:To:From:Subject:From;
	b=aF1jiQcLg95m0D63pwyUHyG9dQSBBK3wPbhrq0Wnci+zPq6aFAEq4QO5ao/0Yyak7
	 wmeP9iHpvx+pwtWI3sVIo5iMuZYB6lQdpCJVBUSgB0TZR34Sd48pggsgMz853WWQiN
	 n3LVusCvcIX3zAdb8GIMZULb7pq6bvSx9KrOzEfM=
Date: Mon, 05 Jan 2026 17:48:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,miklos@szeredi.hu,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,j.neuschaefer@gmx.net,jack@suse.cz,david@kernel.org,carnil@debian.org,bschubert@ddn.com,brauner@kernel.org,athul.krishna.kr@protonmail.com,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-writeback-skip-as_no_data_integrity-mappings-in-wait_sb_inodes.patch added to mm-hotfixes-unstable branch
Message-Id: <20260106014829.CFC96C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-writeback-skip-as_no_data_integrity-mappings-in-wait_sb_inodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-writeback-skip-as_no_data_integrity-mappings-in-wait_sb_inodes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()
Date: Mon, 5 Jan 2026 13:17:27 -0800

Above the while() loop in wait_sb_inodes(), we document that we must wait
for all pages under writeback for data integrity.  Consequently, if a
mapping, like fuse, traditionally does not have data integrity semantics,
there is no need to wait at all; we can simply skip these inodes.

This restores fuse back to prior behavior where syncs are no-ops.  This
fixes a user regression where if a system is running a faulty fuse server
that does not reply to issued write requests, this causes wait_sb_inodes()
to wait forever.

Link: https://lkml.kernel.org/r/20260105211737.4105620-2-joannelkoong@gmail.com
Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb tree")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
Reported-by: J. Neuschäfer <j.neuschaefer@gmx.net>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Tested-by: J. Neuschäfer <j.neuschaefer@gmx.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Bernd Schubert <bschubert@ddn.com>
Cc: Bonaccorso Salvatore <carnil@debian.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c       |    7 ++++++-
 fs/fuse/file.c          |    4 +++-
 include/linux/pagemap.h |   11 +++++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/fs/fs-writeback.c~fs-writeback-skip-as_no_data_integrity-mappings-in-wait_sb_inodes
+++ a/fs/fs-writeback.c
@@ -2750,8 +2750,13 @@ static void wait_sb_inodes(struct super_
 		 * The mapping can appear untagged while still on-list since we
 		 * do not have the mapping lock. Skip it here, wb completion
 		 * will remove it.
+		 *
+		 * If the mapping does not have data integrity semantics,
+		 * there's no need to wait for the writeout to complete, as the
+		 * mapping cannot guarantee that data is persistently stored.
 		 */
-		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
+		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
+		    mapping_no_data_integrity(mapping))
 			continue;
 
 		spin_unlock_irq(&sb->s_inode_wblist_lock);
--- a/fs/fuse/file.c~fs-writeback-skip-as_no_data_integrity-mappings-in-wait_sb_inodes
+++ a/fs/fuse/file.c
@@ -3200,8 +3200,10 @@ void fuse_init_file_inode(struct inode *
 
 	inode->i_fop = &fuse_file_operations;
 	inode->i_data.a_ops = &fuse_file_aops;
-	if (fc->writeback_cache)
+	if (fc->writeback_cache) {
 		mapping_set_writeback_may_deadlock_on_reclaim(&inode->i_data);
+		mapping_set_no_data_integrity(&inode->i_data);
+	}
 
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
--- a/include/linux/pagemap.h~fs-writeback-skip-as_no_data_integrity-mappings-in-wait_sb_inodes
+++ a/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_NO_DATA_INTEGRITY = 11, /* no data integrity guarantees */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -345,6 +346,16 @@ static inline bool mapping_writeback_may
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline void mapping_set_no_data_integrity(struct address_space *mapping)
+{
+	set_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
+}
+
+static inline bool mapping_no_data_integrity(const struct address_space *mapping)
+{
+	return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

fs-writeback-skip-as_no_data_integrity-mappings-in-wait_sb_inodes.patch

