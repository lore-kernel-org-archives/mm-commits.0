Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE497E10B
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 21:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716414580; cv=none; b=G6XHWjOnX1wRAVWo9RNechtcAelbrH7HtTgNJeNPJvhSsV7MmJQMaAuphhcgAKQ8yLbE2WQG6fl5t7pjEZ2yzJUbqA1IF5+llvbcmD9LXfjQXcmTVjCuoVvDSxa6zXKogmC/B8HA/mzSkpU+Q9JdUNbkbKhNC4VcghCBj935Igc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716414580; c=relaxed/simple;
	bh=ugCP4OB6Gvgf2jBOiJkjNRpun85ra3qLKRf9shIzSW0=;
	h=Date:To:From:Subject:Message-Id; b=GAdfqZEqIkn8n8VEwgpshQOM7QBeCUnQoDnDXGsNqBf8+k1bJTsfDWbcLkTOTRYsAA21rlhvwThrXFm/wQqEUZkcOCqsKnr//JYe1wtfcLUd29pngeJNx5urgHpbVNklXGKF8+wnihzL8vLMzT1mSyV7+ykZYqPvxQzMPXWuAkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y1OmcsKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y1OmcsKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B73C2BBFC;
	Wed, 22 May 2024 21:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716414580;
	bh=ugCP4OB6Gvgf2jBOiJkjNRpun85ra3qLKRf9shIzSW0=;
	h=Date:To:From:Subject:From;
	b=y1OmcsKINkeaTOSMHoSx0GubF1C0G+11XkYfF8o/t4yq14PJx1pIOk1VPykxKDmcg
	 CYTZkOE5nuS20rpZs8EGM9iYkAsv51TM1SJNXjk7tED6XKQ7rrKmtvGf6O3/Yrbeg3
	 6IDExGfpdirKWg71BjSlJ7jqOG3vA1nYD+/SkIGU=
Date: Wed, 22 May 2024 14:49:39 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,oalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch added to mm-unstable branch
Message-Id: <20240522214939.E6B73C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: send SIGBUS in the event of thp split fail
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

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
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: send SIGBUS in the event of thp split fail
Date: Tue, 21 May 2024 17:54:29 -0600

While handling hwpoison in a THP page, it is possible that
try_to_split_thp_page() fails.  For example, when the THP page has been
RDMA pinned.  At this point, the kernel cannot isolate the poisoned THP
page, all it could do is to send a SIGBUS to the user process with
meaningful payload to give user-level recovery a chance.

Link: https://lkml.kernel.org/r/20240521235429.2368017-6-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <oalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

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
@@ -2187,6 +2192,24 @@ out:
 	return rc;
 }
 
+/*
+ * The calling condition is as such: thp split failed, page might have
+ * been RDMA pinned, not much can be done for recovery.
+ * But a SIGBUS should be delivered with vaddr provided so that the user
+ * application has a chance to recover. Also, application processes'
+ * election for MCE early killed will be honored.
+ */
+static int kill_procs_now(struct page *p, unsigned long pfn, int flags,
+				struct folio *folio)
+{
+	LIST_HEAD(tokill);
+
+	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
+	kill_procs(&tokill, true, pfn, flags);
+
+	return -EHWPOISON;
+}
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -2328,8 +2351,10 @@ try_again:
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		if (try_to_split_thp_page(p) < 0) {
-			res = action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
+		if (try_to_split_thp_page(p, false) < 0) {
+			res = kill_procs_now(p, pfn, flags, folio);
+			put_page(p);
+			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
 			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
@@ -2710,7 +2735,7 @@ static int soft_offline_in_use_page(stru
 	};
 
 	if (!huge && folio_test_large(folio)) {
-		if (try_to_split_thp_page(page)) {
+		if (try_to_split_thp_page(page, true)) {
 			pr_info("soft offline: %#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch
mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch
mm-memory-failure-improve-memory-failure-action_result-messages.patch
mm-memory-failure-move-hwpoison_filter-higher-up.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

