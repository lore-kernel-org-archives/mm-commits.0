Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD79D1C5D44
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 01:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774056074; cv=none; b=NNuDJMtyZEDR897rVUxzqRjRmWksvCDQT1+IGrYHnpPnyNpKpZP6ggV47wRnT3AZYxNzlT8gos03d3NMmNvI5maWTVT6jjAGtJoPeWu20Z+TdjU+3P5avdM5bT83ZcG6glL9DdH/w8SyQtQYh/tFw7BJ/c/+x5DAnjEf8QOoERc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774056074; c=relaxed/simple;
	bh=kTYCXzPuHlYePlJqKvqBTQ5ace1V7Dd7pFREIMtWtUM=;
	h=Date:To:From:Subject:Message-Id; b=scY2tgvN67YaTN5Fl9PsDV8c5JRgLbsW69EWdTuOX2lhhHItLSmX4ztkKfbL8YSwTkm4epQplb/D4zbR1ZEGj9rzAKItoNoPNC8njlJoHpP45r7X3IciWjVkx06grHuBgxMozujhvb2+tkjLbeIj9yZ5xjGU/Gwaaoup72UOVc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ovmmTewf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ovmmTewf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D02C4CEF7;
	Sat, 21 Mar 2026 01:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774056074;
	bh=kTYCXzPuHlYePlJqKvqBTQ5ace1V7Dd7pFREIMtWtUM=;
	h=Date:To:From:Subject:From;
	b=ovmmTewfDksQYrc6UFb+Vg2AgQ80o0U+rR7EyzPx5tvb/xt5C8fJtyzraANDmUsPZ
	 ZAlJWoJgLBP56OABhLbXBMKaB7kcEd/SxfZGHGsr+ej8YcyCTBbLusLRhumL6sJizt
	 Q6qq8tlNfi+p9CdwoxUmSjSjCwMIQbcdunASBXsM=
Date: Fri, 20 Mar 2026 18:21:14 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260321012114.A2D02C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix
Date: Fri Mar 20 06:19:29 PM PDT 2026

remove now-unused local

Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/list_sort.c~lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix
+++ a/lib/list_sort.c
@@ -50,7 +50,6 @@ static void merge_final(void *priv, list
 			struct list_head *a, struct list_head *b)
 {
 	struct list_head *tail = head;
-	u8 count = 0;
 
 	for (;;) {
 		/* if equal, take 'a' -- important for sort stability */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

