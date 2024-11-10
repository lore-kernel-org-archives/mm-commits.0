Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373F313B58F;
	Sun, 10 Nov 2024 06:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731219168; cv=none; b=VBvVwavOob6CYqEdhTxEh/Ztyn3FWPcF/1cnbR8CaGRKftd0eas2HUI5Qy07RK87TNpNgsE2O4pRcZMtk5KIkbu1vTCrBXWn4tXfNQ5azRI1v7azKTZLMgzgpbKURRTxyU2VwDlsRwbijAJ5e2YJnaEq2vJcN6ZElfv85iSY2kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731219168; c=relaxed/simple;
	bh=MXjhEee1Cb0fgC1Vt0pa51qmQzHST0qk35mgn3YyL14=;
	h=Date:To:From:Subject:Message-Id; b=UhuxTJ7UWz22hkCleDEQX8kl7KXgg6vfVu6iuB1yC1jevRAwDEx4ha8sR+Xhw1ietElauplv60YMUIMiYUJxR8TiCdBFlOpAg182FOyGkw74ciArUtEm8cfKHQaj3TYXtM+c90DVQf4XGLd3eIsKh37CKU+gylJpnjPvextH4YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qI0hVz2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qI0hVz2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8E9C4CECD;
	Sun, 10 Nov 2024 06:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731219167;
	bh=MXjhEee1Cb0fgC1Vt0pa51qmQzHST0qk35mgn3YyL14=;
	h=Date:To:From:Subject:From;
	b=qI0hVz2UymdPd6W7Drme21rM8/6a25t13tHu6pmMa0rwQA0MvmbXNDdoPKu/wytJ9
	 am4rvVGMTLTWBmmHOd7F89gyTaJPuEvc8JVKp4th+dZCOSqcmsg9aayKH5aeGoRe7M
	 GqKLv+TUKMSuI2C9PNc4sFCJSiO6+iMrdrSPRBKk=
Date: Sat, 09 Nov 2024 22:12:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-fix-large-folio-support-in-async-readahead.patch added to mm-hotfixes-unstable branch
Message-Id: <20241110061247.BF8E9C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: fix large folio support in async readahead
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-readahead-fix-large-folio-support-in-async-readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-fix-large-folio-support-in-async-readahead.patch

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
@@ -385,6 +385,8 @@ static unsigned long get_next_ra_size(st
 		return 4 * cur;
 	if (cur <= max / 2)
 		return 2 * cur;
+	if (cur > max)
+		return cur;
 	return max;
 }
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-readahead-fix-large-folio-support-in-async-readahead.patch

