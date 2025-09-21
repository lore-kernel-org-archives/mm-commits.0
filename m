Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A43418E02A
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758485188; cv=none; b=uIZIPlvBFp03fCeDt9zuq7f0NQk3Wi56kHMGtTUe0XdHTAudrohC5b3l57wLJPHmowkaXlNX1uC7rkJyN62+Cv7JHFG6QwFzQ8TsktgllFXLT4ZXAJiBxkenTHPRG48dO3Qi6eYKbBtAasG9QHscyCeeGaRdSgK++FVg7ov/VLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758485188; c=relaxed/simple;
	bh=VQONpj/qDPTRqzn9ZAb2+2ow+JUynUD8J2YYpGQeJEw=;
	h=Date:To:From:Subject:Message-Id; b=e/PWh20U3H6H7O8ht13c9aQ8xK3XZhJ6SPGseM3olMQnx9s5o9wpIMqZQJeE7wFhs1e4g/U/26IrVMVOzT28/S1suveizNL+WQf2GKAs5bsxVyXZL8pY/VEzHDQphrW4iu34szvtAwnD2fwMcXTwR5WLL7VZtOFrtGYd4xkXUyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NlDNitE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NlDNitE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F602C4CEE7;
	Sun, 21 Sep 2025 20:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758485187;
	bh=VQONpj/qDPTRqzn9ZAb2+2ow+JUynUD8J2YYpGQeJEw=;
	h=Date:To:From:Subject:From;
	b=NlDNitE7SFTotZSFKoTMqoVk7nA/rWf8V/uwthWH1eGPp2KMFwtPstfejAcebHPtA
	 UPprCfBav6Uf2WBjqHADN/4Vdv9hfRbOtB7fEYR0TLvAzASnpB2UJE7Xl9n608Euxr
	 AjqsVgRCnT89unxf3Nkd9r3yyuAIfVrEdmS7G6O0=
Date: Sun, 21 Sep 2025 13:06:26 -0700
To: mm-commits@vger.kernel.org,youling.tang@linux.dev,willy@infradead.org,tangyouling@kylinos.cn,ryan.roberts@arm.com,jack@suse.cz,david@redhat.com,chizhiling@kylinos.cn,klarasmodin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-filemap-align-last_index-to-folio-size-fix.patch removed from -mm tree
Message-Id: <20250921200627.8F602C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-filemap-align-last_index-to-folio-size-fix
has been removed from the -mm tree.  Its filename was
     mm-filemap-align-last_index-to-folio-size-fix.patch

This patch was dropped because it was folded into mm-filemap-align-last_index-to-folio-size.patch

------------------------------------------------------
From: Klara Modin <klarasmodin@gmail.com>
Subject: mm-filemap-align-last_index-to-folio-size-fix
Date: Tue, 15 Jul 2025 00:34:12 +0200

fix overflow on 32-bit

iocb->ki_pos is loff_t (long long) while pgoff_t is unsigned long and
this overflow seems to happen in practice, resulting in last_index being
before index.

Link: https://lkml.kernel.org/r/yru7qf5gvyzccq5ohhpylvxug5lr5tf54omspbjh4sm6pcdb2r@fpjgj2pxw7va
Signed-off-by: Klara Modin <klarasmodin@gmail.com>
Cc: Chi Zhiling <chizhiling@kylinos.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: Youling Tang <youling.tang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-align-last_index-to-folio-size-fix
+++ a/mm/filemap.c
@@ -2601,8 +2601,8 @@ static int filemap_get_pages(struct kioc
 	int err = 0;
 
 	/* "last_index" is the index of the folio beyond the end of the read */
-	last_index = round_up(iocb->ki_pos + count, mapping_min_folio_nrbytes(mapping));
-	last_index >>= PAGE_SHIFT;
+	last_index = round_up(iocb->ki_pos + count,
+			mapping_min_folio_nrbytes(mapping)) >> PAGE_SHIFT;
 retry:
 	if (fatal_signal_pending(current))
 		return -EINTR;
_

Patches currently in -mm which might be from klarasmodin@gmail.com are

mm-filemap-align-last_index-to-folio-size.patch

