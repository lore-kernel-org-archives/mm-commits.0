Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091D71CD07
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 00:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709080463; cv=none; b=RSsJJfoKg3GJHOABSLuCAz3blSbP7tMRKflr4SwHPze5MjcuMYAszuQKVVLrKd6ySJZ2mDQh9TkZGdbB6YZVdZoUqNk49owCcOW1/FcqxxPblinxwAyOh1LDCFdxNhYtuHmb6gPP0TmHCqZoXxw7t+t//+Qry/7ye6NTdzAFLw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709080463; c=relaxed/simple;
	bh=N2YS0a2pg/t84tcE9Eim3x7/FgzRTi5+IliXFj54PJE=;
	h=Date:To:From:Subject:Message-Id; b=D5VcZ+o0OUmC7/Uj8QN7LjRR7jrNUDJlIySINN6VqYVYNK/NX0Ivlq7+Bk+2dVFXysJrBtJWsz39GXOhLpkLHpXtilT2uRyZszwHIAcu0EGATE9kkS29k3Glc3k+u1H1tuRg7KxuniqWWuH45869ONgjxSpoCvPcITF17u0EYoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ian+gYlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ian+gYlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D47C433F1;
	Wed, 28 Feb 2024 00:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709080462;
	bh=N2YS0a2pg/t84tcE9Eim3x7/FgzRTi5+IliXFj54PJE=;
	h=Date:To:From:Subject:From;
	b=ian+gYlSh7IedbvEVwviAxJF8xteuPgQDVNH/gJ/3AvgdxnajWKLtc+1RFJF04IfY
	 U8LECzJdSuJ9fMGLgvZrlMQ6fuhudl/ibRFMiyjRhpoZu+WEGcNpTFlguUFy91a+3f
	 KiNRUNhaBgLFI3QPKArORqka4wxSuaQlOlqDb4Ys=
Date: Tue, 27 Feb 2024 16:34:21 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix.patch added to mm-unstable branch
Message-Id: <20240228003422.72D47C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix.patch

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
From: Barry Song <21cnbao@gmail.com>
Subject: mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix
Date: Wed, 28 Feb 2024 13:10:06 +1300

build fix

Link: https://lkml.kernel.org/r/CAGsJ_4wWzG-37D82vqP_zt+Fcbz+URVe5oXLBc4M5wbN8A_gpQ@mail.gmail.com
Signed-off-by: Barry Song <21cnbao@gmail.com>
Reported-by: SeongJae Park <sj@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/internal.h~mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix
+++ a/mm/internal.h
@@ -83,6 +83,8 @@ static inline void *folio_raw_mapping(st
 	return (void *)(mapping & ~PAGE_MAPPING_FLAGS);
 }
 
+#ifdef CONFIG_MMU
+
 /* Flags for folio_pte_batch(). */
 typedef int __bitwise fpb_t;
 
@@ -172,6 +174,7 @@ static inline int folio_pte_batch(struct
 
 	return min(ptep - start_ptep, max_nr);
 }
+#endif /* CONFIG_MMU */
 
 void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
 						int nr_throttled);
_

Patches currently in -mm which might be from 21cnbao@gmail.com are

mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix.patch

