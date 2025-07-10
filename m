Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4034C4C97
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 22:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752186666; cv=none; b=EbQxeowkyZKQvFVebxCPMzzag+qnNLQDzZ/4Ak7jG1zkWPN5XgZlxlQqGVtX0s8Bor9gIehga+AUIHsj9X+dVv43dS++d5UI9+YTp5yaiaWPodLtGk5VSepaEIxGjdlV9H98T9tpVO4wFDHb6Waw3jzuJ9qqr84EHipfozMZwOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752186666; c=relaxed/simple;
	bh=fBzBkNLoQ5IoXc3A66/zisGvllLwa120WMqvRVv7QxI=;
	h=Date:To:From:Subject:Message-Id; b=QwsPwhu2UsT/Hi8PrhNYG7ntKgZ10Xi/bdiR+rH6ny7q4qyxt3qHdvEO9bDA6DhfxudkYqakhAkpWhAxFVMBAr0OqUUj+GQEaGEwH/qd8vpZhL8jRuOLcfZqcyYv4M7ExYFPNnQ8kEct9t+XrFwhNITSfplRnk3WLwgOOZE5PSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PKASvRc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PKASvRc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCF8C4CEE3;
	Thu, 10 Jul 2025 22:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752186665;
	bh=fBzBkNLoQ5IoXc3A66/zisGvllLwa120WMqvRVv7QxI=;
	h=Date:To:From:Subject:From;
	b=PKASvRc2ofJepdA6oV9p8z1pgUdmgkXKs1p0qazME4pLbNvggCHJvdY09H/tPpO/R
	 n3Jy2zhc0Trzm0YNzXROpzTma0CXGVF5eAmfkzjCDJLlQVmanUizpgOKdL7yZg5eKf
	 yP5uiR6LLDwbI8N0V2v49Ovh1s/qPL3gUMq1FWGc=
Date: Thu, 10 Jul 2025 15:31:05 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix.patch added to mm-unstable branch
Message-Id: <20250710223105.8FCF8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix.patch

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
Subject: mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix
Date: Thu Jul 10 03:27:57 PM PDT 2025

fix kerneldoc

Reported-by: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix
+++ a/mm/migrate.c
@@ -161,7 +161,9 @@ static void putback_movable_ops_page(str
 
 /**
  * migrate_movable_ops_page - migrate an isolated movable_ops page
- * @page: The isolated page.
+ * @dst: The destination page.
+ * @src: The source page.
+ * @mode: The migration mode.
  *
  * Migrate an isolated movable_ops page.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
mm-migrate-factor-out-movable_ops-page-handling-into-migrate_movable_ops_page-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

