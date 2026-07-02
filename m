Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C592877DE;
	Thu,  2 Jul 2026 02:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957811; cv=none; b=khv6+q6ZRql5VR89n2ykFeTOh/dxLjs7oo20SU+qnjvLvo6Y/rxY00p+lq3Cr3Fh8jNR5O4WQO+OJnaAEgR8MLqXItF/k5C2vYmRE0OehRwKSUs8/9Jb1nYcBdiv2/xRWDXtXuiC5a9MYvLDPC0Ts+xDz44ynuCJKuCOOBw9bbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957811; c=relaxed/simple;
	bh=40937JmfOOx0ITyEbxAvn2IZ2HimuLZXq8xjifaB8tw=;
	h=Date:To:From:Subject:Message-Id; b=ZtON+ZZHC61MADjB1gHJ97tAGvkuOaNWCFg0on2AiNUxp3+fFpSFSkW6rfyfcGxcd7V4Hxf7l/O5gdTXtiXEQt1UR5WtK9PjD0UTa1sEqYqz3X2dTqoo7m0PEAmZccVInOMVCGlVhLYhBEvFuGlPlyQ3f7a+1v5EPTbsTUuiJEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F8KjRdsl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F8KjRdsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F420D1F000E9;
	Thu,  2 Jul 2026 02:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957810;
	bh=OzDDJLfNQJqIZ+/UPIJwNmxg+HcPnudLRuKNgfoDILA=;
	h=Date:To:From:Subject;
	b=F8KjRdsltdufbjsc/zrxZLZkq/uTl8rhBs9aIJcp8piXGaJ+A/okogFnXaJjf6D9d
	 pBf3SpkVSJyxj1iQsOjX/XC1Qh4VIAPEYSlI4wprGcCeeTfjJHPy4cCp7NMnD+NH5w
	 Hejns3yndpx0ez2jdro6AdOXca8IY0m0dTfwafCs=
Date: Wed, 01 Jul 2026 19:03:29 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shrinker-fix-null-pointer-dereference-in-debugfs.patch removed from -mm tree
Message-Id: <20260702020329.F420D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shrinker: fix NULL pointer dereference in debugfs
has been removed from the -mm tree.  Its filename was
     mm-shrinker-fix-null-pointer-dereference-in-debugfs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -183,10 +183,12 @@ int shrinker_debugfs_add(struct shrinker
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


