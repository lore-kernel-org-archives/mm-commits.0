Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D001D683;
	Wed, 10 Jan 2024 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2e4iu7+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A287C433C7;
	Wed, 10 Jan 2024 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704900740;
	bh=SSE859ZKpB0eYzK233X0/uAqLdDI1iU0hHw9Rn7AzoU=;
	h=Date:To:From:Subject:From;
	b=2e4iu7+mRAqic3MkQ65KB95c0retXan88By6VPdL0iI6tc/K20POH4NI3/YlDO/To
	 qH770I0s69Q+P0vLspmTyYb7ebscJSoERJ+Wk+EBKTzFIIMkLAe5badAEGtQOWVuPW
	 zXIvT3tYcC6xXHtLQegO8ZSKEibBPgMp7il0Y5ao=
Date: Wed, 10 Jan 2024 07:32:19 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-fix-memmap_on_memory-sysfs-value-retrieval.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110153220.3A287C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: fix memmap_on_memory sysfs value retrieval
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory_hotplug-fix-memmap_on_memory-sysfs-value-retrieval.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-fix-memmap_on_memory-sysfs-value-retrieval.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: mm/memory_hotplug: fix memmap_on_memory sysfs value retrieval
Date: Wed, 10 Jan 2024 15:01:27 +0100

set_memmap_mode() stores the kernel parameter memmap mode as an integer. 
However, the get_memmap_mode() function utilizes param_get_bool() to fetch
the value as a boolean, leading to potential endianness issue.  On
Big-endian architectures, the memmap_on_memory is consistently displayed
as 'N' regardless of its actual status.

To address this endianness problem, the solution involves obtaining the
mode as an integer.  This adjustment ensures the proper display of the
memmap_on_memory parameter, presenting it as one of the following options:
Force, Y, or N.

Link: https://lkml.kernel.org/r/20240110140127.241451-1-sumanthk@linux.ibm.com
Fixes: 2d1f649c7c08 ("mm/memory_hotplug: support memmap_on_memory when memmap is not aligned to pageblocks")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Suggested-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-memmap_on_memory-sysfs-value-retrieval
+++ a/mm/memory_hotplug.c
@@ -101,9 +101,11 @@ static int set_memmap_mode(const char *v
 
 static int get_memmap_mode(char *buffer, const struct kernel_param *kp)
 {
-	if (*((int *)kp->arg) == MEMMAP_ON_MEMORY_FORCE)
-		return sprintf(buffer,  "force\n");
-	return param_get_bool(buffer, kp);
+	int mode = *((int *)kp->arg);
+
+	if (mode == MEMMAP_ON_MEMORY_FORCE)
+		return sprintf(buffer, "force\n");
+	return sprintf(buffer, "%c\n", mode ? 'Y' : 'N');
 }
 
 static const struct kernel_param_ops memmap_mode_ops = {
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-memory_hotplug-fix-memmap_on_memory-sysfs-value-retrieval.patch
mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range.patch
s390-sclp-remove-unhandled-memory-notifier-type.patch
s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-enable-mhp_memmap_on_memory.patch

