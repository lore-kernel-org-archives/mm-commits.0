Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072025;
	b=4k+A53ZNX44AgGrhy6aSgAdLobwq0Nbo6J7DNZwyGLh2q4enykvH6KCz9FTBGSnigWkL
	 06cKQ3oPkx7b3gD7X0jjUl+F2Eqcrlh68mr2XjMReW8WTGrUio+H4Dmv6CvoJGiT1rw/p
	 Y3m7WmANH+ma0uvKEdyeER6r9fpG33f00j28PL4/HHzSU/JGvOe61aqNKBDKPc1waNgMP
	 OdQ3k0sDg3xTxQCK3az7mw2ipdUDylSBiQw4zdaT4lEKiUpQEvHCeycpMHBiswL5sJFUf
	 dYErRt2RFs7LQxtt6S69/WAfnVYm9Nc3OqYXXV39zerU+CfR3uA3e1F+ck1JMTc1lIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072025;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=EJ5AkIdcbKxuFIfRU06q+hesLPRuDOkre90njAHdesE=;
	b=MiMU4Wx8dPhzdSQBN76coXPPyGLPm6tled4obDztRjhWAFOSMjNP5bwdfdMn/vGm71EB
	 ytxepY4cRwyUtZmjsae24YLpR4wdRTWL3hMAg1PF//+qLh0rWXzuyZvOH5Ml05pumQR98
	 XqTtFDlYPamNR+Sei9tIB2y68Sei8WvAkKZUxek4HFnPWz1LRVxoFT4KvHB+bbURXnCpU
	 3HnOghy7ObzCU7QycjoBDhq3pLwtbQdh4F8S51/JA+cOrkCbFfd4MpjuwaCa9rdjAdloy
	 1x/a+aUIysPN2C39erwkgXXIF30XGH4WOKIwPKDMqsYEYN5d4kME2kE4e6b2c28Zekw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V8vVlsp4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C01C606A324;
	Thu, 19 Nov 2026 07:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V8vVlsp4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260EF1F000C4;
	Thu, 19 Nov 2026 07:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795072025;
	bh=EJ5AkIdcbKxuFIfRU06q+hesLPRuDOkre90njAHdesE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=V8vVlsp4LVDAzvKacMPmC+NQvAvciLOxCWUX2nSq0cLYouKGCs35sHDxjQELphL67
	 aYusnTrr66CkhSwb9fkJWHnw4ecaVV9jlSiEX+hB9FPlELVwuu+7AJ5INlSvGoL2Ia
	 oGQ1SA2XNgugydwAnTr9vL87dY3GIidKM76uUpBs=
Date: Wed, 18 Nov 2026 23:07:04 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,
	willy@infradead.org,tz2294@columbia.edu,stable@vger.kernel.org,
	rppt@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,
	muchun.song@linux.dev,mike.kravetz@oracle.com,linmiaohe@huawei.com,
	kaitao.cheng@linux.dev,jane.chu@oracle.com,david@kernel.org,
	mt4022@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261103-hugetlb-hwpoison-leak-v2-1-98085750c145@columbia.edu>
References: <20261103-hugetlb-hwpoison-leak-v2-1-98085750c145@columbia.edu>
Subject: + mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio.patch added to mm-new branch
Message-Id: <20261119070705.260EF1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memory-failure: don't unpoison a leaked raw_hwp_unreliable folio
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Mani Tofigh <mt4022@columbia.edu>
Subject: mm/memory-failure: don't unpoison a leaked raw_hwp_unreliable folio
Date: Tue, 03 Nov 2026 16:00:49 -0500

Patch series "mm/hugetlb: clear the hugetlb flag before leaking a
hwpoisoned folio", v2.

If memory_failure() can't save the raw error page of a hugetlb folio,
the folio is marked raw_hwp_unreliable and leaked once it's freed.  With
hugetlb_free_vmemmap=on it's leaked while it's still a hugetlb folio,
and dissolving it then loops forever, e.g., when offlining its memory
block.  Patch 2 leaks it only after the hugetlb flag is cleared, as
without vmemmap optimization.

Miaohe pointed out that unpoison_memory() then doesn't see a hugetlb
folio anymore and unpoisons it.  That already happens without vmemmap
optimization, so patch 1 fixes it on its own and goes first.

Patch 2 lets a raw_hwp_unreliable folio reach the add_hugetlb_folio()
rollback when restoring its vmemmap fails, as
dissolve_free_hugetlb_folio() already does.  It relies on Kaitao's
"mm/hugetlb: preserve persistent flags when returning folios to the
pool" [1] to keep the flag there.

Reproducer:
https://github.com/manitofigh/files/blob/main/linux-repros/hugeoffline.c


This patch (of 2):

If memory_failure() can't save the raw error page of a hugetlb folio,
it marks the folio raw_hwp_unreliable and unpoison_memory() refuses to
unpoison it, since we don't know which subpages are poisoned.  Once the
folio is freed, __update_and_free_hugetlb_folio() leaks it on purpose.
If its hugetlb flag is cleared by then, e.g., without vmemmap
optimization, unpoison_memory() doesn't see a hugetlb folio anymore.
It treats the leaked folio as a normal page and clears PG_hwpoison on
its head, while the poisoned subpages are still unknown.

The leaked folio is still a large folio and raw_hwp_unreliable stays set
in folio->private.  We now check it on any large folio before taking the
page, so unpoison_memory() refuses the folio whether it's still hugetlb
or not.  With the fix, it returns -EBUSY for the leaked folio as it did
before the folio was freed.

Link: https://lore.kernel.org/20261103-hugetlb-hwpoison-leak-v2-0-98085750c145@columbia.edu
Link: https://patch.msgid.link/20261103-hugetlb-hwpoison-leak-v2-1-98085750c145@columbia.edu
Link: https://lore.kernel.org/all/20261102024910.31486-3-kaitao.cheng@linux.dev/ [1]
Fixes: ac5fcde0a96a ("mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage")
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Miaohe Lin <linmiaohe@huawei.com>
Closes: https://lore.kernel.org/all/ae6058ae-3703-a1d5-d82f-4102b46f227b@huawei.com/
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: <stable@vger.kernel.org>

 mm/memory-failure.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio
+++ a/mm/memory-failure.c
@@ -2812,6 +2812,15 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
+	/*
+	 * A hugetlb folio without reliable raw error info is leaked once it
+	 * is freed, and its hugetlb flag may be cleared by then.  Check the
+	 * flag in folio->private, which stays set on the leaked folio.
+	 */
+	if (folio_test_large(folio) &&
+	    folio_test_hugetlb_raw_hwp_unreliable(folio))
+		goto unlock_mutex;
+
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
 		guard(vmemmap_remap)();
_

Patches currently in -mm which might be from mt4022@columbia.edu are

mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio.patch
mm-hugetlb-clear-the-hugetlb-flag-before-leaking-a-hwpoisoned-folio.patch

