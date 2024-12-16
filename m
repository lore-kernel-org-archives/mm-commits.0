Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEB9153573;
	Mon, 16 Dec 2024 05:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734326647; cv=none; b=OamjwcKflTXP+UXJ68z2dvbPIpH0Pum3PI217b+S9oyd6Ao4ZDvdmQGPIvWKQqIzCB5fqcQVWxbqMNibjuqxppUjKz4i+McSCN2iK0hvMFxNlre2W/+4PxIaBCQod5B6GJN07HmRWwGs+vyIG1CJ8u+GX8xqYdso/ZBn1SJwzjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734326647; c=relaxed/simple;
	bh=2D907gvTOJR4pHicUNGhMlBRsbcoEQkkBFVmA7inf1k=;
	h=Date:To:From:Subject:Message-Id; b=d1H/sbl/On9EylG/bFb2MVNLOiL8IfUPh7Mm0Wueb3vjItFX/OQZWaiY1J2HS53AbM/ywO9IiOZZlzro8Nzw3nlEIvRQ+AnUTSzLKSAId1CrulhHaDssgh1S9YHxu+t6+Q8lBzljW0jVN8u9Gpg5cxEU1NT4NTsrjNcIa4HK+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kUj2JDlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kUj2JDlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342CDC4CED0;
	Mon, 16 Dec 2024 05:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734326647;
	bh=2D907gvTOJR4pHicUNGhMlBRsbcoEQkkBFVmA7inf1k=;
	h=Date:To:From:Subject:From;
	b=kUj2JDlMWRhQR2CtuQcWeWKFIVOgxVP+KjZ5rRIZ8U6xO5++49PgFs+3VvGpW17V7
	 gArQ8npE4V18X45B0Fu8VRFQ0ByXJ4LZT0mJ9ShdtBDySvFdds+UvGE+DhbFtvlmqk
	 o+m9k4dsqRG/gSPTc5DgSYh9dMRIsGGMDJXL8xEs=
Date: Sun, 15 Dec 2024 21:24:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-readahead-fix-large-folio-support-in-async-readahead.patch removed from -mm tree
Message-Id: <20241216052407.342CDC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: fix large folio support in async readahead
has been removed from the -mm tree.  Its filename was
     mm-readahead-fix-large-folio-support-in-async-readahead.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/readahead: fix large folio support in async readahead
Date: Fri, 8 Nov 2024 22:17:10 +0800

When testing large folio support with XFS on our servers, we observed that
only a few large folios are mapped when reading large files via mmap. 
After a thorough analysis, I identified it was caused by the
`/sys/block/*/queue/read_ahead_kb` setting.  On our test servers, this
parameter is set to 128KB.  After I tune it to 2MB, the large folio can
work as expected.  However, I believe the large folio behavior should not
be dependent on the value of read_ahead_kb.  It would be more robust if
the kernel can automatically adopt to it.

With /sys/block/*/queue/read_ahead_kb set to 128KB and performing a
sequential read on a 1GB file using MADV_HUGEPAGE, the differences in
/proc/meminfo are as follows:

- before this patch
  FileHugePages:     18432 kB
  FilePmdMapped:      4096 kB

- after this patch
  FileHugePages:   1067008 kB
  FilePmdMapped:   1048576 kB

This shows that after applying the patch, the entire 1GB file is mapped to
huge pages.  The stable list is CCed, as without this patch, large folios
don't function optimally in the readahead path.

It's worth noting that if read_ahead_kb is set to a larger value that
isn't aligned with huge page sizes (e.g., 4MB + 128KB), it may still fail
to map to hugepages.

Link: https://lkml.kernel.org/r/20241108141710.9721-1-laoar.shao@gmail.com
Fixes: 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/readahead.c~mm-readahead-fix-large-folio-support-in-async-readahead
+++ a/mm/readahead.c
@@ -390,6 +390,8 @@ static unsigned long get_next_ra_size(st
 		return 4 * cur;
 	if (cur <= max / 2)
 		return 2 * cur;
+	if (cur > max)
+		return cur;
 	return max;
 }
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-readahead-fix-large-folio-support-in-async-readahead-v3.patch

