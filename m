Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289351E991B
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 23:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766102362; cv=none; b=dckTgEOGDxixSP0dxjcohI8ELrS3eUknsutGBEoKS0l3b8hw7FNclwKOA9x8xPT1Wy1/+k3JqMfbxbwN7sDUStNg9zjCnnuewa7cMjDvQQEGGl70/tmBlv1wsokpHmwtSzD5+Fcb8Bf08mMtc7ysCaGEcYjwjEk2PE/3dA+rlVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766102362; c=relaxed/simple;
	bh=ZvOXEfkdHVwviIxnWoKSCWW40uI4nQujsbbEHianUv8=;
	h=Date:To:From:Subject:Message-Id; b=ecvKnvPkckhadZNk5gMGi5WdVvLWf/jeDQsQclGGjbkppaH96xJSRzWbvOcJTCapgUW00/kuSbANdVwIc/oGr16W6A8B9CqfC/EfKHdk4S9rArJK/1l3LN2e4HhW1g2nIpQtV7d2y9KJKtgSbwbMh7JjPCy62KazhyoqlQ/JC7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wW1K+EuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wW1K+EuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEACAC4CEFB;
	Thu, 18 Dec 2025 23:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766102360;
	bh=ZvOXEfkdHVwviIxnWoKSCWW40uI4nQujsbbEHianUv8=;
	h=Date:To:From:Subject:From;
	b=wW1K+EuYPoFBh179xFc0LjC9O873T/BRagAYSSjoOM+6rvDSpyNK/3OCwxWBoTK19
	 h5ucK4K31QpQynmTMOdDjZo2PyBxsXTM57GTrZCWhHaHvqW6AQ+zmj51bh4YdBEkE1
	 TQOFdlbQyhcAjDrFWS0/qz0GE/hDNXQvLCdefwbs=
Date: Thu, 18 Dec 2025 15:59:20 -0800
To: mm-commits@vger.kernel.org,kernel@xen0n.name,glider@google.com,elver@google.com,dvyukov@google.com,chenhuacai@kernel.org,yuanlinyu@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-allow-create-debugfs-dir-file-unconditionally.patch added to mm-new branch
Message-Id: <20251218235920.AEACAC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfence: allow create debugfs dir/file unconditionally
has been added to the -mm mm-new branch.  Its filename is
     kfence-allow-create-debugfs-dir-file-unconditionally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfence-allow-create-debugfs-dir-file-unconditionally.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: yuan linyu <yuanlinyu@honor.com>
Subject: kfence: allow create debugfs dir/file unconditionally
Date: Thu, 18 Dec 2025 09:58:48 +0800

When add boot parameter kfence.sample_interval=0, it will not create
debugfs dir/file, but when user change this parameter after boot, it can
enable kfence, there is no debugfs info to check the kfence state.

Remove kfence_enabled check in kfence_debugfs_init() to create debugfs
unconditionally.

Link: https://lkml.kernel.org/r/20251218015849.1414609-3-yuanlinyu@honor.com
Signed-off-by: yuan linyu <yuanlinyu@honor.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/kfence/core.c~kfence-allow-create-debugfs-dir-file-unconditionally
+++ a/mm/kfence/core.c
@@ -782,9 +782,6 @@ static int kfence_debugfs_init(void)
 {
 	struct dentry *kfence_dir;
 
-	if (!READ_ONCE(kfence_enabled))
-		return 0;
-
 	kfence_dir = debugfs_create_dir("kfence", NULL);
 	debugfs_create_file("stats", 0444, kfence_dir, NULL, &stats_fops);
 	debugfs_create_file("objects", 0400, kfence_dir, NULL, &objects_fops);
_

Patches currently in -mm which might be from yuanlinyu@honor.com are

loongarch-kfence-avoid-use-config_kfence_num_objects.patch
kfence-allow-create-debugfs-dir-file-unconditionally.patch
kfence-allow-change-number-of-object-by-early-parameter.patch

