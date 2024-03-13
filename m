Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F6A818;
	Wed, 13 Mar 2024 18:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710354640; cv=none; b=NXZM2R6gUUK/jw6PewVCdvaZ483MeGrV+mSYTu6xFYhJUarRbknUfgwbl3JxlRzxyhoCP+Mc10TE+Gpdq38a0gACjMWDrq+PpIiAtJtoPLU65U1QwR5tOV+yZg9OhpZ/GSIM2/gNTQiLXKmlVJU9L+uXofpUm7tjIhxvDIenXEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710354640; c=relaxed/simple;
	bh=Oyl2mB/F+cj2Xy76y7cAyd1gHQIlsbJEvNgvAB3oj3M=;
	h=Date:To:From:Subject:Message-Id; b=kVYyLRhFNaiw/xAp0S3mbwFOKTZFKoeCY0BTijc9j+u/RYQBcFsyRfd7nSeGv13YpD+okE0uwUbH+0JejfgtpTwEqUPype3O56bRuxODrP/z+mEyZO3DFeugpCIQ3Xx47g0d7tfVpcaIg18/0R0uAsZVU/2CLKhLa9BxBJ5DP4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qUJPTwAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qUJPTwAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF383C43394;
	Wed, 13 Mar 2024 18:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710354639;
	bh=Oyl2mB/F+cj2Xy76y7cAyd1gHQIlsbJEvNgvAB3oj3M=;
	h=Date:To:From:Subject:From;
	b=qUJPTwAnkRlP/ksycCbHau/e6A1TtC8k0FQAx44VuqeXsTgElgyClFlHzPP+f10Tu
	 ZSxUihDgHyMIhWI3O6tXBtQC5pNoD/mlUHYXYFPgHw9REBS3Iz2DI3KN/sPgbbv3nE
	 yrpP3qWlRNK0WlHVrDeB///ARM91WO9QRUTbsR/4=
Date: Wed, 13 Mar 2024 11:30:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-failure-to-detect-dat-corruption-in-btree-and-direct-mappings.patch added to mm-nonmm-unstable branch
Message-Id: <20240313183039.AF383C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix failure to detect DAT corruption in btree and direct mappings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-fix-failure-to-detect-dat-corruption-in-btree-and-direct-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-failure-to-detect-dat-corruption-in-btree-and-direct-mappings.patch

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

nilfs2-fix-failure-to-detect-dat-corruption-in-btree-and-direct-mappings.patch
nilfs2-prevent-kernel-bug-at-submit_bh_wbc.patch

