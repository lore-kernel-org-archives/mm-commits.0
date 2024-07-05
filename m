Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47844BE58
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141639; cv=none; b=LxskbSoJjDCXyimZgyfhpFpRE0RVviHsRo9HHL6hr5V+Y6WDt69PkfZmM6cewnk7Ogn9obGi4aV7X33UrtZkaaq93iajvvb9I9toyGUai0F1Po+7rnrjOJSFZ6zLWcZv8BYQGdZKv3LdtOe1QFLWceGEaUgkH6iGoPQYlJuz9VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141639; c=relaxed/simple;
	bh=oZ1YZ9pDB0AB8I8JXpNa3iFtjnzlDdMI/YRUbwlcB1w=;
	h=Date:To:From:Subject:Message-Id; b=VA3dphT824sls/1+Yn+WnXMpBIC3WyyUcm2UpMMicTEK0XFlLT7i8Q+cKQ0CEsPbgGlXDFEzMDMR9XVFeOO9wu9pKtiad9M9MM8aUQwFJA8pkCFKoe7Ll7xX2MAbxA+uGfTJJajf/p5ySoUp4ghaVUGQEAOTLOvZXKm7D5ANFoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J5F8R9QF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J5F8R9QF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB6AC3277B;
	Fri,  5 Jul 2024 01:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141639;
	bh=oZ1YZ9pDB0AB8I8JXpNa3iFtjnzlDdMI/YRUbwlcB1w=;
	h=Date:To:From:Subject:From;
	b=J5F8R9QFWYOFCK727GJO86tAnfZFzXw0sTH7sECz5jAPGs8BFAkjXQj5bO0X7V77T
	 Ax15mHYRP8ucNYbIl+HHP5fqLbltjtXDV0icbnH1yCfBCg9xGqcOtUs3mty0QPlOki
	 3jI4MfOQvT7Y64cTr4QtztpLQKAEI98NnK7Gyv5k=
Date: Thu, 04 Jul 2024 18:07:18 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,rdunlap@infradead.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-userspace-controls-soft-offlining-pages.patch removed from -mm tree
Message-Id: <20240705010719.1AB6AC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: userspace controls soft-offlining pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-userspace-controls-soft-offlining-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/memory-failure: userspace controls soft-offlining pages
Date: Wed, 26 Jun 2024 05:08:16 +0000

Correctable memory errors are very common on servers with large amount of
memory, and are corrected by ECC.  Soft offline is kernel's additional
recovery handling for memory pages having (excessive) corrected memory
errors.  Impacted page is migrated to a healthy page if inuse; the
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
corrected memory errors sounds very costly and kernel better not doing
under the hood.  But today there are at least 2 such cases doing so:
1. when GHES driver sees both GHES_SEV_CORRECTED and
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

[jiaqiyan@google.com: v7]
  Link: https://lkml.kernel.org/r/20240628205958.2845610-3-jiaqiyan@google.com
Link: https://lkml.kernel.org/r/20240626050818.2277273-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
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
@@ -2758,8 +2769,9 @@ static int soft_offline_in_use_page(stru
  * @pfn: pfn to soft-offline
  * @flags: flags. Same as memory_failure().
  *
- * Returns 0 on success
- *         -EOPNOTSUPP for hwpoison_filter() filtered the error event
+ * Returns 0 on success,
+ *         -EOPNOTSUPP for hwpoison_filter() filtered the error event, or
+ *         disabled by /proc/sys/vm/enable_soft_offline,
  *         < 0 otherwise negated errno.
  *
  * Soft offline a page, by migration or invalidation,
@@ -2795,6 +2807,12 @@ int soft_offline_page(unsigned long pfn,
 		return -EIO;
 	}
 
+	if (!sysctl_enable_soft_offline) {
+		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
+		put_ref_page(pfn, flags);
+		return -EOPNOTSUPP;
+	}
+
 	mutex_lock(&mf_mutex);
 
 	if (PageHWPoison(page)) {
_

Patches currently in -mm which might be from jiaqiyan@google.com are


