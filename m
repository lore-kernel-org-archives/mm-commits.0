Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8510F18801F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854831; cv=none; b=ZzGBmOuho15Xo63pWbVExQus/td3dzxZxB+Gz8Am95omQnY0j+o0C8JiYkMAxjF/Fvolc2n9yZ85ySQMYAD9rb41zgS9a+eKA+JzP9ANHjunh0EqDJwmklDQn3nqxkV5X/f0SiU5lP6U/pufABTaAgtN7GHpJ8JTmd781ryayoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854831; c=relaxed/simple;
	bh=CGK3s9x9cZn0CsRK5dvhBF1c32ZCXqfbHEJp+YjvCHA=;
	h=Date:To:From:Subject:Message-Id; b=Vw5DQ1BtatHXzUZID1ejnkI2RkAiyMUMrJ98HLiwqeZKP4DJpKZeBz7lgC8tNmLBCSzyYdqA1n2+j0fu12+iCEczYkpEBLfj1xVWXnoOQgxUqutdGPdF5BO59ePfUU3P8SyMJ4mK4RH8qbbCzp37SZ1ESPTviYHxo6WA8jrCwcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u1j8dSps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u1j8dSps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8C2C4CECF;
	Wed,  6 Nov 2024 01:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854831;
	bh=CGK3s9x9cZn0CsRK5dvhBF1c32ZCXqfbHEJp+YjvCHA=;
	h=Date:To:From:Subject:From;
	b=u1j8dSpsMVWzWyJHHZgOydwSiU5SVbmQCuXEf6Xh0W/GiDW5xQUDj0vNDzp7UBIeb
	 9B64zW/oxR0HJn9GjDaWbPw/u+cqclVXW/xl3g5tSVLCaU9h4Z/U+YBmFIFwTZ36hV
	 sFCwFN5IycFtchVsjphzb3pMwaW3GeaZRAk4cLQ4=
Date: Tue, 05 Nov 2024 17:00:30 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usama.anjum@collabora.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,anshuman.khandual@arm.com,kaixa@kiloview.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-has_isolate_pageblock.patch removed from -mm tree
Message-Id: <20241106010031.5D8C2C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unused has_isolate_pageblock
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-has_isolate_pageblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luoxi Li <kaixa@kiloview.com>
Subject: mm: remove unused has_isolate_pageblock
Date: Fri, 18 Oct 2024 17:22:35 +0800

has_isolate_pageblock() has been unused since commit 55612e80e722 ("mm:
page_alloc: close migratetype race between freeing and stealing")

Remove it.

Link: https://lkml.kernel.org/r/20241018092235.2764859-1-kaixa@kiloview.com
Signed-off-by: Luoxi Li <kaixa@kiloview.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/page-isolation.h~mm-remove-unused-has_isolate_pageblock
+++ a/include/linux/page-isolation.h
@@ -3,10 +3,6 @@
 #define __LINUX_PAGEISOLATION_H
 
 #ifdef CONFIG_MEMORY_ISOLATION
-static inline bool has_isolate_pageblock(struct zone *zone)
-{
-	return zone->nr_isolate_pageblock;
-}
 static inline bool is_migrate_isolate_page(struct page *page)
 {
 	return get_pageblock_migratetype(page) == MIGRATE_ISOLATE;
@@ -16,10 +12,6 @@ static inline bool is_migrate_isolate(in
 	return migratetype == MIGRATE_ISOLATE;
 }
 #else
-static inline bool has_isolate_pageblock(struct zone *zone)
-{
-	return false;
-}
 static inline bool is_migrate_isolate_page(struct page *page)
 {
 	return false;
_

Patches currently in -mm which might be from kaixa@kiloview.com are


