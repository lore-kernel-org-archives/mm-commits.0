Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DAF14286
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 22:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747088588; cv=none; b=c2Z4eTGe1XeRcwWMswMrMBM09adUeRds/C3ahE850VKvrLyr735huNlnfs/Df8YOgQ19cRhV21r54DOEYWC1qb2f+xUL6bdUyOpWtANGRrkvMWn/0rzqRLP0sqNqQjm+Vx/Tw5/XeeOtFdW+i4ho3m/t2zf77NJ5DBWX32XS8A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747088588; c=relaxed/simple;
	bh=sVVa/vi0p8eJnsLg1lSQN3GsrAXeCdqTaUEQJvtn4ao=;
	h=Date:To:From:Subject:Message-Id; b=q9CvjF7wGzxuUTPY9X8QBh+vgzDXMq+c2LaHV4qQT1GhG2T7Gt3Uz+2zjmhILTxavzAENo+SYGjLGt01jfAFtYOmP7Uxm2SczVOu33fNWCYA0gFHNHCOTFjOnPRUdoiR0Q58L+Sbymze0sMs9SmyZCS8SZ6t1LSHYHAIXjW+IeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BIBjVKvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BIBjVKvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA4FC4CEE7;
	Mon, 12 May 2025 22:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747088587;
	bh=sVVa/vi0p8eJnsLg1lSQN3GsrAXeCdqTaUEQJvtn4ao=;
	h=Date:To:From:Subject:From;
	b=BIBjVKvrs/s4St36bhMxNfVtWtayrdiBxmYjHm7hUktZk5VAyNv2lvkF9NVEYpaX1
	 bAuB+lHxpVRy+FDhjNyo0w7S10IY6nwP3tbpz6+L8adS1Bjn8Il/AJ6tXUOt7MOo8h
	 zBMLQYwOugXR8AwmA/AMJZk1T8RFAzFdSQ4X5OIk=
Date: Mon, 12 May 2025 15:23:07 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,harry.yoo@oracle.com,dja@axtens.net,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-avoid-sleepable-page-allocation-from-atomic-context-v7.patch added to mm-hotfixes-unstable branch
Message-Id: <20250512222307.ABA4FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan-avoid-sleepable-page-allocation-from-atomic-context-v7
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-avoid-sleepable-page-allocation-from-atomic-context-v7.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-avoid-sleepable-page-allocation-from-atomic-context-v7.patch

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
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: kasan-avoid-sleepable-page-allocation-from-atomic-context-v7
Date: Mon, 12 May 2025 16:27:06 +0200

do not unnecessary free pages across iterations

Link: https://lkml.kernel.org/r/c8eeeb146382bcadabce5b5dcf92e6176ba4fb04.1747059374.git.agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Axtens <dja@axtens.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/kasan/shadow.c~kasan-avoid-sleepable-page-allocation-from-atomic-context-v7
+++ a/mm/kasan/shadow.c
@@ -337,9 +337,9 @@ static inline void free_pages_bulk(struc
 
 static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
 {
-	unsigned long nr_populated, nr_pages, nr_total = PFN_UP(end - start);
+	unsigned long nr_pages, nr_populated = 0, nr_total = PFN_UP(end - start);
 	struct vmalloc_populate_data data;
-	int ret;
+	int ret = 0;
 
 	data.pages = (struct page **)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (!data.pages)
@@ -349,25 +349,24 @@ static int __kasan_populate_vmalloc(unsi
 		nr_pages = min(nr_total, PAGE_SIZE / sizeof(data.pages[0]));
 		nr_populated = alloc_pages_bulk(GFP_KERNEL, nr_pages, data.pages);
 		if (nr_populated != nr_pages) {
-			free_pages_bulk(data.pages, nr_populated);
-			free_page((unsigned long)data.pages);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			break;
 		}
 
 		data.start = start;
 		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
 					  kasan_populate_vmalloc_pte, &data);
-		free_pages_bulk(data.pages, nr_pages);
 		if (ret)
-			return ret;
+			break;
 
 		start += nr_pages * PAGE_SIZE;
 		nr_total -= nr_pages;
 	}
 
+	free_pages_bulk(data.pages, nr_populated);
 	free_page((unsigned long)data.pages);
 
-	return 0;
+	return ret;
 }
 
 int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

kasan-avoid-sleepable-page-allocation-from-atomic-context.patch
kasan-avoid-sleepable-page-allocation-from-atomic-context-v7.patch

