Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5326513AA59
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 21:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712265206; cv=none; b=OITbj5zGrYJSOdg4mrDoIYy4QPx/Z/Kdc2bOCZSVUU/sjbpyBR0/nnNW2xjeQzKVdoaEsq4rn+cA3PAoWKYBtNI2JhuIFYdllMH46naXczgEzTzK3VNCP8mP8dPi25R12nDchFuGG8rTLqA3RHKBZhUnmjXVZROLpgAgLNNIWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712265206; c=relaxed/simple;
	bh=rrLBKoyrbALbB7dfZZu/G143wGkszDYZ7t2AJkSBf7E=;
	h=Date:To:From:Subject:Message-Id; b=iztOKBUFfHUDPa/+BcWzCQ5EoQ1Jm3pIwRb5oC5KARm3Y2qMJcEWLdjRAiMEvT2jsDd3JYjeB9GgXLm3AmvJdCToTNjchzfrLySgxxts0UhIWqoVg8RRkNuVRGNqkhykk1LOI/bQZ1HwMQiQBD35wf+fV1qK5/tUwONA05j98rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i0/3vKIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i0/3vKIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDCEC43390;
	Thu,  4 Apr 2024 21:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712265206;
	bh=rrLBKoyrbALbB7dfZZu/G143wGkszDYZ7t2AJkSBf7E=;
	h=Date:To:From:Subject:From;
	b=i0/3vKIG/EgXFkjP8df1B8u8rP2MTBTqi+rumx1l/ocltauEmokttFWi4LN+ZYO/o
	 l+H0lPTVKTXlSZMnDoz9uziEXRynAKDacgULWQ0jga43l+CxilhDQ1VaBLraOF3NZ4
	 nMNarSTkWZtOXyVxfxtE6cTgAxhIpUBzo4zsEWPo=
Date: Thu, 04 Apr 2024 14:13:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,alexghiti@rivosinc.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-fix-printing-of-stack-records.patch added to mm-hotfixes-unstable branch
Message-Id: <20240404211326.0EDCEC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: fix printing of stack records
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmpage_owner-fix-printing-of-stack-records.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-fix-printing-of-stack-records.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: fix printing of stack records
Date: Thu, 4 Apr 2024 09:07:02 +0200

When seq_* code sees that its buffer overflowed, it re-allocates a bigger
onecand calls seq_operations->start() callback again.  stack_start()
naively though that if it got called again, it meant that the old record
got already printed so it returned the next object, but that is not true.

The consequence of that is that every time stack_stop() -> stack_start()
get called because we needed a bigger buffer, stack_start() will skip
entries, and those will not be printed.

Fix it by not advancing to the next object in stack_start().

Link: https://lkml.kernel.org/r/20240404070702.2744-5-osalvador@suse.de
Fixes: 765973a09803 ("mm,page_owner: display all stacks and their count")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_owner.c~mmpage_owner-fix-printing-of-stack-records
+++ a/mm/page_owner.c
@@ -872,13 +872,11 @@ static void *stack_start(struct seq_file
 		 * value of stack_list.
 		 */
 		stack = smp_load_acquire(&stack_list);
+		m->private = stack;
 	} else {
 		stack = m->private;
-		stack = stack->next;
 	}
 
-	m->private = stack;
-
 	return stack;
 }
 
_

Patches currently in -mm which might be from osalvador@suse.de are

mmpage_owner-update-metadata-for-tail-pages.patch
mmpage_owner-fix-refcount-imbalance.patch
mmpage_owner-fix-accounting-of-pages-when-migrating.patch
mmpage_owner-fix-printing-of-stack-records.patch

