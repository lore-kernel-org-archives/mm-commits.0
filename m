Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA7017B4E7
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 21:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716932667; cv=none; b=Ya4TU3ShU4UbqJZgOeeQoyeFETmtLdtmsF9I4yBiwg1cB3RAk4aB2yCeNhXDHrNZj0zV5PMycpsVD9pooeuo17pMq1gstMAic6YzQGX2XyI3HYu8O5kTg8TRKl7d5/yeQ4TFudYyPQzzyLvCpo2MNzc4jUYu3z9C9rLbcmS2hAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716932667; c=relaxed/simple;
	bh=bmV4QOuM5Lr4rTM+/fFcCy2VOMfq74byv/7EehZqTpA=;
	h=Date:To:From:Subject:Message-Id; b=uEfIPdAHqZmBrYH8ZnQT+9NCFSlkh4wCpm8OhU+B2U2eiJbtBJnmoHPqBp09rFmGuEZqe2K8VLD7LhZWRp0o5e4WqsI0HQGyuv3cW+fCGgY00giXZAf2p3NYRrwGDenNDvYucJIvDdGsbBTCMFExdt+KG+HntYNw/eup811bWk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZTmlCtP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZTmlCtP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46868C3277B;
	Tue, 28 May 2024 21:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716932667;
	bh=bmV4QOuM5Lr4rTM+/fFcCy2VOMfq74byv/7EehZqTpA=;
	h=Date:To:From:Subject:From;
	b=ZTmlCtP/DZUtRzaJQbgAVVjaOhekhSBcSSHs5gZr+2BoM0hMufVJgjfm77u5W85bW
	 3WpvLxLoc1p4MpfajzdQWeot5Ed3xr3vTTsIHb8gCi4osPdz8U5WMgcF4d1weEiyuH
	 /R5o1J6oxvd8jgFXR9+l0CgOv6oR2L3AWfSqfeWo=
Date: Tue, 28 May 2024 14:44:26 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,oalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-move-hwpoison_filter-higher-up.patch added to mm-unstable branch
Message-Id: <20240528214427.46868C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: move hwpoison_filter() higher up
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-move-hwpoison_filter-higher-up.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-move-hwpoison_filter-higher-up.patch

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
Subject: mm/memory-failure: move hwpoison_filter() higher up
Date: Fri, 24 May 2024 15:53:05 -0600

Move hwpoison_filter() higher up as there is no need to spend a lot cycles
only to find out later that the page is supposed to be skipped from
hwpoison handling.

Link: https://lkml.kernel.org/r/20240524215306.2705454-5-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <oalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-move-hwpoison_filter-higher-up
+++ a/mm/memory-failure.c
@@ -2300,6 +2300,18 @@ try_again:
 	}
 
 	folio = page_folio(p);
+
+	/* filter pages that are protected from hwpoison test by users */
+	folio_lock(folio);
+	if (hwpoison_filter(p)) {
+		ClearPageHWPoison(p);
+		folio_unlock(folio);
+		folio_put(folio);
+		res = -EOPNOTSUPP;
+		goto unlock_mutex;
+	}
+	folio_unlock(folio);
+
 	if (folio_test_large(folio)) {
 		/*
 		 * The flag must be set after the refcount is bumped
@@ -2363,14 +2375,6 @@ try_again:
 	 */
 	page_flags = folio->flags;
 
-	if (hwpoison_filter(p)) {
-		ClearPageHWPoison(p);
-		folio_unlock(folio);
-		folio_put(folio);
-		res = -EOPNOTSUPP;
-		goto unlock_mutex;
-	}
-
 	/*
 	 * __munlock_folio() may clear a writeback folio's LRU flag without
 	 * the folio lock. We need to wait for writeback completion for this
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch
mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch
mm-memory-failure-improve-memory-failure-action_result-messages.patch
mm-memory-failure-move-hwpoison_filter-higher-up.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

