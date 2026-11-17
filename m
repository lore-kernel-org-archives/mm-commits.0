Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794881252;
	b=Lrc0B/wrem87QOFemwkl3qMeulcMolrANDPF+t7Cik1iDDvYXo21PoMgMaZuIFFvvJZZ
	 oNIumturMSPDMPmaPjPrDpzRI98DpEaTE1qkY3gzkIdfqsvzWSsKz1Tm/Z6dC3WCZqbzI
	 bGh2e/o6mqQYWWdgCF7lrAGHbxiVeWNo1WIerHdwQeeOq5lzytc1jKPBE8gqX9gubSvi+
	 NI8wJKV4PGa7m7ixNXUL22xB2TVv17P0TOKDCsYjG4LLGIl4PNG4VcUtp8WiFCN26hHLD
	 DayeCvx28PHzuW16UOPI1btFE4hTJLc91C+Ccwt99mzK1NuusacoUifNcw4FIY9azAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794881252;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=j2WgYjYQaHKJE6pdmAuwAmDek7bHPUe9xdF01dUoO80=;
	b=sm0J04JxWDC6EqfUXdrPmriTjDA/NucqlqT1CBm2LvXuayZcBFBvZTSSxWBuSyIKi/p0
	 m1+giHa4BKXZyWYiagSA4gyCrJwsY2SG5tZEGe/mapSk0Y7+NyA2ImUkH7jG/TPUGCknv
	 Qxw2qH9BGp8GVp0je7YO60hbZ7bD1Wo5HfMna8tYKiSQiicUWEt5GOXiABoXyon8GhKkx
	 4sMNZvsJJuzWJGSY00A+hIY3WuAmNpk6tkbsBZLyu03g33fb7FL3UirzNNxAWNvUEXhTS
	 vMzaKwqsPDesVsihv1C+DLPXouHy/HmPjd55l3DPYpavneDMTBGptB6KQtC46h4k+DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mgKJLIMT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E22A606A334
	for <mm-commits@vger.kernel.org>; Tue, 17 Nov 2026 02:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mgKJLIMT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8FD1F000C6;
	Tue, 17 Nov 2026 02:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794881251;
	bh=j2WgYjYQaHKJE6pdmAuwAmDek7bHPUe9xdF01dUoO80=;
	h=Date:To:From:Subject;
	b=mgKJLIMT+AV1oiLkD+XqtNUSM7cwkNlho5HO1z+quBDa4xgCel1NAh+bLrDB0r4WX
	 byC+UM0N/O/+nfTUSC7MEMiIhc2gVFlf115PqTNLLU6fq9HILYxTTFqexIkryBmoyK
	 7ia1gF9MlzDaeJryc3ZUVPKJPl/kRW8vs7UkKkJg=
Date: Mon, 16 Nov 2026 18:07:30 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,
	muchun.song@linux.dev,david@kernel.org,jthoughton@google.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-dont-restore-vmemmap-of-non-hvoed-folios-on-bulk-restore-error.patch added to mm-new branch
Message-Id: <20261117020731.6C8FD1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: hugetlb: don't restore vmemmap of non-HVOed folios on bulk restore error
has been added to the -mm mm-new branch.  Its filename is
     hugetlb-dont-restore-vmemmap-of-non-hvoed-folios-on-bulk-restore-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-dont-restore-vmemmap-of-non-hvoed-folios-on-bulk-restore-error.patch

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
From: James Houghton <jthoughton@google.com>
Subject: hugetlb: don't restore vmemmap of non-HVOed folios on bulk restore error
Date: Mon, 16 Nov 2026 22:15:57 +0000

When hugetlb_vmemmap_restore_folios() fails, it stops processing the list,
so folio_list may still contain folios that were never vmemmap optimized,
e.g.  because HVO failed when they were allocated.  Their hugetlb flag has
already been cleared by remove_hugetlb_folio().

If no folios could be restored, bulk_vmemmap_restore_error() then calls
hugetlb_vmemmap_restore_folio() on every folio left on folio_list,
including those, which trips the !folio_test_hugetlb() check in
__hugetlb_vmemmap_restore_folio():

  page dumped because: VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio))
  WARNING: mm/hugetlb_vmemmap.c:503 at __hugetlb_vmemmap_restore_folio+0x270/0x300
  ...
   __hugetlb_vmemmap_restore_folio+0x270/0x300 (P)
   hugetlb_vmemmap_restore_folio+0x1c/0x30
   update_and_free_pages_bulk+0x2c0/0x368
   __nr_hugepages_store_common+0x2e8/0x3f0

Otherwise this is benign: the restore is a no-op returning success for
non-optimized folios, which are then freed as intended.

Skip the restore for folios that are not vmemmap optimized; they can be
freed right away.

This is very unlikely to happen without fault injection, as it requires
both HVO and a subsequent vmemmap restore to fail.

Link: https://lore.kernel.org/20261116221557.3128331-1-jthoughton@google.com
Fixes: cfb8c75099db ("hugetlb: perform vmemmap restoration on a list of pages")
Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>

 mm/hugetlb.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~hugetlb-dont-restore-vmemmap-of-non-hvoed-folios-on-bulk-restore-error
+++ a/mm/hugetlb.c
@@ -1655,21 +1655,28 @@ static void bulk_vmemmap_restore_error(s
 		 * If are able to restore vmemmap and free one hugetlb page, we
 		 * quit processing the list to retry the bulk operation.
 		 */
-		list_for_each_entry_safe(folio, t_folio, folio_list, lru)
-			if (hugetlb_vmemmap_restore_folio(h, folio)) {
-				list_del(&folio->lru);
-				spin_lock_irq(&hugetlb_lock);
-				add_hugetlb_folio(h, folio, true);
-				spin_unlock_irq(&hugetlb_lock);
-			} else {
-				list_del(&folio->lru);
+		list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
+			list_del(&folio->lru);
+			/*
+			 * remove_hugetlb_folio() already cleared the hugetlb flag
+			 * for folios whose vmemmap was not optimized, so they can
+			 * be freed without restoring vmemmap.
+			 */
+			if (folio_test_hugetlb(folio)) {
+				if (hugetlb_vmemmap_restore_folio(h, folio)) {
+					spin_lock_irq(&hugetlb_lock);
+					add_hugetlb_folio(h, folio, true);
+					spin_unlock_irq(&hugetlb_lock);
+					continue;
+				}
 				spin_lock_irq(&hugetlb_lock);
 				__folio_clear_hugetlb(folio);
 				spin_unlock_irq(&hugetlb_lock);
-				update_and_free_hugetlb_folio(h, folio, false);
-				cond_resched();
-				break;
 			}
+			update_and_free_hugetlb_folio(h, folio, false);
+			cond_resched();
+			break;
+		}
 	}
 }
 
_

Patches currently in -mm which might be from jthoughton@google.com are

hugetlb-dont-restore-vmemmap-of-non-hvoed-folios-on-bulk-restore-error.patch

