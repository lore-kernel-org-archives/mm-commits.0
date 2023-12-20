Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B334F887
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vf7cz+p5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F14C433C8;
	Wed, 20 Dec 2023 23:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113420;
	bh=OIanVO3C8oen4dCCniwrepmM7zSAqVH20Wfwwu/T0+Y=;
	h=Date:To:From:Subject:From;
	b=vf7cz+p54fRHLQg+JhuC+7AJxsRLPhqc2CVsFSZIddKTJm6D0FGLEBr5ARSjiAC99
	 WDzO7Clx5lwwdLyYQcZ85mOJISU9XoesJL2f4PHMPFeKt8dEHZCBURFOwx1qBpNYx7
	 gzhM6p4qCT2kfU3W/FElZe6A+scvH4kepGqWN5rs=
Date: Wed, 20 Dec 2023 15:03:40 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-switch-warn_ons-to-warning-output-in-nilfs_sufile_do_free.patch removed from -mm tree
Message-Id: <20231220230340.B9F14C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: switch WARN_ONs to warning output in nilfs_sufile_do_free()
has been removed from the -mm tree.  Its filename was
     nilfs2-switch-warn_ons-to-warning-output-in-nilfs_sufile_do_free.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: switch WARN_ONs to warning output in nilfs_sufile_do_free()
Date: Thu, 7 Dec 2023 13:57:30 +0900

nilfs_sufile_do_free(), which is called when log write fails or during GC,
uses WARN_ONs to check for abnormal status of metadata.  In the former
case, these WARN_ONs will not be fired, but in the latter case they don't
"never-happen".  It is possible to trigger these by intentionally
modifying the userland GC library to release segments that are not in the
expected state.

So, replace them with warning output using the dedicated macro
nilfs_warn().

This replaces two potentially triggered WARN_ONs with ones that use a
warning output macro.

Link: https://lkml.kernel.org/r/20231207045730.5205-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/sufile.c~nilfs2-switch-warn_ons-to-warning-output-in-nilfs_sufile_do_free
+++ a/fs/nilfs2/sufile.c
@@ -471,10 +471,15 @@ void nilfs_sufile_do_free(struct inode *
 		kunmap_atomic(kaddr);
 		return;
 	}
-	WARN_ON(nilfs_segment_usage_error(su));
-	WARN_ON(!nilfs_segment_usage_dirty(su));
+	if (unlikely(nilfs_segment_usage_error(su)))
+		nilfs_warn(sufile->i_sb, "free segment %llu marked in error",
+			   (unsigned long long)segnum);
 
 	sudirty = nilfs_segment_usage_dirty(su);
+	if (unlikely(!sudirty))
+		nilfs_warn(sufile->i_sb, "free unallocated segment %llu",
+			   (unsigned long long)segnum);
+
 	nilfs_segment_usage_set_clean(su);
 	kunmap_atomic(kaddr);
 	mark_buffer_dirty(su_bh);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


