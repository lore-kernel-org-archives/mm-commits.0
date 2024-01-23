Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879094E1D2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970569; cv=none; b=PURLEahx1U6MP5K6+fAe8/zMBJMweh6TYK3WG3dvgb33XoaiWpZgd8OwOBOG5DLPgWH+8OkgZt7dPTxIzEO9JolzzAVJUEtdL944tD/hRWO4CnRSI3RYKxRCu/NWg0VTHQDi6ErprmYTLSpy0m5t48RrDtqIxEtyzWti34Q4QNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970569; c=relaxed/simple;
	bh=fbZcer5AQV5Y/Sez43u+t/gnchcVx7j3Lq6Ab/0sNa8=;
	h=Date:To:From:Subject:Message-Id; b=TWGIhqLHGxrZjUdPYLAxqKhTAbx53oiR3tFo3Vwwivy2XMy80qYVHxaOHlFqEBE/+AHobUSDORGmYffi2M2yNLJuFBldXgYgdgZgeCJWyGcDv+xhevssC+D9j1UducWfiiWV6rRy/fhypmHKaLwgonDhPIkXh9N7v3o2TmeHty4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iU2MD0lS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iU2MD0lS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA743C43390;
	Tue, 23 Jan 2024 00:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970569;
	bh=fbZcer5AQV5Y/Sez43u+t/gnchcVx7j3Lq6Ab/0sNa8=;
	h=Date:To:From:Subject:From;
	b=iU2MD0lSu9dVhN2Boh1Qb02X+j2D9DTJ2sxKQzDhHpGsI5wL2xZY46XdfnEnwG4k+
	 CPGEa3/wUxYdUzZ8OZyNhUZ7DLWOGtMxevUsgwUZEdZ+Noc58FQgrx4cSLK5ovTf2w
	 Q2A49XabkGhIsRNbekphU8i6iXltZ82Z4Khsmb58=
Date: Mon, 22 Jan 2024 16:42:45 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-dat-to-use-kmap_local.patch added to mm-nonmm-unstable branch
Message-Id: <20240123004248.DA743C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert DAT to use kmap_local
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-dat-to-use-kmap_local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-dat-to-use-kmap_local.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert DAT to use kmap_local
Date: Mon, 22 Jan 2024 23:01:54 +0900

Concerning the code of the metadata file DAT for disk address translation,
convert all parts that use the deprecated kmap_atomic to use kmap_local. 
All transformations are directly possible.

Link: https://lkml.kernel.org/r/20240122140202.6950-8-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dat.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/fs/nilfs2/dat.c~nilfs2-convert-dat-to-use-kmap_local
+++ a/fs/nilfs2/dat.c
@@ -91,13 +91,13 @@ void nilfs_dat_commit_alloc(struct inode
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_end = cpu_to_le64(NILFS_CNO_MAX);
 	entry->de_blocknr = cpu_to_le64(0);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	nilfs_palloc_commit_alloc_entry(dat, req);
 	nilfs_dat_commit_entry(dat, req);
@@ -115,13 +115,13 @@ static void nilfs_dat_commit_free(struct
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_end = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_blocknr = cpu_to_le64(0);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
 
@@ -145,12 +145,12 @@ void nilfs_dat_commit_start(struct inode
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(nilfs_mdt_cno(dat));
 	entry->de_blocknr = cpu_to_le64(blocknr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
 }
@@ -167,12 +167,12 @@ int nilfs_dat_prepare_end(struct inode *
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	if (blocknr == 0) {
 		ret = nilfs_palloc_prepare_free_entry(dat, req);
@@ -202,7 +202,7 @@ void nilfs_dat_commit_end(struct inode *
 	sector_t blocknr;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	end = start = le64_to_cpu(entry->de_start);
@@ -212,7 +212,7 @@ void nilfs_dat_commit_end(struct inode *
 	}
 	entry->de_end = cpu_to_le64(end);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	if (blocknr == 0)
 		nilfs_dat_commit_free(dat, req);
@@ -227,12 +227,12 @@ void nilfs_dat_abort_end(struct inode *d
 	sector_t blocknr;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
+	kaddr = kmap_local_page(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	if (start == nilfs_mdt_cno(dat) && blocknr == 0)
 		nilfs_palloc_abort_free_entry(dat, req);
@@ -362,7 +362,7 @@ int nilfs_dat_move(struct inode *dat, __
 		}
 	}
 
-	kaddr = kmap_atomic(entry_bh->b_page);
+	kaddr = kmap_local_page(entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	if (unlikely(entry->de_blocknr == cpu_to_le64(0))) {
 		nilfs_crit(dat->i_sb,
@@ -370,13 +370,13 @@ int nilfs_dat_move(struct inode *dat, __
 			   __func__, (unsigned long long)vblocknr,
 			   (unsigned long long)le64_to_cpu(entry->de_start),
 			   (unsigned long long)le64_to_cpu(entry->de_end));
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		brelse(entry_bh);
 		return -EINVAL;
 	}
 	WARN_ON(blocknr == 0);
 	entry->de_blocknr = cpu_to_le64(blocknr);
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	mark_buffer_dirty(entry_bh);
 	nilfs_mdt_mark_dirty(dat);
@@ -426,7 +426,7 @@ int nilfs_dat_translate(struct inode *da
 		}
 	}
 
-	kaddr = kmap_atomic(entry_bh->b_page);
+	kaddr = kmap_local_page(entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	blocknr = le64_to_cpu(entry->de_blocknr);
 	if (blocknr == 0) {
@@ -436,7 +436,7 @@ int nilfs_dat_translate(struct inode *da
 	*blocknrp = blocknr;
 
  out:
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 	brelse(entry_bh);
 	return ret;
 }
@@ -457,7 +457,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode
 						   0, &entry_bh);
 		if (ret < 0)
 			return ret;
-		kaddr = kmap_atomic(entry_bh->b_page);
+		kaddr = kmap_local_page(entry_bh->b_page);
 		/* last virtual block number in this block */
 		first = vinfo->vi_vblocknr;
 		do_div(first, entries_per_block);
@@ -473,7 +473,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode
 			vinfo->vi_end = le64_to_cpu(entry->de_end);
 			vinfo->vi_blocknr = le64_to_cpu(entry->de_blocknr);
 		}
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		brelse(entry_bh);
 	}
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-convert-recovery-logic-to-use-kmap_local.patch
nilfs2-convert-segment-buffer-to-use-kmap_local.patch
nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch
nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch
nilfs2-convert-sufile-to-use-kmap_local.patch
nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch
nilfs2-convert-dat-to-use-kmap_local.patch
nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch
nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch
nilfs2-convert-ifile-to-use-kmap_local.patch
nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch
nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch
nilfs2-convert-cpfile-to-use-kmap_local.patch

