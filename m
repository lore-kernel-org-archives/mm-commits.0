Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D6B1A00EB
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 19:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718913019; cv=none; b=HTJk+bT9fCpaQDxwWBK/ZKGXAg/fT+LoA+qQBccCKekBonhzkrflvvVZVl29ATQPntCCLfVA9SGpB6lnBktx8KOlRS5dWPyWElra+ryoYUTwDEr/HIzznqa4j+wtz+T4w6l+bsIiXYnQXWOHddAsFcQdN2o2iOUBV2NyFYCKsKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718913019; c=relaxed/simple;
	bh=kr/EPn50CZVPotcTcvsRVCmA51u8beRdGLYH1AZxj3U=;
	h=Date:To:From:Subject:Message-Id; b=dmt0p3ebEb0dLpgrWQozRpoIORKniJ/bSFKFjzeh5l5zkYd3F5pFo7hZe5JsnqtpeRkZpaMhPQkBQSVSvKdgUx1APTPyTypf34aaQDKGvl2hB8BMyBhGhB06+lSZ/D1FJmle8GBCI8Q9b6KDSkjY6R4rGrDGprKpNea5bxSfPmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=adqSPrWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="adqSPrWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F3DC4AF0B;
	Thu, 20 Jun 2024 19:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718913019;
	bh=kr/EPn50CZVPotcTcvsRVCmA51u8beRdGLYH1AZxj3U=;
	h=Date:To:From:Subject:From;
	b=adqSPrWDQXHGekUvtb0Mn8SssRuEjnfrw3Tra3MS4HJQH8FF21NnNZR0P0t+8nCnq
	 87RJV7OEMjNdkYsVGwTqDyjz4+w3KDLz/ayYMGrvQFddhesZF3Pgj9sHeTImUlIQ0B
	 De04wtIVVcOibM+S+zEYwqgomEb2e8Rul/3QBHx4=
Date: Thu, 20 Jun 2024 12:50:18 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-refactor-log-format-in-soft-offline-code.patch added to mm-unstable branch
Message-Id: <20240620195019.56F3DC4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: refactor log format in soft offline code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-refactor-log-format-in-soft-offline-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-refactor-log-format-in-soft-offline-code.patch

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
Subject: mm/memory-failure: refactor log format in soft offline code
Date: Thu, 20 Jun 2024 18:48:53 +0000

Patch series "Userspace controls soft-offline pages", v4.

Correctable memory errors are very common on servers with large amount of
memory, and are corrected by ECC, but with two pain points to users:

1. Correction usually happens on the fly and adds latency overhead
2. Not-fully-proved theory states excessive correctable memory
   errors can develop into uncorrectable memory error.

Soft offline is kernel's additional solution for memory pages having
(excessive) corrected memory errors.  Impacted page is migrated to healthy
page if it is in use, then the original page is discarded for any future
use.

The actual policy on whether (and when) to soft offline should be
maintained by userspace, especially in case of an 1G HugeTLB page. 
Soft-offline dissolves the HugeTLB page, either in-use or free, into
chunks of 4K pages, reducing HugeTLB pool capacity by 1 hugepage.  If
userspace has not acknowledged such behavior, it may be surprised when
later mmap hugepages MAP_FAILED due to lack of hugepages.  In case of a
transparent hugepage, it will be split into 4K pages as well; userspace
will stop enjoying the transparent performance.

In addition, discarding the entire 1G HugeTLB page only because of
corrected memory errors sounds very costly and kernel better not doing
under the hood.  But today there are at least 2 such cases:

1. GHES driver sees both GHES_SEV_CORRECTED and
   CPER_SEC_ERROR_THRESHOLD_EXCEEDED after parsing CPER.

2. RAS Correctable Errors Collector counts correctable errors per
   PFN and when the counter for a PFN reaches threshold

In both cases, userspace has no control of the soft offline performed by
kernel's memory failure recovery.

This patch series give userspace the control of softofflining any page:
kernel only soft offlines raw page / transparent hugepage / HugeTLB
hugepage if userspace has agreed to.  The interface to userspace is a new
sysctl called enable_soft_offline under /proc/sys/vm.  By default
enable_soft_line is 1 to preserve existing behavior in kernel.


This patch (of 4):

Logs from soft_offline_page and soft_offline_in_use_page have different
formats than majority of the memory failure code:

  "Memory failure: 0x${pfn}: ${lower_case_message}"

Convert them to the following format:

  "Soft offline: 0x${pfn}: ${lower_case_message}"

No functional change in this commit.

Link: https://lkml.kernel.org/r/20240620184856.600717-1-jiaqiyan@google.com
Link: https://lkml.kernel.org/r/20240620184856.600717-2-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-refactor-log-format-in-soft-offline-code
+++ a/mm/memory-failure.c
@@ -2640,6 +2640,9 @@ unlock_mutex:
 }
 EXPORT_SYMBOL(unpoison_memory);
 
+#undef pr_fmt
+#define pr_fmt(fmt) "Soft offline: " fmt
+
 static bool mf_isolate_folio(struct folio *folio, struct list_head *pagelist)
 {
 	bool isolated = false;
@@ -2695,7 +2698,7 @@ static int soft_offline_in_use_page(stru
 
 	if (!huge && folio_test_large(folio)) {
 		if (try_to_split_thp_page(page, true)) {
-			pr_info("soft offline: %#lx: thp split failed\n", pfn);
+			pr_info("%#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
 		folio = page_folio(page);
@@ -2707,7 +2710,7 @@ static int soft_offline_in_use_page(stru
 	if (PageHWPoison(page)) {
 		folio_unlock(folio);
 		folio_put(folio);
-		pr_info("soft offline: %#lx page already poisoned\n", pfn);
+		pr_info("%#lx page already poisoned\n", pfn);
 		return 0;
 	}
 
@@ -2720,7 +2723,7 @@ static int soft_offline_in_use_page(stru
 	folio_unlock(folio);
 
 	if (ret) {
-		pr_info("soft_offline: %#lx: invalidated\n", pfn);
+		pr_info("%#lx: invalidated\n", pfn);
 		page_handle_poison(page, false, true);
 		return 0;
 	}
@@ -2737,13 +2740,13 @@ static int soft_offline_in_use_page(stru
 			if (!list_empty(&pagelist))
 				putback_movable_pages(&pagelist);
 
-			pr_info("soft offline: %#lx: %s migration failed %ld, type %pGp\n",
+			pr_info("%#lx: %s migration failed %ld, type %pGp\n",
 				pfn, msg_page[huge], ret, &page->flags);
 			if (ret > 0)
 				ret = -EBUSY;
 		}
 	} else {
-		pr_info("soft offline: %#lx: %s isolation failed, page count %d, type %pGp\n",
+		pr_info("%#lx: %s isolation failed, page count %d, type %pGp\n",
 			pfn, msg_page[huge], page_count(page), &page->flags);
 		ret = -EBUSY;
 	}
@@ -2795,7 +2798,7 @@ int soft_offline_page(unsigned long pfn,
 	mutex_lock(&mf_mutex);
 
 	if (PageHWPoison(page)) {
-		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
+		pr_info("%#lx: page already poisoned\n", pfn);
 		put_ref_page(pfn, flags);
 		mutex_unlock(&mf_mutex);
 		return 0;
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-unpoison_memory.patch
mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
docs-mm-add-enable_soft_offline-sysctl.patch

