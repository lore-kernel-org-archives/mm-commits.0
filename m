Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C731E0DCB;
	Sat,  3 Jan 2026 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767463546; cv=none; b=Q5foNTuYVHRtdsqp5pE6hqRAJ+neG23g69cTYh6hd3anikZzmijmgiXZvT2JJjqqljlgL2CfMzNi07ptOzWPH2fCxPkelvAt+SYEZv74y9gkCjKR8LxoZ+IYGnjUErBHDEn4Rtq/Rm5vUwi4Fi1YI83RFw+BKUpR0mC8DjZ/zA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767463546; c=relaxed/simple;
	bh=vIeZd9TujoJpzV0ubasbi9v64y5IJWNSWiK9NxtOVdA=;
	h=Date:To:From:Subject:Message-Id; b=hU06Pu2bUSN6WbXtg4DXvUqa1OI5kdOArtOfW+5De3DaMREjsN+YSf6B4Ug4UngP+uBTITH1jOx626HK0YXCkwpY47YUb6KoEyrgVxcHKpWubrEMIdtMBaLL6vmM1lX+qOfl6fy1Vs7vo0D/FfgOW9vVNFsn9KFYzvHKAbUGc0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hrtmLWxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hrtmLWxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BE1C113D0;
	Sat,  3 Jan 2026 18:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767463546;
	bh=vIeZd9TujoJpzV0ubasbi9v64y5IJWNSWiK9NxtOVdA=;
	h=Date:To:From:Subject:From;
	b=hrtmLWxigkl14TEXytsH+8jtD7z/vhdPn4FNWDlqmS16FCH/gkpfWX2jjVhd+6J9H
	 P1ZhC17qw+waUUFqiy6+SQ+oTJeFoBHURSQZ7TkZqy+HJrOEdSPb9K2YMUNP3Yfu7w
	 fwEzFyMMY1RDVqwwcDbgxPo7SpPJzbF2h+ETZmEg=
Date: Sat, 03 Jan 2026 10:05:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,miklos@szeredi.hu,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,j.neuschaefer@gmx.net,jack@suse.cz,david@kernel.org,carnil@debian.org,brauner@kernel.org,athul.krishna.kr@protonmail.com,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-writeback-skip-as_no_data_integrity-mappings-in-wait_sb_inodes.patch added to mm-hotfixes-unstable branch
Message-Id: <20260103180546.07BE1C113D0@smtp.kernel.org>
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
Date: Sun, 14 Dec 2025 19:00:43 -0800

Skip waiting on writeback for inodes that belong to mappings that do not
have data integrity guarantees (denoted by the AS_NO_DATA_INTEGRITY
mapping flag).

This restores fuse back to prior behavior where syncs are no-ops.  This is
needed because otherwise, if a system is running a faulty fuse server that
does not reply to issued write requests, this will cause wait_sb_inodes()
to wait forever.

Link: https://lkml.kernel.org/r/20251215030043.1431306-2-joannelkoong@gmail.com
Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb tree")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
Reported-by: J. Neuschäfer <j.neuschaefer@gmx.net>
Cc: Bonaccorso Salvatore <carnil@debian.org>
Cc: Jonathan Neuschaefer <j.neuschaefer@gmx.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c       |    3 ++-
 fs/fuse/file.c          |    4 +++-
 include/linux/pagemap.h |   11 +++++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

--- a/fs/fs-writeback.c~fs-writeback-skip-as_no_data_integrity-mappings-in-wait_sb_inodes
+++ a/fs/fs-writeback.c
@@ -2751,7 +2751,8 @@ static void wait_sb_inodes(struct super_
 		 * do not have the mapping lock. Skip it here, wb completion
 		 * will remove it.
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

