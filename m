Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EE71862A
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 05:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755321639; cv=none; b=VJbRZ3EVXo2haKz7LLaOj7Pk+HVM4hFwWm3kag0LTZC4ZVM8zVU4CjeqfNxfqEj+oaxuY1VA3i4Z0ksoz2qTRwQx2bwyNDotSmZtqMybGPRZCsnSfngJzS6xRvmCB0PzvepMaoe0zPGA9DJWXgvadhGUD8GLeeubSRscvFmuWWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755321639; c=relaxed/simple;
	bh=j1QM5Pe225IgpA7S6jxNoqujkQxZC8OWVo1bbP+eyaU=;
	h=Date:To:From:Subject:Message-Id; b=pYdOYOSmw5lZZDCzy/AJIR+tZlTZzTMTZ1STBmjUJJcilexxZI86XQToq8WpUJvwRHv36CURmTCgN+mN6IpNDQG0rjMXh/2v4SlSHY0bPoFxWI8Vd5yNYJRmLmzz/Mf+QN4hx0VH/dqL6xT9oeoqTzR8BUdYSODW5PHjWmsQ3Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XhMVEOdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XhMVEOdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F63C4CEEF;
	Sat, 16 Aug 2025 05:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755321637;
	bh=j1QM5Pe225IgpA7S6jxNoqujkQxZC8OWVo1bbP+eyaU=;
	h=Date:To:From:Subject:From;
	b=XhMVEOdVJDx4ylsD7EhDDMKwCWnOjexOCA4/3jVefEScTL71TAP/5orHB4DOQyDOy
	 PbRte/hhS6PoumhLZZkbedp0LQoz8Qbt44oCi5MEUtNs73pRg29mqGHGkqtaDYb/w1
	 Ba0x+6uKkiqN/Ap4j3ZfjVYpEulv7+3BaHvwodX4=
Date: Fri, 15 Aug 2025 22:20:36 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,gaoxiang17@xiaomi.com,david@redhat.com,gxxa03070307@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-print-total-and-used-pages-in-cma_alloc.patch added to mm-new branch
Message-Id: <20250816052037.B7F63C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: print total and used pages in cma_alloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-print-total-and-used-pages-in-cma_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-print-total-and-used-pages-in-cma_alloc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Xiang Gao <gxxa03070307@gmail.com>
Subject: mm/cma: print total and used pages in cma_alloc()
Date: Sat, 16 Aug 2025 12:28:42 +0800


This makes cma info more intuitive during debugging.

before:
[   24.407814] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
[   24.413397] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)
[   24.415886] cma: cma_alloc(cma (____ptrval____), name: reserved, count 1, align 0)

after:
[   24.069738] cma: cma_alloc(cma (____ptrval____), name: reserved, total pages: 16384, used pages: 64, request pages: 1, align 0)
[   24.075317] cma: cma_alloc(cma (____ptrval____), name: reserved, total pages: 16384, used pages: 65, request pages: 1, align 0)
[   24.078455] cma: cma_alloc(cma (____ptrval____), name: reserved, total pages: 16384, used pages: 66, request pages: 1, align 0)

Link: https://lkml.kernel.org/r/20250816042842.3959315-1-gxxa03070307@gmail.com
Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-print-total-and-used-pages-in-cma_alloc
+++ a/mm/cma.c
@@ -776,6 +776,17 @@ static void cma_debug_show_areas(struct
 	spin_unlock_irq(&cma->lock);
 }
 
+static unsigned long cma_get_used_pages(struct cma *cma)
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
 static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 				unsigned long count, unsigned int align,
 				struct page **pagep, gfp_t gfp)
@@ -858,8 +869,8 @@ static struct page *__cma_alloc(struct c
 	if (!cma || !cma->count)
 		return page;
 
-	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
-		(void *)cma, cma->name, count, align);
+	pr_debug("%s(cma %p, name: %s, total pages: %lu, used pages: %lu, request pages: %lu, align %d)\n",
+		__func__, (void *)cma, cma->name, cma->count, cma_get_used_pages(cma), count, align);
 
 	if (!count)
 		return page;
_

Patches currently in -mm which might be from gxxa03070307@gmail.com are

mm-cma-print-total-and-used-pages-in-cma_alloc.patch

