Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF99225D6
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 02:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811466; cv=none; b=BArDGnGe3ovnb+l2j5l/8OVVU6bw+g8+scJ+MQnSbzslSeIALrKK4P4LlSxW/NdlqvtBt+OMC8LiPB+n+1kqn1wurxe+ubuCP6Ei6xpcQom7UN4Pj2K2hVaPAF6WoZi41FO3acx+5KfdnETfkbmOm009zz2PdnI+o+Z8ih0lrwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811466; c=relaxed/simple;
	bh=R2TlpKlt+lyQDcsanIPQuHs/RD3gUTN3mZCG0oZSMxw=;
	h=Date:To:From:Subject:Message-Id; b=KBg+yZ5JEpt1zjOEKRgz++WsS4442OzgsMktoEZa0SnBJ1cTj/awa9r9eqAmrXcR62hts6Y/YH4xb7gveSeULfujDkq+t8/UAKrQW/agVsxRaVu3fn5pI8re/hpPWxM06bciINuhNx8iGEeWI4U1jY6FFfRAyAYvRj8PTCE8Il8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fkEqLogh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fkEqLogh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D7AC4E66E;
	Wed, 28 Aug 2024 02:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724811464;
	bh=R2TlpKlt+lyQDcsanIPQuHs/RD3gUTN3mZCG0oZSMxw=;
	h=Date:To:From:Subject:From;
	b=fkEqLoghB/N7hADN7yE6VNUoYLI+o82hnF5blchhsbt4SydEO4I9E58SVNU8gWhSS
	 yyeLkXGtObPuFpbeGsFk+3+Ip/HImu01eAmz/j3JWApXrYnjtdPMN0JcIK6ZOLMPNM
	 7eBH1nrGn+XK+F/HVofF7YGDCTKRU6BRTt3jcoF8=
Date: Tue, 27 Aug 2024 19:17:43 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch added to mm-unstable branch
Message-Id: <20240828021744.50D7AC4E66E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch

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
Subject: mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix
Date: Tue Aug 27 07:16:26 PM PDT 2024

comment tweak, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix
+++ a/mm/shmem.c
@@ -685,7 +685,7 @@ next:
 		if (!folio || xa_is_value(folio))
 			goto drop;
 
-		/* No large page at the end of the file: nothing to split */
+		/* No large folio at the end of the file: nothing to split */
 		if (!folio_test_large(folio)) {
 			folio_put(folio);
 			goto drop;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-migrate-convert-to-folio_isolate_movable-checkpatch-fixes.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

