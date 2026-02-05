Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AEB33509C
	for <mm-commits@vger.kernel.org>; Thu,  5 Feb 2026 22:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770329434; cv=none; b=GeA1M2g3muv373/dpdauM+9emHd2lNztyEwt5V2Mbpp6EK+7rTKTWZKMN4uEUFsQYGy7adZKaKNy/76OzaLK7pOLNarr1JHDNtevH/IDgfmTqjE635EeD0P8yjZPym445+J2QuetshO4nMYu/rfdGuCpp9OQiW171IHo7dl/lek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770329434; c=relaxed/simple;
	bh=j+TCRKEdEO/QjvbTpQHsR/DKHtI/5QN1wt3codvjsbA=;
	h=Date:To:From:Subject:Message-Id; b=RS/3+UwPjVob7EScqNq7U1ibhqYi31gB+6cyEDTNJiiHxFVY6OoaRW5T5vY0JRFWQmfGftHQsBtXsjVOXXwjNXJLvPb+2apCMdhyL3lA6g6iNqaQpGU/DnNiQ64gLBknPfRnFWEUiP6rfdKbSJGCVGuURA/dVWZgv72o0W8R30Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wa+40XED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wa+40XED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8381DC2BC87;
	Thu,  5 Feb 2026 22:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770329434;
	bh=j+TCRKEdEO/QjvbTpQHsR/DKHtI/5QN1wt3codvjsbA=;
	h=Date:To:From:Subject:From;
	b=Wa+40XEDbq5K8IS9isERr0U7xhGMeYqtrvQg98iBHWZr0HI/37ZbGSaaxd6reQvpQ
	 N+CxA961NdKDjHtFH1+ys9yfUMmwM+Tru0FMf0kTPIhO4ckxwrumld8b53ZMqWlFFp
	 cAv+0p+GqWJHK12wUtDHHTqGM8L8hDiboVGtiYlw=
Date: Thu, 05 Feb 2026 14:10:33 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shicenci@gmail.com,nao.horiguchi@gmail.com,jane.chu@oracle.com,david@kernel.org,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-reject-unsupported-non-folio-compound-page.patch removed from -mm tree
Message-Id: <20260205221034.8381DC2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: reject unsupported non-folio compound page
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-reject-unsupported-non-folio-compound-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: reject unsupported non-folio compound page
Date: Thu, 5 Feb 2026 15:53:28 +0800

When !CONFIG_TRANSPARENT_HUGEPAGE, a non-folio compound page can appear in
a userspace mapping via either vm_insert_*() functions or
vm_operatios_struct->fault().  They are not folios, thus should not be
considered for folio operations like split.  To reject these pages, make
sure get_hwpoison_page() is always called as HWPoisonHandlable() will do
the right work.

[Some commit log borrowed from Zi Yan. Thanks.]

Link: https://lkml.kernel.org/r/20260205075328.523211-1-linmiaohe@huawei.com
Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: 是参差 <shicenci@gmail.com>
Closes: https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-reject-unsupported-non-folio-compound-page
+++ a/mm/memory-failure.c
@@ -2411,31 +2411,29 @@ try_again:
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
-	if (!(flags & MF_COUNT_INCREASED)) {
-		res = get_hwpoison_page(p, flags);
-		if (!res) {
-			if (is_free_buddy_page(p)) {
-				if (take_page_off_buddy(p)) {
-					page_ref_inc(p);
-					res = MF_RECOVERED;
-				} else {
-					/* We lost the race, try again */
-					if (retry) {
-						ClearPageHWPoison(p);
-						retry = false;
-						goto try_again;
-					}
-					res = MF_FAILED;
-				}
-				res = action_result(pfn, MF_MSG_BUDDY, res);
+	res = get_hwpoison_page(p, flags);
+	if (!res) {
+		if (is_free_buddy_page(p)) {
+			if (take_page_off_buddy(p)) {
+				page_ref_inc(p);
+				res = MF_RECOVERED;
 			} else {
-				res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
+				/* We lost the race, try again */
+				if (retry) {
+					ClearPageHWPoison(p);
+					retry = false;
+					goto try_again;
+				}
+				res = MF_FAILED;
 			}
-			goto unlock_mutex;
-		} else if (res < 0) {
-			res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
-			goto unlock_mutex;
+			res = action_result(pfn, MF_MSG_BUDDY, res);
+		} else {
+			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 		}
+		goto unlock_mutex;
+	} else if (res < 0) {
+		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		goto unlock_mutex;
 	}
 
 	folio = page_folio(p);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

selftests-mm-add-memory-failure-anonymous-page-test.patch
selftests-mm-add-memory-failure-clean-pagecache-test.patch
selftests-mm-add-memory-failure-dirty-pagecache-test.patch

