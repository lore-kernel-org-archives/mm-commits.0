Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DB8137C36
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289480; cv=none; b=oLnaGyfoWCqR5v46z42ktU9jc4EduFmbg5yMvtQyH4bwdZsWmet9S5ktjBK3kIIFW/ES9JRZP0XXXZD1RXHspJg3KEf3NDmF+5s8lEKOPXmjKzNxG/JiVK6pDfLfpaV31x+NaG5wxb1rsbMYCTmcp2G9bSGQ6jkiieqbHpZv+jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289480; c=relaxed/simple;
	bh=RkmXYJEaIxLN8jRmQ+z/fKHhBlFlR2GiBck7si9Q8ZM=;
	h=Date:To:From:Subject:Message-Id; b=PrPfi3nyo7lqzmOtt6q8wS1wCgKb9595RxxIRSu5JmSHp2aU9ZSd/T0T6gSZelxkcCmcgOvWDmaOuPcwcexRw+7mUJ6cBJJZ330wEUZvY02SJlPthfqtOsGlsR4f0elKJhIMP77QfYpTUWb0jxpixT0bS7f4C/jC1Hg+HAJRSis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0jc0tPlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0jc0tPlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15956C32782;
	Tue, 25 Jun 2024 04:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289480;
	bh=RkmXYJEaIxLN8jRmQ+z/fKHhBlFlR2GiBck7si9Q8ZM=;
	h=Date:To:From:Subject:From;
	b=0jc0tPlGu74dWKmwtLKVsBrqOM0KVMAcaZv8OU2MI388kU/esn0C5oijCkez3qzH/
	 MIM2E4tGhSXseEWEqKAuyZYqdH0dmRYtMRt4hZD3sbIbHK2r8dWPVZAJ+pgtPPnMd/
	 wZr+c/f2/txx14hbXPYv0Z5WGyBahxVs0C1aPi8A=
Date: Mon, 24 Jun 2024 21:24:39 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4.patch removed from -mm tree
Message-Id: <20240625042440.15956C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4.patch

This patch was dropped because it was folded into mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4
Date: Mon Jun 24 12:28:05 PM PDT 2024

huge_memory.c needs mm_types.h

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: kernel test robot <lkp@intel.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/huge_memory.c~mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-4
+++ a/mm/huge_memory.c
@@ -20,6 +20,7 @@
 #include <linux/swapops.h>
 #include <linux/backing-dev.h>
 #include <linux/dax.h>
+#include <linux/mm_types.h>
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
 #include <linux/pfn_t.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch

