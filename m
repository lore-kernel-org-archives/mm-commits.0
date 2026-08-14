Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D449B49252E
	for <mm-commits@vger.kernel.org>; Fri, 14 Aug 2026 18:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786732193; cv=none; b=lIpye1gX2MCAxFOqOpMF943oXMkbsl/JLogGZGHdxJPd6vNwq/N/TYN7nZXq4EDI99oHAoosivr/Mp59SCwWxYLJL8iMNGDwT58D081tCnBLqOOW5gNIVySfDtvFZ7UWqs9881HpvJuqlo1AJ+qWn4Ey2UTasm/JLmMvgVzwBTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786732193; c=relaxed/simple;
	bh=y/QeILA/xcNeMPEjdFKtKW3Wgyvyi8zNu7F7s1B2JRg=;
	h=Date:To:From:Subject:Message-Id; b=tPi9dIqrt/X1TdZlO831PnDsD4yFxXwEhYyWfP7wv2WRuOY0dWfYgjGXc10JmKn6M10BAHtq9SXTzVvrVpRb7moi2fddb8YHjgVRm1KO/goCK6DmrUvlNdazEpt8cxeBRwneyLO8rnNCw7y/FjGHl0Kj6x6MFi8Via0H04q2uGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L1VVpLC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L1VVpLC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723B41F000E9;
	Fri, 14 Aug 2026 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786732191;
	bh=jzO3DXFEh/6o/Z+hNeunJzrzxTkvBhunXEuvQ12kA60=;
	h=Date:To:From:Subject;
	b=L1VVpLC361iVY0qiE8Q+OX0H77zKC9MBSasJlsaweIfpPb/olLz4ur04pU+aTCXC/
	 eZmxnIeLRTnxRsBlPDx8RCa7Thck5DBU+jp54bLPldVdnuouI9+2GLf97fpw8fssSq
	 oq+3SEb6cTGqDjp+ZKZJ8qiJv1yalOFXtFhfg2io=
Date: Fri, 14 Aug 2026 11:29:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,riel@surriel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,seohyun.kim@outlook.kr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-synchronize-lock-and-unlock-target-in-anon_vma_clone.patch added to mm-unstable branch
Message-Id: <20260814182951.723B41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: synchronize lock and unlock target in anon_vma_clone
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-synchronize-lock-and-unlock-target-in-anon_vma_clone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-synchronize-lock-and-unlock-target-in-anon_vma_clone.patch

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
From: Eric Kim <seohyun.kim@outlook.kr>
Subject: mm/rmap: synchronize lock and unlock target in anon_vma_clone
Date: Fri, 14 Aug 2026 15:30:51 +0900

Currently, in anon_vma_clone(), src vma's anon_vma is assigned to
active_anon_vma and is used when unlocking anon_vma after linking new
AVCs.  However, the anon_vma is locked using src->anon_vma, instead of
active_anon_vma, making the lock and unlock target inconsistent.

Use active_anon_vma for both locking and unlocking.

Link: https://lore.kernel.org/OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com
Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-synchronize-lock-and-unlock-target-in-anon_vma_clone
+++ a/mm/rmap.c
@@ -350,7 +350,7 @@ int anon_vma_clone(struct vm_area_struct
 	 * Now link the anon_vma's back to the newly inserted AVCs.
 	 * Note that all anon_vma's share the same root.
 	 */
-	anon_vma_lock_write(src->anon_vma);
+	anon_vma_lock_write(active_anon_vma);
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
_

Patches currently in -mm which might be from seohyun.kim@outlook.kr are

mm-rmap-synchronize-lock-and-unlock-target-in-anon_vma_clone.patch

