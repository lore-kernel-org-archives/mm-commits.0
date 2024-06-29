Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FFF15E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628295; cv=none; b=RBCny58BmR6KrLKGGCjQRQjqNCGofGADw6Cb4DYlV5g5vegVIQK3UfjNGAvIHYXUk2aR8jqeKCJ4uo3A5wUB158eQFUimXpnjk8Ex3WbFuSK33A0XRPGVzQlSLu2fug3gE/U/b7cdID3iDY95PKvW0U+k7l2ExLtriENT4kWhQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628295; c=relaxed/simple;
	bh=SHt8nRYQEXM1pptK1Ik91c8dSfJJ4dMN521Rn0H6yoU=;
	h=Date:To:From:Subject:Message-Id; b=E1RTUbJ0t9e9W6i6SspaL0m3TgIdl1xa2TGh41vzVx6KCk16byeCLgigJVGTYGpeE5BCBT4anKrb2V1FVJpw7iDgrYV5q4VBm3CaQ+yWq4vhlnmCRi/TrbDMc6BE9pad68UV240YZBfleXgW8GzKCcIr2WDnqwOg6Du74y8TMxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M/vhiUxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M/vhiUxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F186C32781;
	Sat, 29 Jun 2024 02:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628295;
	bh=SHt8nRYQEXM1pptK1Ik91c8dSfJJ4dMN521Rn0H6yoU=;
	h=Date:To:From:Subject:From;
	b=M/vhiUxU1opoAT5Js2haOC8XtvzFQlRajV+jf840plGet7LLgnA48fAkaaQ3lX0bW
	 zC0ayNPEsIVF7NiyRmDkSCu6utN/eROXuqgW/XqCjAeiGeLQbxvxw/FZCRUaA4WEJE
	 rUCuY4RObs4F3CgnUVFGEEhRSnHgm5RiSnt4Jihk=
Date: Fri, 28 Jun 2024 19:31:34 -0700
To: mm-commits@vger.kernel.org,zhangpengpeng0808@gmail.com,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-fix-page_cache_next_miss-when-no-hole-found.patch removed from -mm tree
Message-Id: <20240629023135.4F186C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: fix page_cache_next_miss() when no hole found
has been removed from the -mm tree.  Its filename was
     filemap-fix-page_cache_next_miss-when-no-hole-found.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: filemap: fix page_cache_next_miss() when no hole found
Date: Tue, 25 Jun 2024 12:18:52 +0200

page_cache_next_miss() should return value outside of the specified range
when no hole is found.  However currently it will return the last index
*in* the specified range confusing ondemand_readahead() to think there's a
hole in the searched range and upsetting readahead logic.

Link: https://lkml.kernel.org/r/20240625101909.12234-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Zhang Peng <zhangpengpeng0808@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/filemap.c~filemap-fix-page_cache_next_miss-when-no-hole-found
+++ a/mm/filemap.c
@@ -1752,12 +1752,12 @@ pgoff_t page_cache_next_miss(struct addr
 	while (max_scan--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
-			break;
+			return xas.xa_index;
 		if (xas.xa_index == 0)
-			break;
+			return 0;
 	}
 
-	return xas.xa_index;
+	return index + max_scan;
 }
 EXPORT_SYMBOL(page_cache_next_miss);
 
_

Patches currently in -mm which might be from jack@suse.cz are


