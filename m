Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA90A7E10B
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 21:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716414579; cv=none; b=J6A0487eBDbBUjJdrV1ogPQzHqX5L4qmqFY2t9oNSv7SWV35XdUwbXX1ohwzYp3MOuz3KI7A6gbtO1SlKILV6Qdv11GLUrkOIk2dMXTUN4MYbd2RkYAd6Nu12vuWIYofxzKA6JREY2pf/pLXcBz4FwRp9Nr13POG9iI+W6MQTqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716414579; c=relaxed/simple;
	bh=luERk9OMv/sUo3/o0sOCZ7a/+66OL46QYDJICG4lO8o=;
	h=Date:To:From:Subject:Message-Id; b=pptQkvvPVWf1BmLTnN8t+1EDL4ul4KlWsI28KMoQHhVZ3st7YkcAFdyWzKlLNW0BZrPK4RKDEYCbTullTM/1va38cp7uRZitbSnd9XJC9+4wSTe4aO6ubh6CAIn1rbe4pu28/G03gm8SE9+Z+gzsboK/TQ/VOXk87EbgMhkrfd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QdPVtSRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QdPVtSRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77679C2BBFC;
	Wed, 22 May 2024 21:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716414578;
	bh=luERk9OMv/sUo3/o0sOCZ7a/+66OL46QYDJICG4lO8o=;
	h=Date:To:From:Subject:From;
	b=QdPVtSRnv39ifw4c5X1Osvazd8CKrcBv5BIkgmv5GkDdtaNacq6qQZ40mLoWZbXPv
	 gcBAL8ibj8QPhtWQpbH4uTQppuanbUuYNPK2OrQFsQNDaKXy/SvWSfNypfbcfixgPF
	 /B+yyPT/6KTFf+FaIKCwq21Kb7FM96z+jdnYjL5Q=
Date: Wed, 22 May 2024 14:49:37 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,oalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-move-hwpoison_filter-higher-up.patch added to mm-unstable branch
Message-Id: <20240522214938.77679C2BBFC@smtp.kernel.org>
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
Date: Tue, 21 May 2024 17:54:28 -0600

Move hwpoison_filter() higher up as there is no need to spend a lot cycles
only to find out later that the page is supposed to be skipped from
hwpoison handling.

Link: https://lkml.kernel.org/r/20240521235429.2368017-5-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <oalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-move-hwpoison_filter-higher-up
+++ a/mm/memory-failure.c
@@ -2301,6 +2301,18 @@ try_again:
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
@@ -2364,14 +2376,6 @@ try_again:
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

