Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705DD1F542E
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 19:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750618804; cv=none; b=PhrCydAgaruuh+HP0YX/2W2WxYpW7qNQQyieIC5wkCYoXcTsxNlLiVcWEqBcDs5CU52u8NkXc6N++ozIIOZeRK9G25zBfK7+FkqdsMyXHa24ay9nbjiuk048N2EGU728fzDh5rmTCF9szzfzF35i7EFarpbQdPNKT2I6oUjIf1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750618804; c=relaxed/simple;
	bh=LpTkdutL8s7k+kxMkU2pQVmIawUZ09tiBvr46O2sZCM=;
	h=Date:To:From:Subject:Message-Id; b=P7SYd86CZjtKLgy5nyFVNkOO3If3oGFodi/blwv5HabfqddmrQrblNwEk8eiTOhFZ98mbMb8QeZat/JKnaYndb0zcPI1/zipGZzz37lLtRs8Ag17yRbwFmfz3hxjWDV8oA7H7EuT4jVDRSM0v2uovD8TU4GBF+RsLmClgkFTHww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y/Cdykgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y/Cdykgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D748EC4CEE3;
	Sun, 22 Jun 2025 19:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750618803;
	bh=LpTkdutL8s7k+kxMkU2pQVmIawUZ09tiBvr46O2sZCM=;
	h=Date:To:From:Subject:From;
	b=y/CdykgrA09nq008zEEpv/b/Y75VMdK/64wfawKek0TW8NTeyxafarfhjq9WkDC4I
	 JrgoNqDd5WTzZgmICt64Lz/SRUdZEguFFkWULaGvIb/A82ePnBr2BwQiX1N5fA3vj/
	 dIP7ctLKhfMw1GWrlhdc2WTKiGGNZL8xoAQQVg0U=
Date: Sun, 22 Jun 2025 12:00:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rakie.kim@sk.com,osalvador@suse.de,lkp@intel.com,Jonathan.Cameron@huawei.com,harry.yoo@oracle.com,david@redhat.com,42.hyeyoo@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch added to mm-unstable branch
Message-Id: <20250622190003.D748EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mmslub-use-node-notifier-instead-of-memory-notifier-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-add-oom-killer-maintainer-structure-fix.patch
mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
filemap-add-__filemap_get_folio_mpol-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch

