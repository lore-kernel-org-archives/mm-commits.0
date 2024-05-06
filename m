Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0B010A0E
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957013; cv=none; b=bi3B0S1qwlMjwQo5x2iemMw8/hHlZCUAj3Jlg50mDXNpUxN1nRSKTQOoYgquK/cUTfSsKPANjmRQ8AO1mQVbojrI/qVhuf5U/OuS7QO9PTiD71HDETc170AQVPP9gcDP3sqsHtUDJxykoGzFuy7E4ZHeDwfM47nyYkDvahC3zyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957013; c=relaxed/simple;
	bh=NlbvndzFyeNgrpSYJtP7ADd3WQThlgTRdA1DLZxLQFM=;
	h=Date:To:From:Subject:Message-Id; b=U5NQx+a6Zf4tSg3Qj1ASZ7L6SJFwLs+Qkbeg3f7QQaOaEyTT6vEp3Azp2GtLWp4GwpSZDhaD8egSmIfjcRjiJsYjeOJ+SeCAV3+zq3IoCAoocb+5B61Ya6xBhiX75Y9RN3FUaUyFsNNkZbdwfpXF74p+IjWbXaqVUgFY4QpVH3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z60DdpD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z60DdpD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91063C113CC;
	Mon,  6 May 2024 00:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957013;
	bh=NlbvndzFyeNgrpSYJtP7ADd3WQThlgTRdA1DLZxLQFM=;
	h=Date:To:From:Subject:From;
	b=z60DdpD2amvl8gbyniiYaWt3JSoSsGo3hqsdFOE99r92lB3aPbxBg2Sg7YrW5Vm+N
	 8oG35hdy1T9PiMiqGWG71mVr7UQ53JfNydTXEZQvTpL6QeYmss04FucXv0YWqVMTcZ
	 +CRBAO1yEX8jSVITvV40AGxh3cs8ZSOCro0iY/oY=
Date: Sun, 05 May 2024 17:56:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] trace-events-page_ref-trace-the-raw-page-mapcount-value.patch removed from -mm tree
Message-Id: <20240506005653.91063C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: trace/events/page_ref: trace the raw page mapcount value
has been removed from the -mm tree.  Its filename was
     trace-events-page_ref-trace-the-raw-page-mapcount-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: trace/events/page_ref: trace the raw page mapcount value
Date: Tue, 9 Apr 2024 21:22:58 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.  We already trace raw page->refcount, raw
page->flags and raw page->mapping, and don't involve any folios.  Let's
also trace the raw mapcount value that does not consider the entire
mapcount of large folios, and we don't add "1" to it.

When dealing with typed folios, this makes a lot more sense.  ...  and
it's for debugging purposes only either way.

Link: https://lkml.kernel.org/r/20240409192301.907377-16-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/page_ref.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/trace/events/page_ref.h~trace-events-page_ref-trace-the-raw-page-mapcount-value
+++ a/include/trace/events/page_ref.h
@@ -30,7 +30,7 @@ DECLARE_EVENT_CLASS(page_ref_mod_templat
 		__entry->pfn = page_to_pfn(page);
 		__entry->flags = page->flags;
 		__entry->count = page_ref_count(page);
-		__entry->mapcount = page_mapcount(page);
+		__entry->mapcount = atomic_read(&page->_mapcount);
 		__entry->mapping = page->mapping;
 		__entry->mt = get_pageblock_migratetype(page);
 		__entry->val = v;
@@ -79,7 +79,7 @@ DECLARE_EVENT_CLASS(page_ref_mod_and_tes
 		__entry->pfn = page_to_pfn(page);
 		__entry->flags = page->flags;
 		__entry->count = page_ref_count(page);
-		__entry->mapcount = page_mapcount(page);
+		__entry->mapcount = atomic_read(&page->_mapcount);
 		__entry->mapping = page->mapping;
 		__entry->mt = get_pageblock_migratetype(page);
 		__entry->val = v;
_

Patches currently in -mm which might be from david@redhat.com are


