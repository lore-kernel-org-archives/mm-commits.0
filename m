Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCB433F9
	for <mm-commits@vger.kernel.org>; Fri, 30 May 2025 03:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748576881; cv=none; b=gS3rcakzDvwTqu7dHN7HzQG2FrD42YpnpcEBvDwnjwsdB84tENKlrykUZAwnt75u741UPvkaPR9dPcBXQ08LDO6JbnYU6N8oIr3SFkLhV1rZn4Stjvic121SwNgAfMyaEl5Z/eor+X3DIYOFbQoxQFMlXqKJZpcV0k1SjxtgEzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748576881; c=relaxed/simple;
	bh=S4rJgBfOetFV7lwDGMqJpRcqQoX74Pl/lltAWC0R7kc=;
	h=Date:To:From:Subject:Message-Id; b=LHuNnhgsC/wBtT16RzSlqpvXXhubnKauCPOpn+Ocjaw/vkd9g157Bd8Jz/3AvteEUyHIgDiHkD0AVpXGd81pHEPBBxekVMe588xvGmmM2MC+w2/Gk50djRQmE4HIWQRT2F3AfUa8PWe0DdKQ2m8yQDNUBKxrljtXOxQWoAvesb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BlMxMxMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BlMxMxMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E615EC4CEEF;
	Fri, 30 May 2025 03:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748576881;
	bh=S4rJgBfOetFV7lwDGMqJpRcqQoX74Pl/lltAWC0R7kc=;
	h=Date:To:From:Subject:From;
	b=BlMxMxMYFV+FlczW2y07KDgchEp88NyoMMQEvSDbzVpkDA1TJIJ2qjl8NcXOy9k/K
	 HBX4Z//5TRYT4AQAYtozjDSitGVzjcFIgzJtPyL5Dc5QtKa+HNxnPYVy0mtOC16Sjr
	 LIxKWnDqOjJd6pFkUoP4uR4LOLpfd35er3Wc14FY=
Date: Thu, 29 May 2025 20:48:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pulehui@huawei.com,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-expose-abnormal-new_pte-during-move_ptes-fix.patch added to mm-unstable branch
Message-Id: <20250530034800.E615EC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-expose-abnormal-new_pte-during-move_ptes-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-expose-abnormal-new_pte-during-move_ptes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-expose-abnormal-new_pte-during-move_ptes-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-expose-abnormal-new_pte-during-move_ptes-fix
Date: Thu May 29 08:46:26 PM PDT 2025

s/WARN_ON_ONCE/VM_WARN_ON_ONCE/

Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pu Lehui <pulehui@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-expose-abnormal-new_pte-during-move_ptes-fix
+++ a/mm/mremap.c
@@ -237,7 +237,7 @@ static int move_ptes(struct pagetable_mo
 
 	for (; old_addr < old_end; old_pte++, old_addr += PAGE_SIZE,
 				   new_pte++, new_addr += PAGE_SIZE) {
-		WARN_ON_ONCE(!pte_none(*new_pte));
+		VM_WARN_ON_ONCE(!pte_none(*new_pte));
 
 		if (pte_none(ptep_get(old_pte)))
 			continue;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-expose-abnormal-new_pte-during-move_ptes-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

