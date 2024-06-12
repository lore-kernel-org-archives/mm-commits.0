Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B45F82D62
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218893; cv=none; b=ITs9FM2ShwKISJac7n2YeYsR20ZifNhAQvmnnX5o6Kg+NdBk3V/t0Si1HT0RKBn4A1eXCoOJG5jClVcHrqoqzSKPYhxKgbcZ89hpy+/qCo4m5jb2WksDmNo1Y12/1aS9/Nf8CbwG6dJzcD/1IXMgBGyBAqbJ995WoW0QB+ypV6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218893; c=relaxed/simple;
	bh=VTudSEpTnUzvdUd0dhtQCpLXaSiSN+PZvec3Jtd7QYM=;
	h=Date:To:From:Subject:Message-Id; b=B+lcLm6vF5OMmrFdOYezn/wkyDf98gvHZBoXH5YcV+rerMPdO9v0lJubF9iYj6XNayfnN+k6+qvgh8Zthxx0bQqykcM7s0EyhxQcH2e2jFcmahhHYU55GisOsI8ypGku7X2b0wl3QHxDHMEUTzIziXEjgJx7YomNYX42CEhhtyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ij6AtThu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ij6AtThu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FCFC4AF48;
	Wed, 12 Jun 2024 19:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218892;
	bh=VTudSEpTnUzvdUd0dhtQCpLXaSiSN+PZvec3Jtd7QYM=;
	h=Date:To:From:Subject:From;
	b=ij6AtThuoOLGHvzY3t3BkzBfsR+5jl1pkkM0t581TzXf288fhRf9y9pC9bf+rbZFd
	 xYmtXELy0fw+x5HselW9SVnVYuZ3TXYAgNNIiweE2A5Q6JSNBVIE59u/05NYYdP5Um
	 4MMdepkaldLaY9lfIZc2cSdbjz1cOkVZGnsug8to=
Date: Wed, 12 Jun 2024 12:01:32 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-add-macro-get_page_max_retry_num.patch added to mm-unstable branch
Message-Id: <20240612190132.D9FCFC4AF48@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: add macro GET_PAGE_MAX_RETRY_NUM
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-add-macro-get_page_max_retry_num.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-add-macro-get_page_max_retry_num.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: add macro GET_PAGE_MAX_RETRY_NUM
Date: Wed, 12 Jun 2024 15:18:25 +0800

Add helper macro GET_PAGE_MAX_RETRY_NUM to replace magic number 3.  No
functional change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-add-macro-get_page_max_retry_num
+++ a/mm/memory-failure.c
@@ -1417,6 +1417,8 @@ static int __get_hwpoison_page(struct pa
 	return 0;
 }
 
+#define GET_PAGE_MAX_RETRY_NUM 3
+
 static int get_any_page(struct page *p, unsigned long flags)
 {
 	int ret = 0, pass = 0;
@@ -1431,12 +1433,12 @@ try_again:
 		if (!ret) {
 			if (page_count(p)) {
 				/* We raced with an allocation, retry. */
-				if (pass++ < 3)
+				if (pass++ < GET_PAGE_MAX_RETRY_NUM)
 					goto try_again;
 				ret = -EBUSY;
 			} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
 				/* We raced with put_page, retry. */
-				if (pass++ < 3)
+				if (pass++ < GET_PAGE_MAX_RETRY_NUM)
 					goto try_again;
 				ret = -EIO;
 			}
@@ -1462,7 +1464,7 @@ try_again:
 		 * A page we cannot handle. Check whether we can turn
 		 * it into something we can handle.
 		 */
-		if (pass++ < 3) {
+		if (pass++ < GET_PAGE_MAX_RETRY_NUM) {
 			put_page(p);
 			shake_page(p);
 			count_increased = false;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-simplify-put_ref_page.patch
mm-memory-failure-remove-mf_msg_slab.patch
mm-memory-failure-add-macro-get_page_max_retry_num.patch
mm-memory-failure-save-some-page_folio-calls.patch
mm-memory-failure-remove-unneeded-empty-string.patch
mm-memory-failure-remove-confusing-initialization-to-count.patch
mm-memory-failure-dont-export-hwpoison_filter-when-config_hwpoison_inject.patch
mm-memory-failure-use-helper-macro-task_pid_nr.patch
mm-memory-failure-remove-obsolete-comment-in-unpoison_memory.patch
mm-memory-failure-move-some-function-declarations-into-internalh.patch
mm-memory-failure-fix-comment-of-get_hwpoison_page.patch
mm-memory-failure-remove-obsolete-comment-in-kill_proc.patch
mm-memory-failure-correct-comment-in-me_swapcache_dirty.patch

