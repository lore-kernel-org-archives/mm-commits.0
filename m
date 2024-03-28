Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F52D135A4D
	for <mm-commits@vger.kernel.org>; Thu, 28 Mar 2024 19:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711652418; cv=none; b=EYw7YRiWLe3uv2d11PHZhSduH7kOrHw+5uMH5VQySihE18wRC/4oTyfpeCAlcisIx1x/eyYFosGgyv8gbO856o49svXSqBznYMJAWkdsem/oZLd/yzXQBZKWJGAl7BT89sudlpZzeQCk2zq9M7lJdaBZaSERuqZnYHwFlIHo6ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711652418; c=relaxed/simple;
	bh=8qRt72/TgEVeW+1tfPD2xZ3EP/piregEPtC92f8EzGI=;
	h=Date:To:From:Subject:Message-Id; b=e9g3NXYGwBsq8aa+Hh83itle5Rlxr5pEbUmUvyxYKWs9qSOdqe2V0XE1YPwXMKScW1Khzmbv3814Nxa0QvRrY6BhZTMpILt32PpcGN1aJ7Pc9U8DZAuersqLbirslBad1O/MbnOmnTsLDZnS1+e8upAZgVxigmvIzgYArUFH8Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R7p1WVWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R7p1WVWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC82C433F1;
	Thu, 28 Mar 2024 19:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711652418;
	bh=8qRt72/TgEVeW+1tfPD2xZ3EP/piregEPtC92f8EzGI=;
	h=Date:To:From:Subject:From;
	b=R7p1WVWRxEQVkQilru/ZzR2bBv11uwNCnf9ED34otiwA0YAfLjy07WDWEtC8UKNG7
	 KDlzJl7KXf3kToICA6XC8F3h2sKUQVNtpNv9SKJYHZg0jtumMB4eucUCvnRvhIngWb
	 oXUcrukT2rvq5YAcZqzfFUs6HkuMwR4GMOQD/720=
Date: Thu, 28 Mar 2024 12:00:17 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch added to mm-unstable branch
Message-Id: <20240328190018.4AC82C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch

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
Subject: mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix
Date: Thu Mar 28 11:57:50 AM PDT 2024

fix comment, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix
+++ a/mm/gup.c
@@ -2856,7 +2856,7 @@ static int gup_hugepte(pte_t *ptep, unsi
  * GUP updates.  When hugepd will be extended to support non-hugetlbfs or
  * even anonymous memory, we need to do extra check as what we do with most
  * of the other folios. See writable_file_mapping_allowed() and
- * folio_fast_pin_allowed() for more information.
+ * gup_fast_folio_allowed() for more information.
  */
 static int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
 		unsigned int pdshift, unsigned long end, unsigned int flags,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
drm-amd-display-use-arch_has_kernel_fpu_support-fix.patch

