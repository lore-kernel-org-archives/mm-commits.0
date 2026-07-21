Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558FB403AFB
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654950; cv=none; b=Ge3k+UkvwFPlm6WdAhhLqWSE9wUFaQB3gKwq26UgfUh0zWwFBvWsdWILVc3zwSX2LKnMo1l0VgIK7KA0X7WdgawAVgld5l4Q2PvzMi41XJr1sRv3Fzipop/BvkVkiKaTTZBLPq8u/Adrwj6nY9STI9+kY8N7qgfQ3Rumfg+cVrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654950; c=relaxed/simple;
	bh=KvALOWXCXEI2FWyf39jUaAhlOXS1Q9haRaZzgiuWXH0=;
	h=Date:To:From:Subject:Message-Id; b=L2rltHmsEOOeV4ZhJtTNo33SWwalCS3F/hsQiqU6U8Sg8KjPmUzb9/i9jF85JdN6WKOr2X9+EiVb4EPhU/iju2+hLUfgn7HkzX1F/lJWuJswtE07Lj4HdZPuYPo70rGBUPRaHJtB00MXI0+zp+7PAZZTXTz1TFPnEzgYgv0PZyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Hq4JZaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Hq4JZaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049A71F000E9;
	Tue, 21 Jul 2026 17:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784654949;
	bh=dR8swjgiBtPbLINstkO/Rt+XdbCU23I8JetxP/VXG74=;
	h=Date:To:From:Subject;
	b=1Hq4JZaqYubZ+TzW9Z9arvTbtO76sfIFCe/uVVUQv0jn9nOKgjykVdWrkbQxtnQME
	 GFvbVai/qfliqMNIlhpsRY6ZqJtfaXQrbi27gmSHguEn60i/lxEOas+C4XKg255GvA
	 0s8jLtOJ7R83W8SP0Zd2Ws761KetGHuYhYB5DSGA=
Date: Tue, 21 Jul 2026 10:29:08 -0700
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix-2.patch added to mm-unstable branch
Message-Id: <20260721172909.049A71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_owner-add-numa-node-filter-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
From: "Zi Yan" <ziy@nvidia.com>
Subject: mm-page_owner-add-numa-node-filter-fix
Date: Tue, 07 Jul 2026 11:54:37 -0400

build fix

Link: https://lore.kernel.org/DJSGLP9VFLRI.355AAWR2VHIEL@nvidia.com
Signed-off-by: "Zi Yan" <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix-2
+++ a/mm/page_owner.c
@@ -815,7 +815,7 @@ read_page_owner(struct file *file, char
 			 */
 			if (page_flags.f == PAGE_POISON_PATTERN)
 				goto ext_put_continue;
-			nid = memdesc_nid(page_flags);
+			nid = memdesc_nid(&page_flags);
 			if (!node_isset(nid, state->nid_filter))
 				goto ext_put_continue;
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix-2.patch
mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

