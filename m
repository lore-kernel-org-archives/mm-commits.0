Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6054E4B44C9;
	Sat, 10 Oct 2026 19:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791659554; cv=none; b=CTm7GU3FXcHFehVMQAia9fVGIPdchHezFP6YCK4QpXulWn2kaVLEv0tJrCxPjZaXPwzyt0U85kEilK2l0SHkjhF1IAvULecPilAXKpzzJlTeZoRgBpWrnijTKLm6GvcWGFfH1yBNWY3UzZHxRlLJIcrJtzOdbJYi8EmCsvMjIc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791659554; c=relaxed/simple;
	bh=78dHOfMq4K9POqnbC/BfnlRtEkJ9PIZN30DEwbh/TCY=;
	h=Date:To:From:Subject:Message-Id; b=fgISpAOGAfu1SDvN2NzVRGkYgRnyf9ePKlVtKT9bsMWaDLC0KdAo0x9uZJhlNg8aNmzUAKACx8rHxz7KXM/baIpzXPxgDwArxnEKuBR4Gd+WXSW6X2XquZOMYcIndqJ6dyUCDXnnPqewjnxZVuHEVbQ3O0mYd25H+o3Cu1WxPSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KEp5/R3f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KEp5/R3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C561F000FF;
	Sat, 10 Oct 2026 19:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791659550;
	bh=pMqkU+z0PuowkqJWtUMR1OOKeoSiVWqfOGDCi6B9ebc=;
	h=Date:To:From:Subject;
	b=KEp5/R3fNTY2B+roRzA0kQjzN2wMNTUabSpvMwmFkLSIOvV0UzngObu3iwU/D9ekq
	 fQRI32Q5Q9YspTOCUd4tps1rj4auu5JDm/UF15tS94zqUPgOIVbUT951rZCUapZLu5
	 O26Jn0AZGFDixZO7Xmjx46o1SqQZGTAOS9qAg8aI=
Date: Sat, 10 Oct 2026 12:12:29 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,pjw@kernel.org,palmer@dabbelt.com,osalvador@suse.de,mark.rutland@arm.com,kevin.brodsky@arm.com,david@kernel.org,dave.hansen@intel.com,catalin.marinas@arm.com,bjorn@rivosinc.com,apopple@nvidia.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch added to mm-unstable branch
Message-Id: <20261010191229.E6C561F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv/mm: fix missing destructor for hotplug PUD tables
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: riscv/mm: fix missing destructor for hotplug PUD tables
Date: Sat, 10 Oct 2026 19:24:56 +0800

Commit 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel
pgtable alloc") made alloc_pud_late() run the PUD page-table constructor.
However, free_pud_table() still frees non-reserved PUD tables directly
without decrementing NR_PAGETABLE.

Free PUD tables through the common free_pgtable_page() helper so that
constructor-backed tables run the matching destructor before being
freed.

Link: https://lore.kernel.org/20261010112457.49485-4-songmuchun@bytedance.com
Fixes: 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel pgtable alloc")
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 arch/riscv/mm/init.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/riscv/mm/init.c~riscv-mm-fix-missing-destructor-for-hotplug-pud-tables
+++ a/arch/riscv/mm/init.c
@@ -1538,10 +1538,7 @@ static void __meminit free_pud_table(pud
 			return;
 	}
 
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		__free_pages(page, 0);
+	free_pgtable_page(page);
 	p4d_clear(p4d);
 }
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

