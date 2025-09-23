Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481EF1C6B4
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597346; cv=none; b=YbhIZJ4RPAsWKbVS245Q8b1qpy3mnjinZCYWWkpanTDiBBS9SeUQCfERYNb7EC9rN5GlOe5HHgL3I8Ap3p3gje575H9FiCeH+SpRCDUOmnDTrKmicoqMfX67gGf64ZFs0XT/C1RLLqzld9KSL8aSzLyu1W7Q6Et6Pde2t4gPHqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597346; c=relaxed/simple;
	bh=oOEwO49sd1oRbrrh4XYUhwfwpqrRqv2KNkmPR125uJk=;
	h=Date:To:From:Subject:Message-Id; b=PYVu3q2pBVYbyR5GP6cvdLV7lDM2SLXUFOI7BjUP8yq+X0JoYDjvjlV88DwjvLHVLzeDku6v5cycdCBATQFtMCXs2Y73EDZymSl+vZOfWXSWMUl0mLieodfkF+jUkTHBYLCCmQJM7Mno7f5HU71BYfO07elyiWS2LtRwtfTIcj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zOFC5W/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zOFC5W/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2563C4CEF0;
	Tue, 23 Sep 2025 03:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597345;
	bh=oOEwO49sd1oRbrrh4XYUhwfwpqrRqv2KNkmPR125uJk=;
	h=Date:To:From:Subject:From;
	b=zOFC5W/uqSgYAItmeiU2KP3F4mWFXfRslSv3iuziD0y5i+r9gDdkwTcbHZe0lGn9X
	 zKKuTQHQdGQPge/v2U9dEIYdOTgoD707tdDfm0+M0IEqV26fK2lZXQEBXzxNa5tktu
	 kNEHK8LPglpKrBy+upBxYEMvrHis/iTyTZZuIewg=
Date: Mon, 22 Sep 2025 20:15:45 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,mhocko@kernel.org,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch removed from -mm tree
Message-Id: <20250923031545.B2563C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch

This patch was dropped because it was folded into mm-vmalloc-move-resched-point-into-alloc_vmap_area.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix
Date: Wed Sep 17 01:45:36 PM PDT 2025

tweak comment grammar

Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix
+++ a/mm/vmalloc.c
@@ -2059,9 +2059,8 @@ retry:
 		spin_unlock(&free_vmap_area_lock);
 
 		/*
-		 * This is not a fast path. Check if yielding is
-		 * needed. This is the only one reschedule point
-		 * in vmalloc() path.
+		 * This is not a fast path.  Check if yielding is needed. This
+		 * is the only reschedule point in the vmalloc() path.
 		 */
 		cond_resched();
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch

