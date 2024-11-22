Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10464166315
	for <mm-commits@vger.kernel.org>; Fri, 22 Nov 2024 06:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732256415; cv=none; b=eeMxga/iVezbym3E0LLnwwh39kJJFDjO2ZZeznexevdImkbiVAeu5WRgqjfsYjnf6acVtdPAocYtvd5kQRjAFMyWBu/BoywgUn6cK++RL200CULSR1RWv94INfRTwpfk/QvZgqFM+t8HFIGNOoJ6NeVpS8aEY+rn+i4nJF8wExI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732256415; c=relaxed/simple;
	bh=kfkBDDrqmO1IADp8ftR6gZQtqML5iZGMiCuVYa/Y4PY=;
	h=Date:To:From:Subject:Message-Id; b=XeI6iuKPvspxIUEKwk9QPlpGbBEkBoQLmrM1Ga78Fjslol0cmJCuUATLzU6N57AkRayOy8GX3A3KZndW4BO3nNGyBnHtcJYlZNV8Cme54VEAstW2tSRDrRGi8UCZ2oZv1+W9NeNUXsTp4Bc62Ai9uJFKUxttVrsmnqTrTyE1fZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IRyVDUrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IRyVDUrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5B6C4CECE;
	Fri, 22 Nov 2024 06:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732256414;
	bh=kfkBDDrqmO1IADp8ftR6gZQtqML5iZGMiCuVYa/Y4PY=;
	h=Date:To:From:Subject:From;
	b=IRyVDUrvrg47SYZ2KMRLyNTFz4DiGXuoKIaj4dKeF0LYNklrm3LDxW5FhVGkmtR7w
	 HRT913DFRIRqLtyHRwDcY0yCSEYIhUChJJL0xrFqtVogLUqsfZD9fFGELEba+/rjAj
	 R43SrAIxUN+yA6FLG3s/n09FXKtzoYh4ZW1lKflM=
Date: Thu, 21 Nov 2024 22:20:10 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,david@redhat.com,cl@linux.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241122062013.AD5B6C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix
Date: Thu Nov 21 10:18:19 PM PST 2024

add unlikely()

Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix
+++ a/mm/mempolicy.c
@@ -1080,7 +1080,7 @@ static long migrate_to_node(struct mm_st
 
 	mmap_read_lock(mm);
 	vma = find_vma(mm, 0);
-	if (!vma) {
+	if (unlikely(!vma)) {
 		mmap_read_unlock(mm);
 		return 0;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch
mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch

