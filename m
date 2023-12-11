Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C0579D8
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1AFjLJX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F567C433C7;
	Mon, 11 Dec 2023 01:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257758;
	bh=0IxeXOSto+FGxCS+J3M9CfHH7SbOtqzjM50kJBGYwAM=;
	h=Date:To:From:Subject:From;
	b=1AFjLJX32BIe+c7YT2Thoalli9zGmSIe5S/VEeQVpdYe349v0xBjPzYRAzml1QwRT
	 FBYd/cNyu6m26O+p1Y7PTy/ZQoWZZLmhZ8VUTjT85RYyf7+nJ11lkAkpNh7QY+qgua
	 U0nT4iaUi3r4noIQ2hYXJBzkqz++1sxmAN98s9Vk=
Date: Sun, 10 Dec 2023 17:22:37 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,airlied@redhat.com,pstanner@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-nilfs2-use-standard-array-copy-function.patch removed from -mm tree
Message-Id: <20231211012238.0F567C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/nilfs2: use standard array-copy-function
has been removed from the -mm tree.  Its filename was
     fs-nilfs2-use-standard-array-copy-function.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Philipp Stanner <pstanner@redhat.com>
Subject: fs/nilfs2: use standard array-copy-function
Date: Tue, 7 Nov 2023 07:44:16 +0900

ioctl.c utilizes memdup_user() to copy a userspace array.  An overflow
check is performed manually before the function's invocation.

The new function memdup_array_user() standardizes copying userspace
arrays, thus, improving readability by making it more clear that an array
is being copied.  Additionally, it also performs an overflow check.

Remove the (now redundant) manual overflow-check and replace memdup_user()
with memdup_array_user().

In addition, improve the grammar of the comment above
memdup_array_user().

Link: https://lkml.kernel.org/r/20231106224416.3055-1-konishi.ryusuke@gmail.com
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Link: https://lkml.kernel.org/r/20231103184831.99406-2-pstanner@redhat.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Suggested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/ioctl.c~fs-nilfs2-use-standard-array-copy-function
+++ a/fs/nilfs2/ioctl.c
@@ -872,16 +872,14 @@ static int nilfs_ioctl_clean_segments(st
 	nsegs = argv[4].v_nmembs;
 	if (argv[4].v_size != argsz[4])
 		goto out;
-	if (nsegs > UINT_MAX / sizeof(__u64))
-		goto out;
 
 	/*
 	 * argv[4] points to segment numbers this ioctl cleans.  We
-	 * use kmalloc() for its buffer because memory used for the
-	 * segment numbers is enough small.
+	 * use kmalloc() for its buffer because the memory used for the
+	 * segment numbers is small enough.
 	 */
-	kbufs[4] = memdup_user((void __user *)(unsigned long)argv[4].v_base,
-			       nsegs * sizeof(__u64));
+	kbufs[4] = memdup_array_user((void __user *)(unsigned long)argv[4].v_base,
+				     nsegs, sizeof(__u64));
 	if (IS_ERR(kbufs[4])) {
 		ret = PTR_ERR(kbufs[4]);
 		goto out;
_

Patches currently in -mm which might be from pstanner@redhat.com are


