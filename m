Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2477351F;
	Thu, 14 Mar 2024 16:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710433074; cv=none; b=Nbh4CNeTJ3wsBvu8lfjVGDS0SaPreHf6/FAcxNLemhveeAoPfs/CUiiesYF76BhGJI9khQcZhsiShf4pBWgNTE82JuaLJHMyOB8BdxJn98uFm0kFSvhT9crnGgqHzc9r/a4ATCOBWnRMI3tCIcV79eE3nu0y7sfpHp+ljIcm/oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710433074; c=relaxed/simple;
	bh=pqWUe6iu0cSD1SxQVNemxvyrqsX9NGbkRlKgfC0H2cc=;
	h=Date:To:From:Subject:Message-Id; b=EGAywsxZLyoMzbSpADBdNtX9rBmlzgIUUwnPmlXk4iSpfCfaE2BVw3TAn8xCUYRX/NEd03J3mhZCPIt1SnMCPm1EyrAJl+QWuh8MOZoDpgq057/kabGPcXSK4IgRZCImGikV3LFODo6+76jCvXjGxCn7PzN+/oN3gRYUVRXDeho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tk8MI8Up; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tk8MI8Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8020FC433C7;
	Thu, 14 Mar 2024 16:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710433073;
	bh=pqWUe6iu0cSD1SxQVNemxvyrqsX9NGbkRlKgfC0H2cc=;
	h=Date:To:From:Subject:From;
	b=Tk8MI8UpgSNFQ/YKCSUfKmN2u5tCQ+3Heazu+ZO6nxiQzjYIamnfeHNhoNIDfsgLl
	 qDZupI/0Zby00tVYVYYfHzjKxgEk3lwVAjK7PnzD1Hz5CnKBUhKLyet2gUvVhCDJuH
	 eJ+egOLXgP3SWaL1oxWdSVU2BSMU/l+1X1xsGxDI=
Date: Thu, 14 Mar 2024 09:17:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-fix-failure-to-detect-dat-corruption-in-btree-and-direct-mappings.patch removed from -mm tree
Message-Id: <20240314161753.8020FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix failure to detect DAT corruption in btree and direct mappings
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-failure-to-detect-dat-corruption-in-btree-and-direct-mappings.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix failure to detect DAT corruption in btree and direct mappings
Date: Wed, 13 Mar 2024 19:58:26 +0900

Patch series "nilfs2: fix kernel bug at submit_bh_wbc()".

This resolves a kernel BUG reported by syzbot.  Since there are two
flaws involved, I've made each one a separate patch.

The first patch alone resolves the syzbot-reported bug, but I think
both fixes should be sent to stable, so I've tagged them as such.


This patch (of 2):

Syzbot has reported a kernel bug in submit_bh_wbc() when writing file data
to a nilfs2 file system whose metadata is corrupted.

There are two flaws involved in this issue.

The first flaw is that when nilfs_get_block() locates a data block using
btree or direct mapping, if the disk address translation routine
nilfs_dat_translate() fails with internal code -ENOENT due to DAT metadata
corruption, it can be passed back to nilfs_get_block().  This causes
nilfs_get_block() to misidentify an existing block as non-existent,
causing both data block lookup and insertion to fail inconsistently.

The second flaw is that nilfs_get_block() returns a successful status in
this inconsistent state.  This causes the caller __block_write_begin_int()
or others to request a read even though the buffer is not mapped,
resulting in a BUG_ON check for the BH_Mapped flag in submit_bh_wbc()
failing.

This fixes the first issue by changing the return value to code -EINVAL
when a conversion using DAT fails with code -ENOENT, avoiding the
conflicting condition that leads to the kernel bug described above.  Here,
code -EINVAL indicates that metadata corruption was detected during the
block lookup, which will be properly handled as a file system error and
converted to -EIO when passing through the nilfs2 bmap layer.

Link: https://lkml.kernel.org/r/20240313105827.5296-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240313105827.5296-2-konishi.ryusuke@gmail.com
Fixes: c3a7abf06ce7 ("nilfs2: support contiguous lookup of blocks")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+cfed5b56649bddf80d6e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cfed5b56649bddf80d6e
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c  |    9 +++++++--
 fs/nilfs2/direct.c |    9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/btree.c~nilfs2-fix-failure-to-detect-dat-corruption-in-btree-and-direct-mappings
+++ a/fs/nilfs2/btree.c
@@ -724,7 +724,7 @@ static int nilfs_btree_lookup_contig(con
 		dat = nilfs_bmap_get_dat(btree);
 		ret = nilfs_dat_translate(dat, ptr, &blocknr);
 		if (ret < 0)
-			goto out;
+			goto dat_error;
 		ptr = blocknr;
 	}
 	cnt = 1;
@@ -743,7 +743,7 @@ static int nilfs_btree_lookup_contig(con
 			if (dat) {
 				ret = nilfs_dat_translate(dat, ptr2, &blocknr);
 				if (ret < 0)
-					goto out;
+					goto dat_error;
 				ptr2 = blocknr;
 			}
 			if (ptr2 != ptr + cnt || ++cnt == maxblocks)
@@ -781,6 +781,11 @@ static int nilfs_btree_lookup_contig(con
  out:
 	nilfs_btree_free_path(path);
 	return ret;
+
+ dat_error:
+	if (ret == -ENOENT)
+		ret = -EINVAL;  /* Notify bmap layer of metadata corruption */
+	goto out;
 }
 
 static void nilfs_btree_promote_key(struct nilfs_bmap *btree,
--- a/fs/nilfs2/direct.c~nilfs2-fix-failure-to-detect-dat-corruption-in-btree-and-direct-mappings
+++ a/fs/nilfs2/direct.c
@@ -66,7 +66,7 @@ static int nilfs_direct_lookup_contig(co
 		dat = nilfs_bmap_get_dat(direct);
 		ret = nilfs_dat_translate(dat, ptr, &blocknr);
 		if (ret < 0)
-			return ret;
+			goto dat_error;
 		ptr = blocknr;
 	}
 
@@ -79,7 +79,7 @@ static int nilfs_direct_lookup_contig(co
 		if (dat) {
 			ret = nilfs_dat_translate(dat, ptr2, &blocknr);
 			if (ret < 0)
-				return ret;
+				goto dat_error;
 			ptr2 = blocknr;
 		}
 		if (ptr2 != ptr + cnt)
@@ -87,6 +87,11 @@ static int nilfs_direct_lookup_contig(co
 	}
 	*ptrp = ptr;
 	return cnt;
+
+ dat_error:
+	if (ret == -ENOENT)
+		ret = -EINVAL;  /* Notify bmap layer of metadata corruption */
+	return ret;
 }
 
 static __u64
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


