Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFE618A934
	for <mm-commits@vger.kernel.org>; Mon, 17 Jun 2024 19:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718651754; cv=none; b=JNtsWB8T8UPLZb6z/jA3rdiaZqQP97rT3Ex4pRMsrJLxNSU5Gubjqeljr68YEwi7CuwZsIrUNQ0CGl2IupY44/5i8Ogp7ZiHwodHlqX+rzqRupFV6/ecaofBJRX2qq8Nx40YLzy0N1BRzGto57/LOK7Og+cCysQjbsa4wv+Khqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718651754; c=relaxed/simple;
	bh=WElwa3QyRdLwqmmwJrurchCnaJ8yZscyeSUarroQrhY=;
	h=Date:To:From:Subject:Message-Id; b=MJNkuCGV0azZZRFz82EaVa+qzSBhYq5Y1U+yv0qcrPxhceuQ/f81FcXDGN+V6dWPXnKSXON7yFIDA6mtSq1ubFoCburCMg9uWy6dVWV6oYXxXF72oUEBWtwF+Xlwp4GUZCaH973FBROF4oV0VlIxLWHvTkwh8ESNkCj2QaPboH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t47X8xyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t47X8xyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B15C2BD10;
	Mon, 17 Jun 2024 19:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718651753;
	bh=WElwa3QyRdLwqmmwJrurchCnaJ8yZscyeSUarroQrhY=;
	h=Date:To:From:Subject:From;
	b=t47X8xyTlQwM7wuuPAqrn4GGhnnoeHoLRKIk8CC3pmiQfO6KjVbBE9E98jNd7YyAF
	 +JbzG3QU/Yqyr+HhVfl2V6nUoxNANJmFTkwRHQk28eXa9ZoYgR5Uri6RilXhMr2YiO
	 fFuGPbKiVxBn25i3K7vaA1gouAiZgNsUX10yMbqA=
Date: Mon, 17 Jun 2024 12:15:52 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-userspace-controls-soft-offlining-pages.patch added to mm-unstable branch
Message-Id: <20240617191553.61B15C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: userspace controls soft-offlining pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-userspace-controls-soft-offlining-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-userspace-controls-soft-offlining-pages.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/memory-failure: userspace controls soft-offlining pages
Date: Mon, 17 Jun 2024 17:05:43 +0000

Patch series "Userspace controls soft-offline pages", v3.

Correctable memory errors are very common on servers with large
amount of memory, and are corrected by ECC, but with two
pain points to users:
1. Correction usually happens on the fly and adds latency overhead
2. Not-fully-proved theory states excessive correctable memory
   errors can develop into uncorrectable memory error.

Soft offline is kernel's additional solution for memory pages
having (excessive) corrected memory errors. Impacted page is migrated
to healthy page if it is in use, then the original page is discarded
for any future use.

The actual policy on whether (and when) to soft offline should be
maintained by userspace, especially in case of an 1G HugeTLB page.
Soft-offline dissolves the HugeTLB page, either in-use or free, into
chunks of 4K pages, reducing HugeTLB pool capacity by 1 hugepage.
If userspace has not acknowledged such behavior, it may be surprised
when later mmap hugepages MAP_FAILED due to lack of hugepages.
In case of a transparent hugepage, it will be split into 4K pages
as well; userspace will stop enjoying the transparent performance.

In addition, discarding the entire 1G HugeTLB page only because of
corrected memory errors sounds very costly and kernel better not
doing under the hood. But today there are at least 2 such cases:
1. GHES driver sees both GHES_SEV_CORRECTED and
   CPER_SEC_ERROR_THRESHOLD_EXCEEDED after parsing CPER.
2. RAS Correctable Errors Collector counts correctable errors per
   PFN and when the counter for a PFN reaches threshold
In both cases, userspace has no control of the soft offline performed
by kernel's memory failure recovery.

