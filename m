Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252A58494
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101682; cv=none; b=kJR73xdSNjlbkp06+zL/7CggkvojUYMvn1zM1c6jCAquCak7qW7SOEj7gEtXS5eUq23ABlLTzqGRNVb4N/y1DzLIIRp+rywZncTwYM93BQDEk6Og1k7+TvKpsDhir3zVt6ZVWL0Hf9iLquM1O4jp+QuBjJizcKEvjWRZcaMhh7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101682; c=relaxed/simple;
	bh=phcnORNHz0ykICAOAyxXYjlM1QRsE7DOcOBCuU7WqS0=;
	h=Date:To:From:Subject:Message-Id; b=Xc85QNngxvgWRWi7M7dH7FmlInzlp4fLy2X54KuqFJTaAY1rO/CMON69AFPlswAUUzJR1f+3H0ij0PlvCq4WwQbiW0pelfo2q7gh68jGEEbUx/WgvAkG47DJzGjaumidD4iVOObtWNyfi8GLb9ZJ8tY7hS1w3zw+Ob/uXpivoM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hjewM2Gx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hjewM2Gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AB2C113CD;
	Fri, 26 Apr 2024 03:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101682;
	bh=phcnORNHz0ykICAOAyxXYjlM1QRsE7DOcOBCuU7WqS0=;
	h=Date:To:From:Subject:From;
	b=hjewM2GxWDHlrQF1XkIlA98mOdlkYJmzQKLrHIckBWBPFACQUH7drUkyLapBaIHbJ
	 lThLfoMTAmYGvWjnsIQ8JQRxo6Sg0NvbgPN0DpFpY69VtBN7DYDoxfeMQrtB6du9Fo
	 9TXwu9tmGCrZESaI8ShimZMKeTd264NBnELrLs2Q=
Date: Thu, 25 Apr 2024 20:21:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@ZenIV.linux.org.uk,tujinjiang@huawei.com,jack@suse.cz,brauner@kernel.org,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags-fix.patch removed from -mm tree
Message-Id: <20240426032121.E6AB2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: don't decrease mmap_miss when folio has workingset flag
has been removed from the -mm tree.  Its filename was
     mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags-fix.patch

This patch was dropped because it was folded into mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags.patch

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/filemap: don't decrease mmap_miss when folio has workingset flag
Date: Tue, 26 Mar 2024 14:50:26 +0800

add comments

Link: https://lkml.kernel.org/r/20240326065026.1910584-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/filemap.c~mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags-fix
+++ a/mm/filemap.c
@@ -3492,6 +3492,13 @@ static vm_fault_t filemap_map_folio_rang
 		if (PageHWPoison(page + count))
 			goto skip;
 
+		/*
+		 * If there are too many folios that are recently evicted
+		 * in a file, they will probably continue to be evicted.
+		 * In such situation, read-ahead is only a waste of IO.
+		 * Don't decrease mmap_miss in this scenario to make sure
+		 * we can stop read-ahead.
+		 */
 		if (!folio_test_workingset(folio))
 			(*mmap_miss)++;
 
@@ -3542,6 +3549,7 @@ static vm_fault_t filemap_map_order0_fol
 	if (PageHWPoison(page))
 		return ret;
 
+	/* See comment of filemap_map_folio_range() */
 	if (!folio_test_workingset(folio))
 		(*mmap_miss)++;
 
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-readahead-break-read-ahead-loop-if-filemap_add_folio-return-enomem.patch
mm-readahead-dont-decrease-mmap_miss-when-folio-has-workingset-flags.patch

