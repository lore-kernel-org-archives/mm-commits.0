Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A9A28E3
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628221; cv=none; b=hel2PWwmD68wbqym3vmQBibfs9v4eZ4Eg7ggdj1gVGs/cc8ZqhrL5DJYm5/XUM5tMhl21RxzCWYAPSP6Hq9hAXe2TgB6wHOxpIKbNlW3lJp+EYTbWaAOSelItNJn6pdMe7Gsa8Iep5ZY2MCukUcX8hXKJjM4ItD5wC0fFoLgOw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628221; c=relaxed/simple;
	bh=CUQ3BSurmwTR0pP3xFQtRw0Zzg5qU6l48JwlcfwYmRQ=;
	h=Date:To:From:Subject:Message-Id; b=I0Eglix4MmmLPpaUVOWJTysE+o+1EQd4FCnWMgfa01+IlKfVZoSJuNODwubEKgGiwuz0KLccgxrt2RUBS7jw3jOeFcOPOZRtC4M9ux/A9ZiG5ARwvaBL5Z5xXYriOQbzTRVh9xI/op9r3aAs1ZQAVsJ3HGjDikZLMCo7ZbHIkNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v7ALoIQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v7ALoIQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E356BC116B1;
	Sat, 29 Jun 2024 02:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628221;
	bh=CUQ3BSurmwTR0pP3xFQtRw0Zzg5qU6l48JwlcfwYmRQ=;
	h=Date:To:From:Subject:From;
	b=v7ALoIQzg6X565xfxxcf5HuKZ8jNRD2ofTmpqQ17EI2q2JA8iupOTKkT5MN5QUK5e
	 crspdohrOII5crov76rNZUY0fXJ9XbMb+CtYYMzu6wuQqaSMKbxcNGX8XDIQP3khiM
	 JA0M4trTjVtp7unR+RrW/c4O7ye1Qk3svEPEgeLw=
Date: Fri, 28 Jun 2024 19:30:20 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-refactor-log-format-in-unpoison_memory.patch removed from -mm tree
Message-Id: <20240629023020.E356BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: refactor log format in unpoison_memory
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-refactor-log-format-in-unpoison_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/memory-failure: refactor log format in unpoison_memory
Date: Wed, 19 Jun 2024 06:33:55 +0000

Logs from memory_failure and other memory-failure.c code follow the
format:

  "Memory failure: 0x{pfn}: ${lower_case_message}"

Convert the logs in unpoison_memory to follow similar format:

  "Unpoison: 0x${pfn}: ${lower_case_message}"

For example (from local test):
  [ 1331.938397] Unpoison: 0x144bc8: page was already unpoisoned

No functional change in this commit.

Link: https://lkml.kernel.org/r/20240619063355.171313-1-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-refactor-log-format-in-unpoison_memory
+++ a/mm/memory-failure.c
@@ -2515,7 +2515,7 @@ static int __init memory_failure_init(vo
 core_initcall(memory_failure_init);
 
 #undef pr_fmt
-#define pr_fmt(fmt)	fmt
+#define pr_fmt(fmt)	"Unpoison: " fmt
 #define unpoison_pr_info(fmt, pfn, rs)			\
 ({							\
 	if (__ratelimit(rs))				\
@@ -2553,27 +2553,27 @@ int unpoison_memory(unsigned long pfn)
 	mutex_lock(&mf_mutex);
 
 	if (hw_memory_failure) {
-		unpoison_pr_info("Unpoison: Disabled after HW memory failure %#lx\n",
+		unpoison_pr_info("%#lx: disabled after HW memory failure\n",
 				 pfn, &unpoison_rs);
 		ret = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
 
 	if (is_huge_zero_folio(folio)) {
-		unpoison_pr_info("Unpoison: huge zero page is not supported %#lx\n",
+		unpoison_pr_info("%#lx: huge zero page is not supported\n",
 				 pfn, &unpoison_rs);
 		ret = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
 
 	if (!PageHWPoison(p)) {
-		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
+		unpoison_pr_info("%#lx: page was already unpoisoned\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
 	if (folio_ref_count(folio) > 1) {
-		unpoison_pr_info("Unpoison: Someone grabs the hwpoison page %#lx\n",
+		unpoison_pr_info("%#lx: someone grabs the hwpoison page\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
@@ -2583,13 +2583,13 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 
 	if (folio_mapped(folio)) {
-		unpoison_pr_info("Unpoison: Someone maps the hwpoison page %#lx\n",
+		unpoison_pr_info("%#lx: someone maps the hwpoison page\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
 	if (folio_mapping(folio)) {
-		unpoison_pr_info("Unpoison: the hwpoison page has non-NULL mapping %#lx\n",
+		unpoison_pr_info("%#lx: the hwpoison page has non-NULL mapping\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
@@ -2608,7 +2608,7 @@ int unpoison_memory(unsigned long pfn)
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
 		} else {
 			ret = ghp;
-			unpoison_pr_info("Unpoison: failed to grab page %#lx\n",
+			unpoison_pr_info("%#lx: failed to grab page\n",
 					 pfn, &unpoison_rs);
 		}
 	} else {
@@ -2633,7 +2633,7 @@ unlock_mutex:
 	if (!ret) {
 		if (!huge)
 			num_poisoned_pages_sub(pfn, 1);
-		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
+		unpoison_pr_info("%#lx: software-unpoisoned page\n",
 				 page_to_pfn(p), &unpoison_rs);
 	}
 	return ret;
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
mm-memory-failure-userspace-controls-soft-offlining-pages-v7.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
selftest-mm-test-enable_soft_offline-behaviors-v7.patch
docs-mm-add-enable_soft_offline-sysctl.patch

