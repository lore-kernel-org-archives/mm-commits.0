Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC8D2EE263
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 22:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756939952; cv=none; b=oclxRk7Erbpj9vEjnFCplfs8y7YmoN2EKBg7gjOj5/4AaaVh9vn1+xtBOuKRjjsg2/XxPYVyihNU/bvReuoXMQz9//tYmNrI8PPbpDYOksbRmk97E0hzX0or8Ghe8ntThM7X1taqwMNMI5/bQstaT1k7MZEECvH3XTuXaWB4AuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756939952; c=relaxed/simple;
	bh=52dfu7/K6P/xxat/oL/5zwfvOASNuOTWQ0bAlPhLxcc=;
	h=Date:To:From:Subject:Message-Id; b=U/L05PkTZUaPPwf7vv635t+vZuHujApg/JrfBwEdbF/8A0nJYEHTo19cSygzrrUUVk4LtyAz0ZO7lnJhtUNSBgc88NiyRX2zuZ08phvKQ/k4LlF4oV/CUqqGqcjTNLhKAGq3yzDsMeI81DZ2b4+35qdpMwt01klwR+SsZNvKSEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gCb8v1+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gCb8v1+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79837C4CEE7;
	Wed,  3 Sep 2025 22:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756939951;
	bh=52dfu7/K6P/xxat/oL/5zwfvOASNuOTWQ0bAlPhLxcc=;
	h=Date:To:From:Subject:From;
	b=gCb8v1+KQPds6a/mfrO+qoL+4XKVuCAloVnSAN8007uSpoK0z/DnPa+RnD6QBeSgw
	 +IjE5rKC8z1cML+9Ih+9c9KbQL8yNHvTPEbrfSfAlzpO5ZkUaLzpZbm0PuOTHPfkkU
	 0kNWIQeMPw6yqxFoPS7hC9C9loc3CPeJo5SztiRA=
Date: Wed, 03 Sep 2025 15:52:30 -0700
To: mm-commits@vger.kernel.org,youling.tang@linux.dev,tangyouling@kylinos.cn,max.kellermann@ionos.com,chizhiling@kylinos.cn,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-align-last_index-to-folio-size-fix-fix.patch added to mm-unstable branch
Message-Id: <20250903225231.79837C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-filemap-align-last_index-to-folio-size-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-align-last_index-to-folio-size-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-align-last_index-to-folio-size-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-filemap-align-last_index-to-folio-size-fix-fix
Date: Wed Sep  3 03:50:51 PM PDT 2025

update it for Max's constification efforts

Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Chi Zhiling <chizhiling@kylinos.cn>
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: Youling Tang <youling.tang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-filemap-align-last_index-to-folio-size-fix-fix
+++ a/include/linux/pagemap.h
@@ -483,7 +483,7 @@ mapping_min_folio_nrpages(const struct a
 }
 
 static inline unsigned long
-mapping_min_folio_nrbytes(struct address_space *mapping)
+mapping_min_folio_nrbytes(const struct address_space *mapping)
 {
 	return mapping_min_folio_nrpages(mapping) << PAGE_SHIFT;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch

