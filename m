Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23F5158218
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745184302; cv=none; b=b7CoSafNqMbof9m6IzGMaCTHsVulfhcJnW7swjFEQ29feTrKXaP7yP0ATWwb/Wi6HB8ZtMxK5YvaHtd96GJ7p8jpZKmvkYAhQ3RjQx1Z5m0AHSt+818WP84M52SSr8TYKOMD/GJVKzXhM1t+Y1PJhv0gSGiGQdmVwkZ1yLTPg4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745184302; c=relaxed/simple;
	bh=/g3A7QzBXGHkuXxKNE8hKsQoGkVVEnxVljCAyTXBXok=;
	h=Date:To:From:Subject:Message-Id; b=Su5cH0Z4dCPiQMFxCYClN5/WX9XbjYv/U8Ulqokh7sxa4rWpAYlxVTuObDKBreFFEy7zGz2+zdNnkFlqIyeq/irFA4yk6ysV4mMkCgcsak+a7jkiJ9sNuKkhyTuEryLKktehlAcEY2cbxDzs63LcO0NfkvLPF9W8CEkklYCIVKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cn8mnr99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cn8mnr99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A165FC4CEE2;
	Sun, 20 Apr 2025 21:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745184301;
	bh=/g3A7QzBXGHkuXxKNE8hKsQoGkVVEnxVljCAyTXBXok=;
	h=Date:To:From:Subject:From;
	b=cn8mnr99vqc3ZrIlxb8U6FBDJdOaVzpIZgFxmLXlDNwJZEweZogrjmhS4AaV8vW5q
	 83vOCWuJsufiAdjSKa7E+QEBp+38qbOiWHAPnnDAWFRnDPiacdO1jbVXbC4c7C8x1P
	 V0C7Y3+3bpJWz8rgBa0jIkW9I8pTgoVXl9cqOp4s=
Date: Sun, 20 Apr 2025 14:25:01 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shivankg@amd.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-optimize-function-vm_unmap_aliases.patch added to mm-new branch
Message-Id: <20250420212501.A165FC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: optimize function vm_unmap_aliases()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-optimize-function-vm_unmap_aliases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-optimize-function-vm_unmap_aliases.patch

This patch will later appear in the mm-new branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: optimize function vm_unmap_aliases()
Date: Sat, 19 Apr 2025 06:36:52 +0800

Remove unneeded local variables and replace them with values.

Link: https://lkml.kernel.org/r/20250418223653.243436-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-optimize-function-vm_unmap_aliases
+++ a/mm/vmalloc.c
@@ -2929,10 +2929,7 @@ static void _vm_unmap_aliases(unsigned l
  */
 void vm_unmap_aliases(void)
 {
-	unsigned long start = ULONG_MAX, end = 0;
-	int flush = 0;
-
-	_vm_unmap_aliases(start, end, flush);
+	_vm_unmap_aliases(ULONG_MAX, 0, 0);
 }
 EXPORT_SYMBOL_GPL(vm_unmap_aliases);
 
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5.patch
mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch
mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch
mm-vmallocc-optimize-code-in-decay_va_pool_node-a-little-bit.patch
mm-vmalloc-optimize-function-vm_unmap_aliases.patch
mm-vmallocc-return-explicit-error-value-in-alloc_vmap_area.patch

