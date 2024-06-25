Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55228142E81
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291579; cv=none; b=f+x3HPzVVxxhSXbwgzqMBNMGQUGi5CfHlqnEWuPW93255SM7EDW2MW+UHS4R1ZT6f12CzUX6waDn8s1NPSvNsFWxpmFj9x+2VcNfJoZ0hfVQuEQ3nosj4EiMwX/4VUbRRH+k+kcO5MBg3ZZ9ktYEXpJghlcl6dVE8SeokVmzKBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291579; c=relaxed/simple;
	bh=ZdwrdcSK/Hxo11I07fEnresMwXFMj7LZu3+wlYAIjJU=;
	h=Date:To:From:Subject:Message-Id; b=npHsV/oBIOmPvGNvyKDQfaF4kTHbqF4NKpUhntddqX57xSV9f4DDVJA4npg43nDtzK9kk5gEcCtgpdtc/eL1Q6isnN9fPlqqt04DVfBLzeEPKHd5we17VVZYo1Op+7n4HyiPvAZ4XkKSzN61qOIHeTY3tAe6o8449GQlDzj8bI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iLBLmkoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iLBLmkoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A875C32789;
	Tue, 25 Jun 2024 04:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291579;
	bh=ZdwrdcSK/Hxo11I07fEnresMwXFMj7LZu3+wlYAIjJU=;
	h=Date:To:From:Subject:From;
	b=iLBLmkoA09E06L01PN1ijYnfulXdIR82BsH/sDbZJ3yONkliSa1AzCQ8KlFk0ysAy
	 /83o484e3cAo79XLLrtTD/AvPI8OdMP1U2Kin1lnLb2MwEcfL056y1lmDzzJPNOz1O
	 mWgIsgrJRxngqSrlNQh1Fathb0drMfQsSKtd6TbE=
Date: Mon, 24 Jun 2024 21:59:38 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,oalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch removed from -mm tree
Message-Id: <20240625045939.2A875C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: send SIGBUS in the event of thp split fail
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: send SIGBUS in the event of thp split fail
Date: Fri, 24 May 2024 15:53:06 -0600

While handling hwpoison in a THP page, it is possible that
try_to_split_thp_page() fails.  For example, when the THP page has been
RDMA pinned.  At this point, the kernel cannot isolate the poisoned THP
page, all it could do is to send a SIGBUS to the user process with
meaningful payload to give user-level recovery a chance.

Link: https://lkml.kernel.org/r/20240524215306.2705454-6-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <oalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail
+++ a/mm/memory-failure.c
@@ -1706,7 +1706,12 @@ static int identify_page_state(unsigned
 	return page_action(ps, p, pfn);
 }
 
-static int try_to_split_thp_page(struct page *page)
+/*
+ * When 'release' is 'false', it means that if thp split has failed,
+ * there is still more to do, hence the page refcount we took earlier
+ * is still needed.
+ */
+static int try_to_split_thp_page(struct page *page, bool release)
 {
 	int ret;
 
@@ -1714,7 +1719,7 @@ static int try_to_split_thp_page(struct
 	ret = split_huge_page(page);
 	unlock_page(page);
 
-	if (unlikely(ret))
+	if (ret && release)
 		put_page(page);
 
 	return ret;
@@ -2186,6 +2191,22 @@ out:
 	return rc;
 }
 
+/*
+ * The calling condition is as such: thp split failed, page might have
+ * been RDMA pinned, not much can be done for recovery.
+ * But a SIGBUS should be delivered with vaddr provided so that the user
+ * application has a chance to recover. Also, application processes'
+ * election for MCE early killed will be honored.
+ */
+static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
+				struct folio *folio)
+{
+	LIST_HEAD(tokill);
+
+	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
+	kill_procs(&tokill, true, pfn, flags);
+}
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -2327,8 +2348,11 @@ try_again:
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		if (try_to_split_thp_page(p) < 0) {
-			res = action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
+		if (try_to_split_thp_page(p, false) < 0) {
+			res = -EHWPOISON;
+			kill_procs_now(p, pfn, flags, folio);
+			put_page(p);
+			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
 			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
@@ -2709,7 +2733,7 @@ static int soft_offline_in_use_page(stru
 	};
 
 	if (!huge && folio_test_large(folio)) {
-		if (try_to_split_thp_page(page)) {
+		if (try_to_split_thp_page(page, true)) {
 			pr_info("soft offline: %#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
_

Patches currently in -mm which might be from jane.chu@oracle.com are


