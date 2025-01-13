Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D59315624B
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742190; cv=none; b=hKnpRZ5w3RpK/bmrecaqpkfZ0XRdkip2ZE1LUKCX8T9x32rQL0Aku9JzUfc61S68sWHVXgCrdXTYG3aaGJ7o1rZtgUkJrzvsu5uEy6J8wUHcRwaGMev84zZ3dKXnMfPpE9mA3y435Y8ibz40AX7NGv2+ofm0zm0zqzPuq85quH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742190; c=relaxed/simple;
	bh=aQH2uXu9vxyZmdkyBQbcXYvNS1uvHobXLtw552IwJmQ=;
	h=Date:To:From:Subject:Message-Id; b=a90Dc8CbEYvAzKYctIhR0kWCppb7S8KKyaUlI+tR0DXFuKee0dyBDh8Xof7YkhONqb5g0tSNc9r4dPxjqk8Yjdr1MZMxhGzFZqQYrwA+QXshgFalETZdwy+swlRtVuvrjD49HcgnQu3exYXT8sVcvItmMWrR60czYTAeqFPnJAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CtfmJhZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CtfmJhZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31611C4CED6;
	Mon, 13 Jan 2025 04:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742190;
	bh=aQH2uXu9vxyZmdkyBQbcXYvNS1uvHobXLtw552IwJmQ=;
	h=Date:To:From:Subject:From;
	b=CtfmJhZTLkvy40bpkJjJ+8mqUM7zyefm1rayItc9ScU6GtL3eyIpNCJoJrDIDbMgs
	 G8tHMxOaGF4PRhPWhI29dUrD8nk7LKkpFwunnF3CamL+xJlhLb/AttFzSy+hy1IzHl
	 kJr25ByA0E6LB5hOn8YouxomoKbkxk+IWESCw2Ds=
Date: Sun, 12 Jan 2025 20:23:09 -0800
To: mm-commits@vger.kernel.org,rgoldwyn@suse.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,sandeen@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] dlmfs-convert-to-the-new-mount-api.patch removed from -mm tree
Message-Id: <20250113042310.31611C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dlmfs: convert to the new mount API
has been removed from the -mm tree.  Its filename was
     dlmfs-convert-to-the-new-mount-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Sandeen <sandeen@redhat.com>
Subject: dlmfs: convert to the new mount API
Date: Mon, 28 Oct 2024 09:41:14 -0500

Patch series "ocfs2, dlmfs: convert to the new mount API".


This patch (of 2):

Convert dlmfs to the new mount API.

Link: https://lkml.kernel.org/r/20241028144443.609151-1-sandeen@redhat.com
Link: https://lkml.kernel.org/r/20241028144443.609151-2-sandeen@redhat.com
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/dlmfs.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/dlmfs/dlmfs.c~dlmfs-convert-to-the-new-mount-api
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -20,6 +20,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/fs_context.h>
 #include <linux/pagemap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -506,9 +507,7 @@ bail:
 	return status;
 }
 
-static int dlmfs_fill_super(struct super_block * sb,
-			    void * data,
-			    int silent)
+static int dlmfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_SIZE;
@@ -556,17 +555,27 @@ static const struct inode_operations dlm
 	.setattr	= dlmfs_file_setattr,
 };
 
-static struct dentry *dlmfs_mount(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data)
+static int dlmfs_get_tree(struct fs_context *fc)
 {
-	return mount_nodev(fs_type, flags, data, dlmfs_fill_super);
+	return get_tree_nodev(fc, dlmfs_fill_super);
+}
+
+static const struct fs_context_operations dlmfs_context_ops = {
+	.get_tree       = dlmfs_get_tree,
+};
+
+static int dlmfs_init_fs_context(struct fs_context *fc)
+{
+	fc->ops = &dlmfs_context_ops;
+
+	return 0;
 }
 
 static struct file_system_type dlmfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ocfs2_dlmfs",
-	.mount		= dlmfs_mount,
 	.kill_sb	= kill_litter_super,
+	.init_fs_context = dlmfs_init_fs_context,
 };
 MODULE_ALIAS_FS("ocfs2_dlmfs");
 
_

Patches currently in -mm which might be from sandeen@redhat.com are


