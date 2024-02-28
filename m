Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFF220DD5
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709144846; cv=none; b=htEHvNkKv4p1kESOySNSAnO9vOn6kAU9Jk/ltKIar1vc2lmn1fiMY3uLtoeHNGxVX29ByMYitgCcjZzNg0ETrQu1jUwnqBT+3FG0YiqkkO8mfjefyaUigsmxcx8L825ph1a7C7EdupXoDMxwBmic9JAcs51oougwpbz+5Q5vNWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709144846; c=relaxed/simple;
	bh=kKfFozVL0gBVF/WL4hAfwKJ9R+6ieVMe9M0XZToU7Ik=;
	h=Date:To:From:Subject:Message-Id; b=IBk6DosvUxYPVzbm7dayyTsjIO7jbEBHaYsDb7uHaLzpXsa4la8scZiTku02ZiQ6uiDaF19BnbOVoA4LlJF4dAbyFcvhnUnavlPrY6m6ZGl/MKlb4kYLM6etZc+IVzZOW45am2rtjsWKTSHHuDFKdebF+I8CGe4xeG7DzgLiFak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bWXZDQGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bWXZDQGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8823C433F1;
	Wed, 28 Feb 2024 18:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709144845;
	bh=kKfFozVL0gBVF/WL4hAfwKJ9R+6ieVMe9M0XZToU7Ik=;
	h=Date:To:From:Subject:From;
	b=bWXZDQGItk6QDhPzRMXzC9NL4Nq5rchmIr7gLZbx7KikNE/KRjEdmaT+iM+O7rCk/
	 X/Hda16rZ9x9AOh6CDcO9ArzdAvZnTAvnMGTqZyvnjedCYJxWa9giyiBmSioPwAANY
	 cwa4hyiFM/y9+QswmFz0piWQ3CxsfGNqiF3wu4TA=
Date: Wed, 28 Feb 2024 10:27:25 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix.patch removed from -mm tree
Message-Id: <20240228182725.C8823C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix
has been removed from the -mm tree.  Its filename was
     mm-make-folio_pte_batch-available-outside-of-mm-memoryc-fix.patch

This patch was dropped because it was folded into mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch

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

mm-make-folio_pte_batch-available-outside-of-mm-memoryc.patch

