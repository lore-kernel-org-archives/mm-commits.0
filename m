Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A230A86340
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449477; cv=none; b=D0a8mqnla1TmywotHZ1i4GgqtuRWoLfZzb42UD+6W5OEWDVqLdcdMPRq4v76a1xgu2arUIWIOSUAMbYageOHlDXJJBnW+taYPy+nL+/o/TaRZp9iQq387+7TDUes7IitC3VTbup87k/XFmxdrq2ooktihqTbDUaqlLuWKaQBNRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449477; c=relaxed/simple;
	bh=WTNDWGHjA/+Mtcs+OC8eHmScJtQ8A3m4K4OJGM406Co=;
	h=Date:To:From:Subject:Message-Id; b=DtNv9C4gMzCZo2XEC4tUEtt4IXgv4KlMQgl77uLOx6ZBlok04uF6u3l92KD56IAeL7vU28pM0NVo1fyLIDuWSuZtzXuyp4eaAMXNpqmRkR6iU8R84W3LT9WW0UBno598RoeWvWqxDVtms1mWYycB6MBeG84EAUECnM5zCmYZTfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XKd3GcoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XKd3GcoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2087DC4CEE3;
	Sun, 13 Jul 2025 23:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449477;
	bh=WTNDWGHjA/+Mtcs+OC8eHmScJtQ8A3m4K4OJGM406Co=;
	h=Date:To:From:Subject:From;
	b=XKd3GcoTdrKTYt0Wv9PP6Y/j00uHbMNZmDfOMbHqi/74GTzFPg/Gj40mPgjjmFrvg
	 boh8VY6TBdWCv+1dUwR/stZgrb3IXT3nDQbTMGOJQHs5lNnAfnnB/EHK6ASpckhrs0
	 W9llMFnhQjiz/oko/Sxfdk2ikO208sDHLdXGJwmQ=
Date: Sun, 13 Jul 2025 16:31:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,osalvador@suse.de,lkp@intel.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch removed from -mm tree
Message-Id: <20250713233117.2087DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mmslub-use-node-notifier-instead-of-memory-notifier-fix
has been removed from the -mm tree.  Its filename was
     mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch

This patch was dropped because it was folded into mmslub-use-node-notifier-instead-of-memory-notifier.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmslub-use-node-notifier-instead-of-memory-notifier-fix
Date: Sun Jun 22 11:57:25 AM PDT 2025

slub.c needs node.h for struct node_notify

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506202144.dGkFxasv-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c~mmslub-use-node-notifier-instead-of-memory-notifier-fix
+++ a/mm/slub.c
@@ -23,6 +23,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/kasan.h>
+#include <linux/node.h>
 #include <linux/kmsan.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmslub-use-node-notifier-instead-of-memory-notifier.patch
mm-percpu-prevent-concurrency-problem-for-pcpu_nr_populated-read-with-spin-lock-fix.patch
mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

