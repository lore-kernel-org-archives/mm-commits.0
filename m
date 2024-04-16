Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D173B185
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 22:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307223; cv=none; b=sgHGnLyMr9mIJ8D7VsPQwEgz3dpiZwkIBzk0p9/X4cnsR7fyKw7oXjIjX+T11cjae6NfSbEhgYZagIYW+Rpg5zoRsbuLLvFg/ITP9NIRiJPk+UXVSFuseoR2jJxYEiHDOxhfku+9cYBctBRD19n8QxTqWrHO163fcJcgRPERjRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307223; c=relaxed/simple;
	bh=cMK5ceyykTdudGgudQR4gSmhfkdfypmvO/Av4dnPCik=;
	h=Date:To:From:Subject:Message-Id; b=rqadIGtj4YkkuVE9evfPwsiITFWB49bHWfWf3vFQFIsQYLkMfJx2DxLn5Nx3RSUEEZZVJOI3nvezjoqB4NCx5erlvgovp+5D7Rj9808pFJuPRQpG1MEVT/pdp/hJRds0s8Qb7DfsdNOy7FbTnVtVKnDieTvxLqT1Iy0rEMm0g+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fXINWUIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fXINWUIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA261C3277B;
	Tue, 16 Apr 2024 22:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307223;
	bh=cMK5ceyykTdudGgudQR4gSmhfkdfypmvO/Av4dnPCik=;
	h=Date:To:From:Subject:From;
	b=fXINWUIlmxHR5FbH/FNOHVQkELx31rxhnrTRHBvryVaRGa1RHZlHeZ3HVxUi6TRLe
	 dVG3vTIUj6yJJTOsRitLlQuKK0LRg0AFzYXdDwUAGxvuyipFBXDUfyFcPjGacRLXor
	 X0DRCe56PnH6mrLMHZVes31MH1vOU6n0yyvcx0KA=
Date: Tue, 16 Apr 2024 15:40:22 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,palmer@dabbelt.com,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,alexghiti@rivosinc.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmpage_owner-fix-printing-of-stack-records.patch removed from -mm tree
Message-Id: <20240416224022.EA261C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,page_owner: fix printing of stack records
has been removed from the -mm tree.  Its filename was
     mmpage_owner-fix-printing-of-stack-records.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
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


