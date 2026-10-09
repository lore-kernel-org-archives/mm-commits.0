Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7604B4229B0
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525579; cv=none; b=Sc2+Gi/2VTZUyboX5A00R/LvmHGj1EiRLb5hiPDPRUzx+Z4PacnavrTZyEcfXC6RZOP3lknK677ZB+nqUs22ernKP4HqXPjUMxXdAYLDOp6yHDa9k+sljnU2nW+4FfvC6u3j8LLHogwfRL9CAoJszHqFb+01L2tIRzMlzHrmdN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525579; c=relaxed/simple;
	bh=lnyH9oQyD3vroDovskIyt9wXbq9pCshmAkWtAshJ9As=;
	h=Date:To:From:Subject:Message-Id; b=A+DzYDyVQbvT2V3zxA9qTEvk8Ugh4EEgCtR3uZQJMaPHtGxT0vod78eFvh3B9s9/BxKnRK7yFC4GazkNdEhXGz7Rvf6i8M8HsBF0IDvDIC9xkJSYoLBQ0HwDDU497EFdu7UlxlIqPpuQO51hAtZdFJXTCvom0LPo8SKQQpU+KHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PcnsJWnH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PcnsJWnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE0C1F000FF;
	Fri,  9 Oct 2026 05:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525575;
	bh=2YXu8MnEkmfc45ot4IHTSXF/JKCDUSmL0UAJCMcCcUQ=;
	h=Date:To:From:Subject;
	b=PcnsJWnHeN8Q/WguHSMzQGJVHuitJ7d7cIIdzBZPG+rgltTDODIg5lQpwmgrUVcPB
	 zkfDPM/MeynweKxFEaafg6blwqZLi0vaGuW0pvvZkc6/Isr7KgEE6iKMDQyZeLnVBK
	 eiWiAvzbys1nnESfwiQXlUBeq69HNaaTuX2FyesE=
Date: Thu, 08 Oct 2026 22:59:34 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,tytso@mit.edu,lance.yang@linux.dev,jaegeuk@kernel.org,ebiggers@kernel.org,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fscrypt-stop-setting-pg_private-on-bounce-page.patch removed from -mm tree
Message-Id: <20261009055935.3CE0C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fscrypt: stop setting PG_private on bounce page
has been removed from the -mm tree.  Its filename was
     fscrypt-stop-setting-pg_private-on-bounce-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: fscrypt: stop setting PG_private on bounce page
Date: Sun, 20 Sep 2026 22:28:00 -0400

The pointer to a plain text folio is stored in bound_page->private and
cannot be NULL until the bounce_page is freed, making PG_private redundant.

It prepares for a future commit that remove PG_private.

No functional change intended.

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-4-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
---

 fs/crypto/crypto.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/crypto/crypto.c~fscrypt-stop-setting-pg_private-on-bounce-page
+++ a/fs/crypto/crypto.c
@@ -65,7 +65,6 @@ void fscrypt_free_bounce_page(struct pag
 	if (!bounce_page)
 		return;
 	set_page_private(bounce_page, (unsigned long)NULL);
-	ClearPagePrivate(bounce_page);
 	mempool_free(bounce_page, fscrypt_bounce_page_pool);
 }
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
@@ -210,7 +209,6 @@ struct page *fscrypt_encrypt_pagecache_b
 			return ERR_PTR(err);
 		}
 	}
-	SetPagePrivate(ciphertext_page);
 	set_page_private(ciphertext_page, (unsigned long)folio);
 	return ciphertext_page;
 }
_

Patches currently in -mm which might be from ziy@nvidia.com are


