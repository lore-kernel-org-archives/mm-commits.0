Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682783B9936
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439041; cv=none; b=MnC+/rdyHKgRhdUqiZWHSVvngLVBO8OoY6EGElULOTc4ov8lnCjHSlxsHqZQmJpxASSH9tu+5/h8Vw4FIwzKCdLLl4OOHQFzrYwyUBax0Rm1Jxjlrb1zF8UCUF5pqRyUGELLCHMS9/sEBtShqokU8zu4n4NjfB1VuUmcu7MxVv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439041; c=relaxed/simple;
	bh=cB5dBgaQ5XZil+7h8ZapKexcB63f5nN+YMLLk3SZ99w=;
	h=Date:To:From:Subject:Message-Id; b=VB1z80inT7MSn0lQUQO5IbVxJ4EWmgZSwD7AZT/gpMx21it76sVPDIi6cdB7JObxwQOllxrzCwrwSyWABVAYKx6bsmgmfwvy30wd0NL4pe5AI/8GKzmBpqqttTA+vD6OGcJADomzv7PoeBpixCfMnq/NNeGBcsVDtcK/esUrL4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L3AaF7O5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L3AaF7O5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE141F00893;
	Tue,  2 Jun 2026 22:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439040;
	bh=4bLvixSEjmAYj7hzsRlSl8jDBQ0OmMVktzVxdTqTfUI=;
	h=Date:To:From:Subject;
	b=L3AaF7O5+ILMP0lv7mpWE0pBdm46EZRhm7rQZ+WDqNWjRFFwJbwZzwfIidNgs5ARg
	 8ymtgJxHhgleSzEmwrpc1cbZ0Pj6IgIO1lznbbG8OKUPJK61Q0vlUXj9Mex3HW8oJl
	 r3mYn0cXBMtWZ7KByWR7V/6BKtztryw8ZA8fXO5g=
Date: Tue, 02 Jun 2026 15:23:59 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sj@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mseal-use-min-max-in-mseal_apply.patch removed from -mm tree
Message-Id: <20260602222400.3FE141F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: use min/max in mseal_apply
has been removed from the -mm tree.  Its filename was
     mm-mseal-use-min-max-in-mseal_apply.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/mseal: use min/max in mseal_apply
Date: Sun, 3 May 2026 13:59:16 +0200

Use the type-checked min()/max() macros instead of MIN()/MAX(), which are
supposed to be used "for obvious constants only".

Link: https://lore.kernel.org/20260503115915.18680-3-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mseal.c~mm-mseal-use-min-max-in-mseal_apply
+++ a/mm/mseal.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/mempolicy.h>
+#include <linux/minmax.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
@@ -65,8 +66,8 @@ static int mseal_apply(struct mm_struct
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
-		const unsigned long curr_start = MAX(vma->vm_start, start);
-		const unsigned long curr_end = MIN(vma->vm_end, end);
+		const unsigned long curr_start = max(vma->vm_start, start);
+		const unsigned long curr_end = min(vma->vm_end, end);
 
 		if (!vma_test(vma, VMA_SEALED_BIT)) {
 			vma_flags_t vma_flags = vma->flags;
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


