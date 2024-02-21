Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85B312A169
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708558966; cv=none; b=oGZmLlT2s653ROQoMd5B6un5SyY/I9og9xkRG871+UNkt7HxX4wtyyo9u5w2p2SPEmRqMXg3v9j2BlcnhYo8GwgEgdWLBbHXpkTXnMrxKbfR7R9Cpvj0taebql3fCvfTyfHZvjEG4xdLbUp+iasyrSNIrsz8ttq4RelTdmyrfcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708558966; c=relaxed/simple;
	bh=dZunFgVJRMQGwx7CbOPF4LDRdpspAwV9eRDpzinBntY=;
	h=Date:To:From:Subject:Message-Id; b=o5teWu9ZoFDqhiX+XnoIqW5d8Jdk6cpWfkEN2rR6F/oG922524vdO4Y0WTiSfrenlNl7Y6tvZlgDMKacOp8ZN/YaUR38gyNOjZ6SKg2Qp7PvpU0fHjfqy3erfYF8PYJR1jbhfrYxQCA6uiAeJjbzeL4QAfx7/nWOmn28oS9pIJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tzhR6P0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tzhR6P0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1634DC433F1;
	Wed, 21 Feb 2024 23:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708558966;
	bh=dZunFgVJRMQGwx7CbOPF4LDRdpspAwV9eRDpzinBntY=;
	h=Date:To:From:Subject:From;
	b=tzhR6P0xPS9eIOr2MKE85kT9TQMhjYI6zqm17D4zuh6gMn0szY3uKFKSjSUOZI2r0
	 LhcWzsk0XDuidW+aolQs7fqawdTsObd0G3Cd0QydjzK+IilfDcnWvQZk7i4BjwVrWT
	 OxnxVp2mIazzAusQKpKnfzQ0uA8g/nAGwscz6XJ4=
Date: Wed, 21 Feb 2024 15:42:45 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-dbgfs-implement-deprecation-notice-file-fix.patch removed from -mm tree
Message-Id: <20240221234246.1634DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/dbgfs: fix bogus string length
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-implement-deprecation-notice-file-fix.patch

This patch was dropped because it was folded into mm-damon-dbgfs-implement-deprecation-notice-file.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/damon/dbgfs: fix bogus string length
Date: Fri, 2 Feb 2024 13:43:26 +0100

gcc correctly points out that using strnlen() on a fixed size array
is nonsense with an overlong limit:

mm/damon/dbgfs.c: In function 'damon_dbgfs_deprecated_read':
mm/damon/dbgfs.c:814:19: error: 'strnlen' specified bound 1024 exceeds source size 512 [-Werror=stringop-overread]
  814 |         int len = strnlen(kbuf, 1024);
      |                   ^~~~~~~~~~~~~~~~~~~
mm/damon/dbgfs.c:813:14: note: source object allocated here
  813 |         char kbuf[512] = DAMON_DBGFS_DEPRECATION_NOTICE;
      |              ^~~~

In fact, neither of the arbitrary limits are needed here: The first
one can just be a static const string and avoid wasting any more
space then necessary, and the strnlen() can be either strlen() or
sizeof(kbuf)-1, both of which the compiler turns into the same
constant here.

Link: https://lkml.kernel.org/r/20240202124339.892862-1-arnd@kernel.org
Fixes: adf9047adfff ("mm/damon/dbgfs: implement deprecation notice file")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-implement-deprecation-notice-file-fix
+++ a/mm/damon/dbgfs.c
@@ -808,13 +808,12 @@ static void dbgfs_destroy_ctx(struct dam
 static ssize_t damon_dbgfs_deprecated_read(struct file *file,
 		char __user *buf, size_t count, loff_t *ppos)
 {
-	char kbuf[512] = "DAMON debugfs interface is deprecated, "
+	static const char kbuf[512] = "DAMON debugfs interface is deprecated, "
 		     "so users should move to DAMON_SYSFS. If you cannot, "
 		     "please report your usecase to damon@lists.linux.dev and "
 		     "linux-mm@kvack.org.\n";
-	int len = strnlen(kbuf, 1024);
 
-	return simple_read_from_buffer(buf, count, ppos, kbuf, len);
+	return simple_read_from_buffer(buf, count, ppos, kbuf, strlen(kbuf));
 }
 
 /*
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-damon-dbgfs-implement-deprecation-notice-file.patch
kasan-test-avoid-gcc-warning-for-intentional-overflow.patch
mm-mmu_gather-add-tlb_remove_tlb_entries-fix.patch

