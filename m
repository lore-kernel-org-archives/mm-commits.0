Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9112220101D;
	Sun, 28 Sep 2025 18:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084644; cv=none; b=LEATQY9LQNkCm8I8DVWdonci0nI9C9azc/v/+zh46UxN/XVLyQ9O3SpY4Fk0eWQrMwPG1WFDH0WkE6iUzFUwmxXBUcS3OGbOtolsdRSPH8MCIfUIPk5JkXcKGw2aDrNJJ1V1BuN5uWeuCQ3aeidi6fzsveuEqMKhGTYCWQalZAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084644; c=relaxed/simple;
	bh=4HxYyThtko3m8wh7b/UYqFyetla9w8LVvqCpLSSWRZw=;
	h=Date:To:From:Subject:Message-Id; b=DXmLhTMJezpohY/XM4LEiNgdd2Tp0rsdMFnE3FogF8kzfu2ZzeGq0N+Iw0EVBcmu5nN0o7FoBwX9UChwgbnY1MKtsZ32ifHSCZONdFjt+s0NgumiIUWAQ54Pytvo2zdwsG85VSR/0GmJ/uLRJPJsoxvUARxF17wwczsUPhP0PAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FVGdiEJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FVGdiEJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9CAC4CEF0;
	Sun, 28 Sep 2025 18:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084644;
	bh=4HxYyThtko3m8wh7b/UYqFyetla9w8LVvqCpLSSWRZw=;
	h=Date:To:From:Subject:From;
	b=FVGdiEJDDknNJ7uYHTSd1XXMmUZXqGKRsA4CUwpcOplKZk4Sh0na80ji/DYNtDFN/
	 zwB4yzfXsKCUYsiX7UEKW1mFu6iG4LW5B+2uIB+8rfPpEM4K/DTVIoV1GecwY1kBzJ
	 vrU+2Pm4Ok7np7X+o2xVjy25mRP+lSQ61XHCWEmo=
Date: Sun, 28 Sep 2025 11:37:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,amir73il@gmail.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-reject-negative-file-sizes-in-squashfs_read_inode.patch removed from -mm tree
Message-Id: <20250928183724.5D9CAC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: reject negative file sizes in squashfs_read_inode()
has been removed from the -mm tree.  Its filename was
     squashfs-reject-negative-file-sizes-in-squashfs_read_inode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: reject negative file sizes in squashfs_read_inode()
Date: Fri, 26 Sep 2025 22:59:35 +0100

Syskaller reports a "WARNING in ovl_copy_up_file" in overlayfs.

This warning is ultimately caused because the underlying Squashfs file
system returns a file with a negative file size.

This commit checks for a negative file size and returns EINVAL.

[phillip@squashfs.org.uk: only need to check 64 bit quantity]
  Link: https://lkml.kernel.org/r/20250926222305.110103-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20250926215935.107233-1-phillip@squashfs.org.uk
Fixes: 6545b246a2c8 ("Squashfs: inode operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68d580e5.a00a0220.303701.0019.GAE@google.com/
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/squashfs/inode.c~squashfs-reject-negative-file-sizes-in-squashfs_read_inode
+++ a/fs/squashfs/inode.c
@@ -197,6 +197,10 @@ int squashfs_read_inode(struct inode *in
 			goto failed_read;
 
 		inode->i_size = le64_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 0) {
+			err = -EINVAL;
+			goto failed_read;
+		}
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
 			/*
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