This patch series give userspace the control of softofflining any page:
kernel only soft offlines raw page / transparent hugepage / HugeTLB
hugepage if userspace has agreed to.  The interface to userspace is a new
sysctl called enable_soft_offline under /proc/sys/vm.  By default
enable_soft_line is 1 to preserve existing behavior in kernel.


This patch (of 3):

Correctable memory errors are very common on servers with large amount of
memory, and are corrected by ECC.  Soft offline is kernel's additional
recovery handling for memory pages having (excessive) corrected memory
errors.  Impacted page is migrated to a healthy page if it is in-use; the
original page is discarded for any future use.

The actual policy on whether (and when) to soft offline should be
maintained by userspace, especially in case of an 1G HugeTLB page. 
Soft-offline dissolves the HugeTLB page, either in-use or free, into
chunks of 4K pages, reducing HugeTLB pool capacity by 1 hugepage.  If
userspace has not acknowledged such behavior, it may be surprised when
later failed to mmap hugepages due to lack of hugepages.  In case of a
transparent hugepage, it will be split into 4K pages as well; userspace
will stop enjoying the transparent performance.

In addition, discarding the entire 1G HugeTLB page only because of
corrected memory errors sounds very costly and kernel better not
doing under the hood. But today there are at least 2 such cases
doing so:
1. GHES driver sees both GHES_SEV_CORRECTED and
   CPER_SEC_ERROR_THRESHOLD_EXCEEDED after parsing CPER.
2. RAS Correctable Errors Collector counts correctable errors per
   PFN and when the counter for a PFN reaches threshold
In both cases, userspace has no control of the soft offline performed
by kernel's memory failure recovery.

This commit gives userspace the control of softofflining any page: kernel
only soft offlines raw page / transparent hugepage / HugeTLB hugepage if
userspace has agreed to.  The interface to userspace is a new sysctl at
/proc/sys/vm/enable_soft_offline.  By default its value is set to 1 to
preserve existing behavior in kernel.  When set to 0, soft-offline (e.g. 
MADV_SOFT_OFFLINE) will fail with EOPNOTSUPP.

Link: https://lkml.kernel.org/r/20240617170545.3820912-1-jiaqiyan@google.com
Link: https://lkml.kernel.org/r/20240617170545.3820912-2-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-userspace-controls-soft-offlining-pages
+++ a/mm/memory-failure.c
@@ -68,6 +68,8 @@ static int sysctl_memory_failure_early_k
 
 static int sysctl_memory_failure_recovery __read_mostly = 1;
 
+static int sysctl_enable_soft_offline __read_mostly = 1;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly = false;
@@ -141,6 +143,15 @@ static struct ctl_table memory_failure_t
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+	{
+		.procname	= "enable_soft_offline",
+		.data		= &sysctl_enable_soft_offline,
+		.maxlen		= sizeof(sysctl_enable_soft_offline),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	}
 };
 
 /*
@@ -2755,8 +2766,9 @@ static int soft_offline_in_use_page(stru
  * @pfn: pfn to soft-offline
  * @flags: flags. Same as memory_failure().
  *
- * Returns 0 on success
- *         -EOPNOTSUPP for hwpoison_filter() filtered the error event
+ * Returns 0 on success,
+ *         -EOPNOTSUPP for hwpoison_filter() filtered the error event,
+ *         -EOPNOTSUPP if disabled by /proc/sys/vm/enable_soft_offline,
  *         < 0 otherwise negated errno.
  *
  * Soft offline a page, by migration or invalidation,
@@ -2792,6 +2804,12 @@ int soft_offline_page(unsigned long pfn,
 		return -EIO;
 	}
 
+	if (!sysctl_enable_soft_offline) {
+		pr_info("%#lx: OS-wide disabled\n", pfn);
+		put_ref_page(pfn, flags);
+		return -EOPNOTSUPP;
+	}
+
 	mutex_lock(&mf_mutex);
 
 	if (PageHWPoison(page)) {
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-userspace-controls-soft-offlining-pages.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
docs-mm-add-enable_soft_offline-sysctl.patch

