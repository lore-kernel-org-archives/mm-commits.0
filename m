Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CF23C3C
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 06:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731308122; cv=none; b=FWXing4ehAGJ4k9Er2yDiw1hpU0YriWJ3TU+/bkQUju77YXenH8VFQvRD40+/tyAsTYK5n7iWATtOFSO7qZvV9rDjjKJs/QMizw9RZFInzquJ9PBMlDFNf/DI7YDEclkYGfpmiRQ/2FSgnMZy5hSwYUGiuHyqLglqItGHqi2YAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731308122; c=relaxed/simple;
	bh=GpS6L+k2mpvAWX5Pnu47WNF9SJDwSHUyRteKWEVdIgM=;
	h=Date:To:From:Subject:Message-Id; b=bJBVuLvVJPU8Xlsxct+B24iLeKnWCcK1wY9YAWzXZlVFnL6htwhLIpWJLlm7Qcv+0O7477mifVVpOgJWCV7AgWEaJhuWsLajCgijFbBFlEIxY8hX8D+8wjCvRt0zgYu6QaYW4vc2Hs3XlJEvIsr1zjYW47VrKO9CHSub5zpu0ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KLTy1VLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KLTy1VLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93937C4CED0;
	Mon, 11 Nov 2024 06:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731308121;
	bh=GpS6L+k2mpvAWX5Pnu47WNF9SJDwSHUyRteKWEVdIgM=;
	h=Date:To:From:Subject:From;
	b=KLTy1VLrnUl243NbYViU1dnyiB8pB6OgntrlgRAKvJv9dM2daSWMHjuLRrbo5oQUw
	 duPUeF7cpCsF4a5sAB9G/kSYgVFR4yBqgn3VJgl/Zr1HH9FSdcYUOoP4iYzg9XE1dM
	 +CzVuLQF3DpQEIN2UKbRxEoH2c5QWcuhanoYq4SQ=
Date: Sun, 10 Nov 2024 22:55:20 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,usamaarif642@gmail.com,shy828301@gmail.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,richard.weiyang@gmail.com,nphamcs@gmail.com,kirill.shutemov@linux.intel.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-fix-deferred-split-queue-not-partially_mapped-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241111065521.93937C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/thp: fix deferred split queue not partially_mapped: fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-thp-fix-deferred-split-queue-not-partially_mapped-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-fix-deferred-split-queue-not-partially_mapped-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: fix deferred split queue not partially_mapped: fix
Date: Sun, 10 Nov 2024 13:11:21 -0800 (PST)

Though even more elusive than before, list_del corruption has still been
seen on THP's deferred split queue.

The idea in commit e66f3185fa04 was right, but its implementation wrong. 
The context omitted an important comment just before the critical test:
"split_folio() removes folio from list on success." In ignoring that
comment, when a THP split succeeded, the code went on to release the
preceding safe folio, preserving instead an irrelevant (formerly head)
folio: which gives no safety because it's not on the list.  Fix the logic.

Link: https://lkml.kernel.org/r/3c995a30-31ce-0998-1b9f-3a2cb9354c91@google.com
Fixes: e66f3185fa04 ("mm/thp: fix deferred split queue not partially_mapped")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-fix-deferred-split-queue-not-partially_mapped-fix
+++ a/mm/huge_memory.c
@@ -3790,7 +3790,9 @@ next:
 		 * in the case it was underused, then consider it used and
 		 * don't add it back to split_queue.
 		 */
-		if (!did_split && !folio_test_partially_mapped(folio)) {
+		if (did_split) {
+			; /* folio already removed from list */
+		} else if (!folio_test_partially_mapped(folio)) {
 			list_del_init(&folio->_deferred_list);
 			removed++;
 		} else {
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-fix-deferred-split-queue-not-partially_mapped-fix.patch
mm-delete-the-unused-put_pages_list.patch

