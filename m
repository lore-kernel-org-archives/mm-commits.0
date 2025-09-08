Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EBF4A06
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 22:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757371383; cv=none; b=cxhTcarSV7OnoU2zV2MRPEY4UM55X401U93bIJ0EQDW6BUSHdE3WsCHD54MB1axo4IOxayaB8iMs72IO+vHHRQPiSVWeU+T6h+OfYqtYWooaPdkx2EGGNv4RbZ0scwpiu2QTyoWQsyE1N6Tfj+40ToAo9+TAEiS+bMH77HJjGDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757371383; c=relaxed/simple;
	bh=rDMr5ys2nhTS8L2lMBhVSj0eKN/fEg4/AEN6xy4S0Xk=;
	h=Date:To:From:Subject:Message-Id; b=Z2pSOW2s0vbxRGjmHJ0+G/EyFrVpH8rztjzVGlqyTHiZZGjOofPGRMbAuE+9lqMIAwsMiI4ShWYh0key/re6XxS0eGbuvUOyFlfH2eJmdwJ7zKBYOlt7AxG0KjBuFttFSmaRG8pvcRVVgyDHEi400cF1EiDufUCD5jRYmgjMz+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r9nQr55V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r9nQr55V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE9DC4CEF1;
	Mon,  8 Sep 2025 22:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757371382;
	bh=rDMr5ys2nhTS8L2lMBhVSj0eKN/fEg4/AEN6xy4S0Xk=;
	h=Date:To:From:Subject:From;
	b=r9nQr55VDcvcyLSW/tw9esVam0IuVpE6W50l0LumO55fzZaeCmjEqgkCUnQtAfr3q
	 dKefy54pWTxziRF5227qxj/+vnnJKtgpCRN1i4HFKEuLPSQBlKY0oMMABMdnv/GEfS
	 UUMiAA1qd4mYskLinQrVUGi3XA35fLbMnQAklMTw=
Date: Mon, 08 Sep 2025 15:43:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-jann-horn-as-rmap-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20250908224302.4BE9DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Jann Horn as rmap reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-jann-horn-as-rmap-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-jann-horn-as-rmap-reviewer.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add Jann Horn as rmap reviewer
Date: Mon, 8 Sep 2025 20:49:59 +0100

Jann has been an excellent contributor in all areas of memory management,
and has demonstrated great expertise in the reverse mapping.

It's therefore appropriate for him to become a reviewer.

Link: https://lkml.kernel.org/r/20250908194959.820913-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-jann-horn-as-rmap-reviewer
+++ a/MAINTAINERS
@@ -16195,6 +16195,7 @@ R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
 R:	Harry Yoo <harry.yoo@oracle.com>
+R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-jann-horn-as-rmap-reviewer.patch
mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch
mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch

