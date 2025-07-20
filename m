Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DAE72601
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977170; cv=none; b=YulIRT7FR1UpMXxJ1ARPlae8StFCmVwJZ/2njXjcerhOhPNopdW8hkGPP98r2aX7vpZyVAXAdNib7bvdObfX3kclU5X4gqQOL6OeIwYe2xaXU3XKcG00wPzovnsoobArzFBd8HsKM9bGlVCdrLLSoS6NLwWPUsuxWfI+iyGYDMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977170; c=relaxed/simple;
	bh=68KygnwPOD874INEZsvW+QiMDu5HiYa6YyGlaPaReQA=;
	h=Date:To:From:Subject:Message-Id; b=NiM8xjnNh43ON2UOgUVWN8zxnOn/tb49yf00OJdL9gbG0Z0qFUK1EsC5XcQqpCkdqtwNg8eGNkHw94S6nLLVT+6pXYfgkHg4QFkCTEG4LcABN2PrT3+TJYCPtO9NBSAVa3Od3LIw+cuJNT9wP6pZ11LvTlZfAPwoDAqGfpwn2do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bvCV7OXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bvCV7OXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9633DC4CEE3;
	Sun, 20 Jul 2025 02:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977170;
	bh=68KygnwPOD874INEZsvW+QiMDu5HiYa6YyGlaPaReQA=;
	h=Date:To:From:Subject:From;
	b=bvCV7OXSoiTV5cMi/gS53iOxjFeHMYnN0OiKrdcBeGatJO6vE/5BCp74P1I5EtA9g
	 K6Dk1JRIQxl6y4oI67n6AzybB0GKlG3PGwWB2dYJevD3tLzHvrUlxHbTKU2QAF1+pv
	 mA3+UIZT6JTqEuz9DR4t35nCVDBYpVv3Ae72zP9o=
Date: Sat, 19 Jul 2025 19:06:10 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,colin.i.king@gmail.com,chanho.min@lge.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch removed from -mm tree
Message-Id: <20250720020610.9633DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix
has been removed from the -mm tree.  Its filename was
     squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch

This patch was dropped because it was folded into squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix
Date: Tue Jul  8 07:52:48 PM PDT 2025

fix build

Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Chanho Min <chanho.min@lge.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix
+++ a/fs/squashfs/block.c
@@ -89,7 +89,7 @@ static int squashfs_bio_read_cached(stru
 	int err = 0;
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
 	struct folio **cache_folios = kmalloc_array(page_count,
-			sizeof(*folio), GFP_KERNEL | __GFP_ZERO);
+			sizeof(*cache_folios), GFP_KERNEL | __GFP_ZERO);
 #endif
 
 	bio_for_each_folio_all(fi, fullbio) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
kasan-add-shadow-checks-to-wrappers-and-rename-kasan_arch_is_ready-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call.patch
init-kconfig-restore-config_broken-help-text.patch

