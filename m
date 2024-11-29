Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26900155345
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 10:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732876697; cv=none; b=TdciHtDNOkwcFg9bq7FIalhyN1KtpiP4Zqx79zwfyVw1r2zXBHXjrHtZULGeRyyTvF8UbCYWFW4vkDreydj0OkL2FtcxtohohqCV79EZJ1FrkxIdFFk0GYyn6JQmD8H85ArLc1AWpfz2XzX+oBnmefJzGKpMXOMTLCmmBG/yRE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732876697; c=relaxed/simple;
	bh=TC20S0IqON5Y3hK81AsSw56szKbQaA8m83Qo1m7Rxok=;
	h=Date:To:From:Subject:Message-Id; b=RJi82HTrs44jjjmQJf7cukaTVBMeJF0ocR6+X1tRdWKMIiCQAldn1RFZS5rpkwBEIeDg+XsSkT52qPp8nj9WHSHMJKYJOsRzKKag8voccftT7udIr/fBlELLyfpUJGs1YAdS3FVs4LGyCwfiyHeP189AMAb9hJuQsMUjfvI9a1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gb8Wc3rZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gb8Wc3rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCFFC4CECF;
	Fri, 29 Nov 2024 10:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732876697;
	bh=TC20S0IqON5Y3hK81AsSw56szKbQaA8m83Qo1m7Rxok=;
	h=Date:To:From:Subject:From;
	b=gb8Wc3rZq9ueT8RxHTwRt89mYKgL+RukX6F1sRPAjC1uXuO6hz2YHNOCAqhaPr6wH
	 AikXZWPKVwxENnxoQ+x/a4JmbdqK8Moze8CZyw+hjcfGwXIDhysE96IEFTdzpu/q/9
	 WzDInLMdkXoyD6VJS6y+/FtPlNRkKwP2Yp1jRsaA=
Date: Fri, 29 Nov 2024 02:38:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-tmpfs-drop-fadvise-from-the-documentation.patch added to mm-unstable branch
Message-Id: <20241129103816.EDCFFC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: tmpfs: drop 'fadvise()' from the documentation
has been added to the -mm mm-unstable branch.  Its filename is
     docs-tmpfs-drop-fadvise-from-the-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-tmpfs-drop-fadvise-from-the-documentation.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: docs: tmpfs: drop 'fadvise()' from the documentation
Date: Thu, 28 Nov 2024 15:40:44 +0800

Drop 'fadvise()' from the doc, since fadvise() has no HUGEPAGE advise
currently.

Link: https://lkml.kernel.org/r/3a10bb49832f6d9827dc2c76aec0bf43a892876b.1732779148.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~docs-tmpfs-drop-fadvise-from-the-documentation
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -382,10 +382,10 @@ never
 
 within_size
     Only allocate huge page if it will be fully within i_size.
-    Also respect fadvise()/madvise() hints;
+    Also respect madvise() hints;
 
 advise
-    Only allocate huge pages if requested with fadvise()/madvise();
+    Only allocate huge pages if requested with madvise();
 
 Remember, that the kernel may use huge pages of all available sizes, and
 that no fine control as for the internal tmpfs mount is available.
@@ -438,10 +438,10 @@ never
 
 within_size
     Only allocate <size> huge page if it will be fully within i_size.
-    Also respect fadvise()/madvise() hints;
+    Also respect madvise() hints;
 
 advise
-    Only allocate <size> huge pages if requested with fadvise()/madvise();
+    Only allocate <size> huge pages if requested with madvise();
 
 Need of application restart
 ===========================
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch

