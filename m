Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9ED3093B5;
	Wed, 17 Jun 2026 17:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781716928; cv=none; b=SKt4DoUq8jqnBJh0nJFbcW0/7ZKNR9EKK7fQAwRfQQLRKj1khNtZEOkFRtkGKh9jt7rdCldLXIY2vVIzKnDJqSDJE4a5h6gnSUxEg67Jba4YXuJpVUrEASaUeZm2UZ3qkaaZzBRPvD0Wi++FFoE5Oj/ksNq7jitz5NMYHmXMzYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781716928; c=relaxed/simple;
	bh=0egeRixYlU1lAj/TAMijXsvxTT06tG+LdjSQtQdAd3k=;
	h=Date:To:From:Subject:Message-Id; b=B2Yk3ddP2sFQmJsdZ7H0km6S3ZGkaQiEaYCHDxTHlopbbks3z7FnG1UWpY7kBvMrz4CeKHg7ua/WOXmNTw4INyPdvjnfLR9stIa+zHvISTascUDLy/R2YcUGJra0ZNxAKGs0KZVWZQRQgxXwnmCbZUS9ki1NUAeyFQ9FAX4N5Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JfG9joGn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JfG9joGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A941F000E9;
	Wed, 17 Jun 2026 17:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781716927;
	bh=OFtvY5qovzsFYqHtFUO8+DYFRRktc1zlNFyOr3L1rXM=;
	h=Date:To:From:Subject;
	b=JfG9joGnIKJwZMLa6yjAnLcNRfKkRjLqUPS78YxdMJZOC+2BKyNWSK0QjVvLcSOwn
	 A57U5Q79MnotdDchLrPqS3DEhRwrlAFAduV1SOF6EZ6HfVlo6m0phIV5FBrIzPpYUl
	 wKsH5tLGlCBtL3Hx8UNn1FK2/u+5B/5CxSptJKhM=
Date: Wed, 17 Jun 2026 10:22:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-fix-null-pointer-dereference-in-debugfs.patch added to mm-hotfixes-unstable branch
Message-Id: <20260617172207.62A941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shrinker: fix NULL pointer dereference in debugfs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shrinker-fix-null-pointer-dereference-in-debugfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-fix-null-pointer-dereference-in-debugfs.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: shrinker: fix NULL pointer dereference in debugfs
Date: Wed, 17 Jun 2026 17:00:52 +0800

shrinker_debugfs_add() creates both "count" and "scan" debugfs files
unconditionally.

That assumes every shrinker implements both count_objects() and
scan_objects(), which is not guaranteed.  For example, the xen-backend
shrinker sets count_objects() but leaves scan_objects() NULL, so writing
to its scan file calls through a NULL function pointer and panics the
kernel:

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
Call Trace:
 <TASK>
 shrinker_debugfs_scan_write+0x12e/0x270
 full_proxy_write+0x5f/0x90
 vfs_write+0xde/0x420
 ? filp_flush+0x75/0x90
 ? filp_close+0x1d/0x30
 ? do_dup2+0xb8/0x120
 ksys_write+0x68/0xf0
 ? filp_flush+0x75/0x90
 do_syscall_64+0xb3/0x5b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The count path has the same issue in principle if a shrinker omits
count_objects().

To fix it, only create "count" and "scan" debugfs files when the
corresponding callbacks are present.

Link: https://lore.kernel.org/20260617090052.27325-1-qi.zheng@linux.dev
Fixes: bbf535fd6f06 ("mm: shrinkers: add scan interface for shrinker debugfs")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/shrinker_debug.c~mm-shrinker-fix-null-pointer-dereference-in-debugfs
+++ a/mm/shrinker_debug.c
@@ -187,10 +187,12 @@ int shrinker_debugfs_add(struct shrinker
 	}
 	shrinker->debugfs_entry = entry;
 
-	debugfs_create_file("count", 0440, entry, shrinker,
-			    &shrinker_debugfs_count_fops);
-	debugfs_create_file("scan", 0220, entry, shrinker,
-			    &shrinker_debugfs_scan_fops);
+	if (shrinker->count_objects)
+		debugfs_create_file("count", 0440, entry, shrinker,
+				    &shrinker_debugfs_count_fops);
+	if (shrinker->scan_objects)
+		debugfs_create_file("scan", 0220, entry, shrinker,
+				    &shrinker_debugfs_scan_fops);
 	return 0;
 }
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-shrinker-fix-shrinker_info-teardown-race-with-expansion.patch
mm-shrinker-fix-null-pointer-dereference-in-debugfs.patch

