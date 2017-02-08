From: akpm@linux-foundation.org
Subject: +
 mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock-fix.patch added to -mm tree
Date: Wed, 08 Feb 2017 13:41:27 -0800
Message-ID: <589b9087.WPqZ29+hH7FVvQRw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50202 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752178AbdBHVl2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 16:41:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock-fix
has been added to the -mm tree.  Its filename is
     mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock-fix

drop unneeded pmd_trans_unstable(pmd) check after __split_huge_pmd()

index f9c07f54dd62..e919e4613eab 100644
Link: http://lkml.kernel.org/r/20170208120421.GE5578@node.shutemov.name
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/mprotect.c~mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock-fix mm/mprotect.c
--- a/mm/mprotect.c~mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock-fix
+++ a/mm/mprotect.c
@@ -163,8 +163,6 @@ static inline unsigned long change_pmd_r
 		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
-				if (pmd_trans_unstable(pmd))
-					continue;
 			} else {
 				int nr_ptes = change_huge_pmd(vma, pmd, addr,
 						newprot, prot_numa);
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock-fix.patch

