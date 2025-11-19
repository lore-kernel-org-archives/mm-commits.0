Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2027C20C48A
	for <mm-commits@vger.kernel.org>; Wed, 19 Nov 2025 22:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763591086; cv=none; b=n2J0BO77oEZIjFANIXQgSyRjld/Y1jNAp4FDO466eUKBJPwZKRgnlQkAlk7/4shyBMwe591LwjblnlufvjCDCPwTVsBD6AGm/3QRzyuWa6scgH8rLHGZbDKCBVQwy2n8D3G+CcfpQmuYgliGzmDSSa62G4LkhCsZnbkUX8hzEfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763591086; c=relaxed/simple;
	bh=V0Zi8+wne3mXoEYWqv7RkdQjXZdyhlGeQAPfK8z9b5M=;
	h=Date:To:From:Subject:Message-Id; b=TjXnOfY7tQaBUKGfnmT81oNo03HoWs5eARgKZqcJm0bltvJNLsXdRP2p/Q/jUozlTGkSDKywuZ8lhyXHzV1YQYfagV0D6KHXHWuVPQiiP2scv2q5PiwhWK7syEnY232XMxtVk7+INlnN6tSrbmhXD8TV7XKSuJWK++Ia4U+kjTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FEiMw28F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FEiMw28F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAC0C4CEF5;
	Wed, 19 Nov 2025 22:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763591085;
	bh=V0Zi8+wne3mXoEYWqv7RkdQjXZdyhlGeQAPfK8z9b5M=;
	h=Date:To:From:Subject:From;
	b=FEiMw28Ff1AzgXwSuRw3op8AZmevxSVYOwVkAjpGZP4A0TMi48Vx2dcJfkH83Ad0q
	 xkLlGedOBJwpQagqKuUXxz5BteIMTsljnIezEITaYkmFq98bJwUSm05qkLvtsMVOWq
	 eOsmL4DIrS8KaE5UWUNAJfZfwo7oL3+yxx2uR/sk=
Date: Wed, 19 Nov 2025 14:24:45 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-propagate-vm_softdirty-on-merge-fix.patch added to mm-unstable branch
Message-Id: <20251119222445.BEAC0C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-propagate-vm_softdirty-on-merge-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-propagate-vm_softdirty-on-merge-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-propagate-vm_softdirty-on-merge-fix.patch

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
Subject: mm-propagate-vm_softdirty-on-merge-fix
Date: Wed Nov 19 02:22:57 PM PST 2025

update comments, per Lorenzo

Link: https://lkml.kernel.org/r/0019e0b8-ee1e-4359-b5ee-94225cbe5588@lucifer.local
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    8 +++-----
 tools/testing/vma/vma_internal.h |    8 +++-----
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~mm-propagate-vm_softdirty-on-merge-fix
+++ a/include/linux/mm.h
@@ -548,11 +548,9 @@ extern unsigned int kobjsize(const void
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_STICKY - If one VMA has flags which must be 'sticky', that is ones
- *             which should propagate to all VMAs, but the other does not,
- *             the merge should still proceed with the merge logic applying
- *             sticky flags to the final VMA.
- */
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
 #define VM_IGNORE_MERGE VM_STICKY
 
 /*
--- a/tools/testing/vma/vma_internal.h~mm-propagate-vm_softdirty-on-merge-fix
+++ a/tools/testing/vma/vma_internal.h
@@ -133,11 +133,9 @@ extern unsigned long dac_mmap_min_addr;
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *             which should propagate to all VMAs, but the other does not,
- *             the merge should still proceed with the merge logic applying
- *             sticky flags to the final VMA.
- */
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
 #define VM_IGNORE_MERGE VM_STICKY
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-propagate-vm_softdirty-on-merge-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch
uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch

