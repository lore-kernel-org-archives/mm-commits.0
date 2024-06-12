Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18EF8287E
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718218897; cv=none; b=lPNNm4yv9IaLjxB4+LFLnsFmUcxBdh6LPdta+RmivTR0ttTejYgOTCib5FGrtZqKz8znbDzXUlVWAYYBOrVKpRatcyeATt0bUP9c8JAa2+4927Acb6t9flrpINGh5KN+p3Dfak5VAdlN6FGfNYVIBAXQL4c8kEl8vwhVcWL6hkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718218897; c=relaxed/simple;
	bh=Vc1YguFTb40Neb0Gxh2TRt8j6bmlgV2itEmOjTpxV+w=;
	h=Date:To:From:Subject:Message-Id; b=nspG76bkogKrLHvHU9HvwCp+HYQb+ZULhLPo+UGlut+uPgCu7JW8Eu8kNMfGTVWbbj3N49Py8VU7Tp5zw6e9TGWYBTBj2rbKJxAubiAQvOO8YaaRaYAf+hmXbD8Px/lFXWi5qFGuKyr7R9F+4zXLxm3CsxK38MmhArRyqyumZmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jEE+9KX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jEE+9KX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C13C116B1;
	Wed, 12 Jun 2024 19:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718218897;
	bh=Vc1YguFTb40Neb0Gxh2TRt8j6bmlgV2itEmOjTpxV+w=;
	h=Date:To:From:Subject:From;
	b=jEE+9KX/z7AOL3Tgsc3AB767N4FsUoBxZtxKDgCkWmEnl6dfxpvWvGQYBsO6JGoCD
	 beSvbmJID0aWjoXqSzyNO19+EbTnSxeI/0DpkHheN6ZRl3ilxseZtr5flgYDx/Xm8a
	 Ee13xBf1Ks3Tf6iS9pbyGrr7Qk9dMzZjIiMI5T4w=
Date: Wed, 12 Jun 2024 12:01:36 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-confusing-initialization-to-count.patch added to mm-unstable branch
Message-Id: <20240612190137.84C13C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: remove confusing initialization to count
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-remove-confusing-initialization-to-count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-confusing-initialization-to-count.patch

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
Subject: mm/memory-failure: remove confusing initialization to count
Date: Wed, 12 Jun 2024 15:18:28 +0800

It's meaningless and confusing to init local variable count to 1.  Remove
it.  No functional change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-confusing-initialization-to-count
+++ a/mm/memory-failure.c
@@ -2542,7 +2542,7 @@ int unpoison_memory(unsigned long pfn)
 	struct folio *folio;
 	struct page *p;
 	int ret = -EBUSY, ghp;
-	unsigned long count = 1;
+	unsigned long count;
 	bool huge = false;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
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

