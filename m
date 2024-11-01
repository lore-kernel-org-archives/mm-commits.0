Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F523B7A8
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 02:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730426541; cv=none; b=EZfTCxwzJtkA2on0CIKrMgD4/7niyOOsZJuzF6GQ7XOfX4/nYgCl7hybPWCQ19H10HKfCdPBreiTtwDhZHIspNDzBqtiYAiSu2bg3kEtyc8MS+JjsS145sa+x4ifol09ZT8kkksmP+bj5GeuVYILJLgNX8fM+wUNM3ySkk0GLtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730426541; c=relaxed/simple;
	bh=lgO16A/N3JlDF477bMnqLLCUdMQfc8xmRLLjhfyq4rQ=;
	h=Date:To:From:Subject:Message-Id; b=PdHAkr5GUzrvKSpQ3sUldORFg6EiuAv1U3sEapbwOwNCHhbzauIuqO3Og+N4z+Mpquz88YJNdnulAXzibY7zaJlwC4PJLh0sg2h1f0styeTeMujMB8bfJoVuklBmCjuggNshv0p1FMnxtbQrEpv5V3CJLcQIKy1B25Ph9EEtUe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QJVtq0Im; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QJVtq0Im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA659C4CEC3;
	Fri,  1 Nov 2024 02:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730426539;
	bh=lgO16A/N3JlDF477bMnqLLCUdMQfc8xmRLLjhfyq4rQ=;
	h=Date:To:From:Subject:From;
	b=QJVtq0Im4LzJxRTkr8WQ0VOXX9baalHAkrHIZV5q5RDcDdLFTYcwusiSligV+qUQZ
	 //M8y/JrAb7O8bWUv8uFIz4UgqzUXxwMiV7RQbkR19b3eB8JRlOLH46nCAHYJOeS3O
	 YbDZEXfTJLwADLD6BQEJLIZ3eJY9A2/sNGLOxL/A=
Date: Thu, 31 Oct 2024 19:02:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix.patch added to mm-unstable branch
Message-Id: <20241101020219.DA659C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix
Date: Fri, 1 Nov 2024 09:56:29 +0800

code layout cleaup, per dhowells

Link: https://lkml.kernel.org/r/32dd938c-3531-49f7-93e4-b7ff21fec569@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: David Howells <dhowells@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix
+++ a/mm/shmem.c
@@ -3332,12 +3332,11 @@ static ssize_t shmem_file_splice_read(st
 		 * Fallback to PAGE_SIZE splice if the large folio has hwpoisoned
 		 * pages.
 		 */
-		if (likely(!fallback_page_splice)) {
-			size = len;
-		} else {
+		size = len;
+		if (unlikely(fallback_page_splice)) {
 			size_t offset = *ppos & ~PAGE_MASK;
 
-			size = min_t(loff_t, PAGE_SIZE - offset, len);
+			size = umin(size, PAGE_SIZE - offset);
 		}
 		part = min_t(loff_t, isize - *ppos, size);
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch
mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic.patch
mm-shmem-improve-the-tmpfs-large-folio-read-performance.patch
mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch
mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix.patch

