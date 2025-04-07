Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676D818C03F
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 04:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744001058; cv=none; b=UCgOtpJQbM6c9pMSEgDax6YarQu9AxVhsNdTSwzgPau75rViJvCMi3SljTg9A3tm32d5fs73kPgztlvOSThCSJnd6M+S7A2obzxPfcS9OY8oyxlkbxbvC63IYqNlEAHQE0KtaSxU04qHHtRuWKEDlp8+NnKxLgzPb2OzmtXfIMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744001058; c=relaxed/simple;
	bh=YU8KErwyh/7XwtF5aqJkEknqK2kgP1m4h2Ermwxy7ww=;
	h=Date:To:From:Subject:Message-Id; b=JBJgvYJV4vJlIhGp9j4+jDb7S+zzU1Rkh8eY/Y68qThXxS/xLCyllzcRpMe5i83WbIBSMdqTtkL58UAwokYZM487Kj+Rp+W24uLdoCnL2L+iLiRKuXWvC5c4VCOvFSoaYKmJFY/E+CcJ04SoMvTy4Q0F2z9Pv84HdxEMmThila4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nBnWJksU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nBnWJksU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDDAC4CEDD;
	Mon,  7 Apr 2025 04:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744001057;
	bh=YU8KErwyh/7XwtF5aqJkEknqK2kgP1m4h2Ermwxy7ww=;
	h=Date:To:From:Subject:From;
	b=nBnWJksU9OURBKUpVIuplUQ07nyRAPpibFJ8BcZ81shiUAE0DIakqbtOnJ0SfVFOb
	 E1DCFZ43pfbSOBk8tKRQ4ewBe4kanm7WqEgPhkbNr/lqrQTbl/+qCkjPNmu38gGRne
	 9q17vmeRX8JxXX3eBdMjM427VVkq/vtI72yxCzwc=
Date: Sun, 06 Apr 2025 21:44:17 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,osalvador@suse.de,mingo@kernel.org,david@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-unneeded-checking-in-follow_page_pte.patch added to mm-new branch
Message-Id: <20250407044417.BDDDAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: remove unneeded checking in follow_page_pte()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-remove-unneeded-checking-in-follow_page_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-unneeded-checking-in-follow_page_pte.patch

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
Subject: mm/gup: remove unneeded checking in follow_page_pte()
Date: Mon, 7 Apr 2025 11:03:05 +0800

In __get_user_pages(), it will traverse page table and take a reference to
the page the given user address corresponds to if GUP_GET or GUP_PIN is
set.  However, it's not supported both GUP_GET and GUP_PIN are set.  Even
though this check need be done, it should be done earlier, but not doing
it till entering into follow_page_pte() and failed.

Furthermore, this checking has been done in is_valid_gup_args() and all
external users of __get_user_pages() will call is_valid_gup_args() to
catch the illegal setting.  We don't need to worry about internal users of
__get_user_pages() because the gup_flags are set by MM code correctly.

Here remove the checking in follow_page_pte(), and add VM_WARN_ON_ONCE()
to catch the possible exceptional setting just in case.

And also change the VM_BUG_ON to VM_WARN_ON_ONCE() for checking (!!pages
!= !!(gup_flags & (FOLL_GET | FOLL_PIN))) because the checking has been
done in is_valid_gup_args() for external users of __get_user_pages().

Link: https://lkml.kernel.org/r/20250407030306.411977-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-gup-remove-unneeded-checking-in-follow_page_pte
+++ a/mm/gup.c
@@ -844,11 +844,6 @@ static struct page *follow_page_pte(stru
 	pte_t *ptep, pte;
 	int ret;
 
-	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
-	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
-			 (FOLL_PIN | FOLL_GET)))
-		return ERR_PTR(-EINVAL);
-
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!ptep)
 		return no_page_table(vma, flags, address);
@@ -1432,7 +1427,11 @@ static long __get_user_pages(struct mm_s
 
 	start = untagged_addr_remote(mm, start);
 
-	VM_BUG_ON(!!pages != !!(gup_flags & (FOLL_GET | FOLL_PIN)));
+	VM_WARN_ON_ONCE(!!pages != !!(gup_flags & (FOLL_GET | FOLL_PIN)));
+
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	VM_WARN_ON_ONCE((gup_flags & (FOLL_PIN | FOLL_GET)) ==
+			(FOLL_PIN | FOLL_GET));
 
 	do {
 		struct page *page;
_

Patches currently in -mm which might be from bhe@redhat.com are

maintainers-add-andrew-and-myself-as-kexec-maintainer.patch
mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch

