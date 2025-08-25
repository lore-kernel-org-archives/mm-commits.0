Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B88F4A33
	for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2025 23:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756163130; cv=none; b=BT9WRx1wQCUz5XAXWrGDFkjo1gWE+xMHZvNfV7xZGHljwN2yHD+Oxab2/HweKYazgR5oShI0wHCbud7NDEg/ZqmB5CznsOjRwVR+iuB/rrCz+JbeVCB5rG9pUPBMDpGpU36GPPrlVZQ8SwwX2cFfDJzsA1KL99HKGan00pSwqtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756163130; c=relaxed/simple;
	bh=rlw48WdBerF9/eHUPWOoTL3pWS5CgSvHEHcTm0Vpb0M=;
	h=Date:To:From:Subject:Message-Id; b=LJ9ALx89CZj2IhQADBlKqXYMnc6d2bEbTizjjYnFkwgiUh4d9+qddsH6CioS0byqU7LNnF2BpJScKndIXdq6kPDSKk5NalGqYW9ytNK/ti6v7G1pQ0h3Vf5NjRIpx5+1MuYoWd1aJ5CLXmm7F+bTrUGPO/PdPwUTMdpsBU/vUZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xLVLk9lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xLVLk9lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CFCC4CEED;
	Mon, 25 Aug 2025 23:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756163129;
	bh=rlw48WdBerF9/eHUPWOoTL3pWS5CgSvHEHcTm0Vpb0M=;
	h=Date:To:From:Subject:From;
	b=xLVLk9ltaFJ5OfW81u59v6ZlKw6pqhp2dRElqV+4FYbp6TWBYOpHw22ooidQK024w
	 AjsFpJi8DbN51EAjCMYkhOOV8+Y2abNiaejJcjLmnrJflQ4xH4iHQ77Gt02HQrwoV/
	 yCNVdyMKrZqxTJoMr9VM/JBZEcOGVR8EtLhTi2pg=
Date: Mon, 25 Aug 2025 16:05:29 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.patch added to mm-unstable branch
Message-Id: <20250825230529.98CFCC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.
Date: Mon, 25 Aug 2025 14:25:59 +0200

Let's just drop the warning, it's highly unlikely that we ever run into
this, and if so, there is serious stuff going wrong elsewhere.

Link: https://lkml.kernel.org/r/923b279c-de33-44dd-a923-2959afad8626@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/pgtable.h~mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix
+++ a/include/linux/pgtable.h
@@ -1997,7 +1997,6 @@ static inline const char *pgtable_level_
 	case PGTABLE_LEVEL_PGD:
 		return "pgd";
 	default:
-		VM_WARN_ON_ONCE(1);
 		return "unknown";
 	}
 }
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
mm-migrate-remove-migratepage_unmap-fix.patch
treewide-remove-migratepage_success.patch
mm-huge_memory-move-more-common-code-into-insert_pmd.patch
mm-huge_memory-move-more-common-code-into-insert_pud.patch
mm-huge_memory-support-huge-zero-folio-in-vmf_insert_folio_pmd.patch
fs-dax-use-vmf_insert_folio_pmd-to-insert-the-huge-zero-folio.patch
mm-huge_memory-mark-pmd-mappings-of-the-huge-zero-folio-special.patch
powerpc-ptdump-rename-struct-pgtable_level-to-struct-ptdump_pglevel.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map.patch
mm-memory-convert-print_bad_pte-to-print_bad_page_map-fix.patch
mm-memory-factor-out-common-code-from-vm_normal_page_.patch
mm-introduce-and-use-vm_normal_page_pud.patch
mm-rename-vm_ops-find_special_page-to-vm_ops-find_normal_page.patch
prctl-extend-pr_set_thp_disable-to-optionally-exclude-vm_hugepage.patch
mm-huge_memory-convert-tva_flags-to-enum-tva_type.patch
mm-huge_memory-respect-madv_collapse-with-pr_thp_disable_except_advised.patch

