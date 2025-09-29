Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13081B87C0
	for <mm-commits@vger.kernel.org>; Mon, 29 Sep 2025 21:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759182520; cv=none; b=Lje8jgpL5WgTQqGbpjNtdkzAZwx0yofKstmk3mp+ki7AP76C2dutuCSHA4HHouJ8WwYYz7oUebMewWds2xXQ83GJ9cuFhSP+t4Pl35jjf1v3Dp7yKZD3HB+sEgxTfetFUAlrJsd2WCMwGkClRPx5ttB9FKl34DrVmhDrcrGjSf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759182520; c=relaxed/simple;
	bh=Ao7VmFYZcrgTyilyz9aUslIzzcVVe5uqe11kd+5dRyQ=;
	h=Date:To:From:Subject:Message-Id; b=oaYi04xJewZGvWBaGwxmzpYHz2bwyDK9m5vuofPbKAfHl7WwAZRGLKp1OTyQDM28FkKxUYcnWTL/r+lAwN/xoRRdYGRCTwX9qEnkt//dopp0rG796nA3lSwlN3FFlHe8ozMZFfQyvZxy2xtlh5g8iWi0dqz0iElP3zsf9yP4hGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qXPvcHcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qXPvcHcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214ABC4CEF4;
	Mon, 29 Sep 2025 21:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759182520;
	bh=Ao7VmFYZcrgTyilyz9aUslIzzcVVe5uqe11kd+5dRyQ=;
	h=Date:To:From:Subject:From;
	b=qXPvcHcYNryyNyrPzhCCbftNsGiSbEaGfvmfc9vmZBjXj9piZipWmX2j7xCXqiNuL
	 Iz8Vyr5AVGLfCHZQr4WaxtU9wb50F8qvkvHms9nLcpA9/O+4TPw7RK0qMOH3gJS9Kk
	 pY0ny5Q06Y2UpdG96qvGChJqPTunW3fXj1ErSwEc=
Date: Mon, 29 Sep 2025 14:48:39 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,dev.jain@arm.com,david@redhat.com,apopple@nvidia.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-drop-pxx_mkdevmap-descriptions-from-page-table-helpers.patch added to mm-new branch
Message-Id: <20250929214840.214ABC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/mm: Drop pxx_mkdevmap() descriptions from page table helpers
has been added to the -mm mm-new branch.  Its filename is
     documentation-mm-drop-pxx_mkdevmap-descriptions-from-page-table-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-drop-pxx_mkdevmap-descriptions-from-page-table-helpers.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Documentation/mm: Drop pxx_mkdevmap() descriptions from page table helpers
Date: Mon, 29 Sep 2025 13:00:45 +0100

Remove pxx_mkdevmap() descriptions, as these helper functions have already
been dropped (including DEBUG_VM_PGTABLE test) via the commit d438d2734170
("mm: remove devmap related functions and page table bits").

Link: https://lkml.kernel.org/r/20250929120045.1109707-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/arch_pgtable_helpers.rst |    6 ------
 1 file changed, 6 deletions(-)

--- a/Documentation/mm/arch_pgtable_helpers.rst~documentation-mm-drop-pxx_mkdevmap-descriptions-from-page-table-helpers
+++ a/Documentation/mm/arch_pgtable_helpers.rst
@@ -52,8 +52,6 @@ PTE Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pte_mkspecial             | Creates a special PTE                            |
 +---------------------------+--------------------------------------------------+
-| pte_mkdevmap              | Creates a ZONE_DEVICE mapped PTE                 |
-+---------------------------+--------------------------------------------------+
 | pte_mksoft_dirty          | Creates a soft dirty PTE                         |
 +---------------------------+--------------------------------------------------+
 | pte_clear_soft_dirty      | Clears a soft dirty PTE                          |
@@ -124,8 +122,6 @@ PMD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pmd_mkspecial             | Creates a special PMD                            |
 +---------------------------+--------------------------------------------------+
-| pmd_mkdevmap              | Creates a ZONE_DEVICE mapped PMD                 |
-+---------------------------+--------------------------------------------------+
 | pmd_mksoft_dirty          | Creates a soft dirty PMD                         |
 +---------------------------+--------------------------------------------------+
 | pmd_clear_soft_dirty      | Clears a soft dirty PMD                          |
@@ -185,8 +181,6 @@ PUD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pud_wrprotect             | Creates a write protected PUD                    |
 +---------------------------+--------------------------------------------------+
-| pud_mkdevmap              | Creates a ZONE_DEVICE mapped PUD                 |
-+---------------------------+--------------------------------------------------+
 | pud_mkinvalid             | Invalidates a present PUD; do not call for       |
 |                           | non-present PUD [1]                              |
 +---------------------------+--------------------------------------------------+
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

documentation-mm-drop-pxx_mkdevmap-descriptions-from-page-table-helpers.patch

