Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA2A27473
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382341; cv=none; b=NR7bWWwtcdIUTfV7PsrVpQsezbsNTmvhm8AZHOeOlglA3eNZN22+68j/KJpHWSLj1NNfW55bMYZOyHH75XMmLbKgMwo7nBs/NweU+wh9eLdGHjOIXwPyZVm/fdWlpM9taewiJEpzTD2iZHQ2dWRoCk9h3eulhsyfa4497mi2LTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382341; c=relaxed/simple;
	bh=xdOnx4FW+hocr5YRkR2rA0VBPX0boVfKnAG7uswrDok=;
	h=Date:To:From:Subject:Message-Id; b=jnpy0vAhm041AOodEeieAbwpgnEtWh9zUM1DY0XWXBEf9IwrElRkVaQXm2Dd6LpUyDDpOeTtNBHyb3U5tx5mJmaKY/KiiEuGdHIChRObnUoZpyVM543dcMN8ZRw7bxoZJMH0v80y9FQwM8/Ebs6l1F9rkVioSkbQGiSWwJM3ZWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M9WAw62C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M9WAw62C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47E3C4CEC7;
	Thu, 26 Sep 2024 20:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382341;
	bh=xdOnx4FW+hocr5YRkR2rA0VBPX0boVfKnAG7uswrDok=;
	h=Date:To:From:Subject:From;
	b=M9WAw62CmTBgeheJQZbsH18WmiuGHd7qCuJAkjKKpGZdlhnS+ZxMzP4ZRiykeGA+t
	 J+hJ4gbJjZ7tWVoeTFHs1Un5VuCRG1YtaqAzJ5wlbj3Qf1G3i455GI91OFQoh/+JNW
	 rs62C/Y0cJhw42OUffJ5cEPjfD7JUgLWG/5tWNkM=
Date: Thu, 26 Sep 2024 13:25:39 -0700
To: mm-commits@vger.kernel.org,gaoxiang17@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-print-total-and-used-count-in-cma_alloc.patch added to mm-unstable branch
Message-Id: <20240926202540.E47E3C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: print total and used count in cma_alloc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-print-total-and-used-count-in-cma_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-print-total-and-used-count-in-cma_alloc.patch

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
From: gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: mm/cma: print total and used count in cma_alloc()
Date: Thu, 26 Sep 2024 20:00:49 +0800

To better understand cma area during debugging.

before:
[   24.407814] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
[   24.413397] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
[   24.415886] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)

after:
[   24.097989] cma: cma_alloc(cma (____ptrval____), name: reserved, total count 16384, used count: 64, request count 1, align 0)
[   24.104260] cma: cma_alloc(cma (____ptrval____), name: reserved, total count 16384, used count: 65, request count 1, align 0)
[   24.107504] cma: cma_alloc(cma (____ptrval____), name: reserved, total count 16384, used count: 66, request count 1, align 0)

Link: https://lkml.kernel.org/r/20240926120049.321514-1-gxxa03070307@gmail.com
Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-print-total-and-used-count-in-cma_alloc
+++ a/mm/cma.c
@@ -403,6 +403,17 @@ static void cma_debug_show_areas(struct
 	spin_unlock_irq(&cma->lock);
 }
 
+static unsigned long cma_get_used(struct cma *cma)
+{
+	unsigned long used;
+
+	spin_lock_irq(&cma->lock);
+	used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
+	spin_unlock_irq(&cma->lock);
+
+	return used << cma->order_per_bit;
+}
+
 static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 				unsigned int align, gfp_t gfp)
 {
@@ -420,8 +431,8 @@ static struct page *__cma_alloc(struct c
 	if (!cma || !cma->count || !cma->bitmap)
 		return page;
 
-	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
-		(void *)cma, cma->name, count, align);
+	pr_debug("%s(cma %p, name: %s, total count %lu, used count: %lu, request count %lu, align %d)\n", __func__,
+		(void *)cma, cma->name, cma->count, cma_get_used(cma), count, align);
 
 	if (!count)
 		return page;
_

Patches currently in -mm which might be from gaoxiang17@xiaomi.com are

mm-cma-print-total-and-used-count-in-cma_alloc.patch

