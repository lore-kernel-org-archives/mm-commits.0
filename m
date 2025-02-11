Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DADE27291F
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739317353; cv=none; b=txihfW3wlEU1W5mW3xHSlC6IcXr4ZP9SBK73IcufEsuOwdK3vaK+N8vvUi/s5A39RNge9Oa/0DJfpG74oGOwQ71kCMcnjADzj/fIVrS4mqP5GGkrFhztDrD9Xh/4THJdNPJf/6PqBSyI9rAlSWnWP0RVbEL0piu0JPbwa3sCmEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739317353; c=relaxed/simple;
	bh=knuIVIP56ps6YWiGGcm1w5hu7oxY7m1vmuHOkn56p74=;
	h=Date:To:From:Subject:Message-Id; b=Vm2dVuxgc2cjFM8R9USJvVqTdxf8z4Ah9nXO50oNDzhGgMrrVMnhVgwAbBrbP+XfIDTPDHtogMBcsCcgVgFB3R1uh14+5iKsmNMXJL9AIC3PRTK0CgEhnFfOXTfm0mT4nZUurRaIBmleeMQ2ctKlglfSuyi+Yr4D+ipV0r6Yx7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jZt0pOIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jZt0pOIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68CAC4CEDD;
	Tue, 11 Feb 2025 23:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739317352;
	bh=knuIVIP56ps6YWiGGcm1w5hu7oxY7m1vmuHOkn56p74=;
	h=Date:To:From:Subject:From;
	b=jZt0pOIcFIQIz1DoYd5GjabpsjopYd6I5oUxXxLvPiZc6/cI/q9++l7T5ZfGGR9If
	 /oHZ8YQzemT76jP0QOcpe9qcIje/D0vkgN+mZjLB6O28/5TKv8vQdKlUfBjG2WR3dB
	 pe3g7S4XbEhgcdQJi+VipWOJS/nDDASnpaGbk0Bc=
Date: Tue, 11 Feb 2025 15:42:32 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory.patch added to mm-unstable branch
Message-Id: <20250211234232.B68CAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: only align start of ZONE_MOVALBE on nodes with memory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: only align start of ZONE_MOVALBE on nodes with memory
Date: Tue, 11 Feb 2025 08:29:00 +0000

At the beginning of find_zone_movable_pfns_for_nodes(), it has properly
set node_states[N_MEMORY] in early_calculate_totalpages().

Instead of iterating over all possible nodes, we can just do the alignment
on nodes with memory.

Link: https://lkml.kernel.org/r/20250211082900.10877-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory
+++ a/mm/mm_init.c
@@ -547,7 +547,7 @@ restart:
 
 out2:
 	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
-	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long start_pfn, end_pfn;
 
 		zone_movable_pfn[nid] =
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-use-round_up-to-align-movable-range.patch
mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory.patch

