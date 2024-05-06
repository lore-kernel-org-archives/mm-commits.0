Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB541320B
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955326; cv=none; b=UuyJA8kE7XHPmwC5I/CB8IDUr3XjYR3f7zXel5xLdMZaqTSNba0NFO4v9czCHnk/cFH1+H4o5+z0uDGz4e5lRr0UGop6cYLohrtf9Et8/OzdJaZgAP/3u0gqrIrzRYk8rUcJlCXuoPxIM7m57NYy6cH2JWQPyAk29fknsxqwwZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955326; c=relaxed/simple;
	bh=rycfDYN6AAeNnuDT++J/6f0djanO5sNdkAjsiT4KU6U=;
	h=Date:To:From:Subject:Message-Id; b=Gk7om/PBIj+H0uQ7I9e1f9RQPsk0cOC5qZiDlBPG2zJ0nTmq7KqrtOKnV7pdJ1JbcLmdT2hfY56H0mFyHmHBgVoCVrp6UpE4hVhBYLQdy6OwyiVbQL7ZkaTSVGq33G8Fk8wSwqSZMjkSKqKpxrBxcXQAEXpCulzetx01A4Y+g10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V1CTnD+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V1CTnD+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DED2C113CC;
	Mon,  6 May 2024 00:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955325;
	bh=rycfDYN6AAeNnuDT++J/6f0djanO5sNdkAjsiT4KU6U=;
	h=Date:To:From:Subject:From;
	b=V1CTnD+WpSGcsQeS3+ZUC4KK1SXMkKWLZU/JQ3bAODxp713wPWpuSf/KGF0sjVHrC
	 KvKU6l2+9Z4MpQIPDjU6nbSF7LNBQh+QYoWqfU0wFZf8ILM/AU2SHMTOR7O2FC8RRZ
	 zsODmfzhA4b5gyGpu2o8s0cn9wm6AJxDCd4HLfcI=
Date: Sun, 05 May 2024 17:28:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,Liam.Howlett@oracle.com,djwong@kernel.org,david@fromorbit.com,da.gomez@samsung.com,mcgrof@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-fix-userspace-compilation-with-new-test_xarray-changes.patch removed from -mm tree
Message-Id: <20240506002845.8DED2C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: fix userspace compilation with new test_xarray changes
has been removed from the -mm tree.  Its filename was
     tools-fix-userspace-compilation-with-new-test_xarray-changes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: tools: fix userspace compilation with new test_xarray changes
Date: Tue, 23 Apr 2024 12:22:20 -0700

Patch series "test_xarray: couple of fixes for v6-9-rc6", v2.

Here are a couple of fixes which should be merged into the queue for
v6.9-rc6.  The first one was reported by Liam, after fixing that I noticed
an issue with a test, and a fix for that is in the second patch.


This patch (of 2):

Liam reported that compiling the test_xarray on userspace was broken.  I
was not even aware that was possible but you can via and you can run these
tests in userspace with:

make -C tools/testing/radix-tree
./tools/testing/radix-tree/xarray

Add the two helpers we need to fix compilation.  We don't need a userspace
schedule() so just make it do nothing.

Link: https://lkml.kernel.org/r/20240423192221.301095-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20240423192221.301095-2-mcgrof@kernel.org
Fixes: a60cc288a1a2 ("test_xarray: add tests for advanced multi-index use")
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reported-by: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/kernel.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/radix-tree/linux/kernel.h~tools-fix-userspace-compilation-with-new-test_xarray-changes
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -18,6 +18,8 @@
 #define pr_info printk
 #define pr_debug printk
 #define pr_cont printk
+#define schedule()
+#define PAGE_SHIFT	12
 
 #define __acquires(x)
 #define __releases(x)
_

Patches currently in -mm which might be from mcgrof@kernel.org are


