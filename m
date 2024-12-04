Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D2123919F
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733350447; cv=none; b=FGB5tWUZo1i0gmHaY0YciQvGAA03QdrhooNHtY12n2TRCJ1olsYtP76GxELw2IlcjKvAwtiUUK2pyZZUa4zMoBIw+5d3ygeH7ppXDLkoBcZbgFE6g+qDhBlH5J7tOr/8kUqyseYuyE7MbQHKvnEY1LNh/47WaWyRhhCDaf4etpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733350447; c=relaxed/simple;
	bh=pS/XNG174sdnAwDAauZbdWCSMu5nH0QpDKDxVmY+Axk=;
	h=Date:To:From:Subject:Message-Id; b=Kmnns66caHpNl54JGXYAjQ5NZEDYWhjhrkR8v70tHAKm4z2QpjUTne+WsTRal55+f8rI/rUAFciMuso0hRFiwk08C0ruipNKD41HuqHhdD3cX/kZsn5rgL6MjadRGcPdKroPmvN7mnOPcsFtEx8/gR63Wg29i97wEdgasuuhoLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PbIsR+Gq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PbIsR+Gq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252D7C4CECD;
	Wed,  4 Dec 2024 22:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733350446;
	bh=pS/XNG174sdnAwDAauZbdWCSMu5nH0QpDKDxVmY+Axk=;
	h=Date:To:From:Subject:From;
	b=PbIsR+GqZ5lGzCkDuvAU1ejpiqfHl4ELvfHmYvq1SEDR2bdQMYGiI4gQD0n5edQph
	 NjV1KjEA2SzELhpRqyIFvbhVGED0u87OvnQiDp3FDkULMzNTDSzoQWfzxTK/1ejSlU
	 gB7eni2Bfo7UodQyZDLmGAWInoSP3T1PN7C85BzA=
Date: Wed, 04 Dec 2024 14:14:05 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-move-brk-internals-to-mm-vmac-fix.patch added to mm-unstable branch
Message-Id: <20241204221406.252D7C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: add missing personality header import
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-move-brk-internals-to-mm-vmac-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-move-brk-internals-to-mm-vmac-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: add missing personality header import
Date: Wed, 4 Dec 2024 12:00:35 +0000

Some architectures have different header dependency chains, we incorrectly
failed to important linux/personality.h which broke MIPS. Fix this.

Link: https://lkml.kernel.org/r/2a717265-985f-45eb-9257-8b2857088ed4@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma_internal.h |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vma_internal.h~mm-vma-move-brk-internals-to-mm-vmac-fix
+++ a/mm/vma_internal.h
@@ -35,6 +35,7 @@
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/perf_event.h>
+#include <linux/personality.h>
 #include <linux/pfn.h>
 #include <linux/rcupdate.h>
 #include <linux/rmap.h>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correct-typo-in-mmap_state-macro.patch
docs-mm-add-vma-locks-documentation.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch

