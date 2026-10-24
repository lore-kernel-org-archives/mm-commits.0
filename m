Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792820110;
	b=StR5tQTdlj8IkBMcpdbmOUoQf/e/xiMnGIRz+YnXF5MTNVvlH7CDNAauJHpCqhT6nDzi
	 KEJQPM52fP3LhY7qrOKH0kVu+dyOiZRUxnAGa8e8yegP36OAMhNLZhSu0OhHTztc2q/XJ
	 1HXrnvftaKyjzPfzzqMweI7tOZcGxCTREHNP0y2tx/fZkD8oMMMWLGEoHYS0xg5ft15mv
	 3NLa7qNIhaUG5u9391TZiUoeS07NTLHz7UE7pU6aJ/Szu7HgeJgte/ei08lN9DsDaHina
	 3avre12gCoSm0Uqvg+zjJvBAEj5H80VakphP2uEytxA2rwrOjtZvozfYk4Qh6aQsiFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792820110;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qgbzmH5BLez84vXWBuY4DmS0hOrRqlGiPhvAlG/Z/C8=;
	b=vsYqLT/AW+TyuGpHRAXRj6vGWxAm+Lz0QmaZFVR/+o68gkKhYEHGSynwE1nx9TUhMA59
	 Kn01el659vW1kC/5PgGH/coGEweZPuHXopnoBe4uc2CR7ZwH20k/oBvlDiz+1VNmhpypu
	 aLImArVIY0VePYXaowNSjfSEhge89FXSu+8MRjswTaGbigtGpPGeoZz5dBOhNyfUEHwDf
	 crTTurY5lXDpbqqywJkiEp4J+dNpxPVUjf+2u9vO3yPjWDzNaeCh0rUOsJEhFJlCHjZoe
	 DDOaYX0eaXep+312S/QzkBT8mQkJsYAcQZtcv4oBLjKduoUqpRV7w7t/F3ihGiRwzFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HvrvEHRe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7DF60A2611;
	Sat, 24 Oct 2026 05:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HvrvEHRe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B991F01828;
	Sat, 24 Oct 2026 05:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792820110;
	bh=qgbzmH5BLez84vXWBuY4DmS0hOrRqlGiPhvAlG/Z/C8=;
	h=Date:To:From:Subject;
	b=HvrvEHRe5DnD6pfBrWQNDkM+Xekwq4Mqwq2iHitBGm0zUly3UgtCWE+BGzhjGAsEb
	 fYf19eEIm0nLHb43HpptWV+1TJ3TDQCuzOs+NziI1FCIo+8TjIZTnbTIdCqumszI8r
	 wCpxtiGA9d7n3a0/ywoU0uheDTV0t0wvTeymKzy0=
Date: Fri, 23 Oct 2026 22:35:09 -0700
To: mm-commits@vger.kernel.org,xu.xin@linux.dev,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,lance.yang@linux.dev,kas@kernel.org,david@kernel.org,chengming.zhou@linux.dev,samarth.colleges@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-keep-soft-dirty-when-merging-a-page.patch added to mm-unstable branch
Message-Id: <20261024053510.25B991F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/ksm: keep soft-dirty when merging a page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-keep-soft-dirty-when-merging-a-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-keep-soft-dirty-when-merging-a-page.patch

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
From: Samarth Narang <samarth.colleges@gmail.com>
Subject: mm/ksm: keep soft-dirty when merging a page
Date: Wed, 21 Oct 2026 11:21:57 -0700

replace_page() maps the KSM page with a PTE built from scratch, so the
soft-dirty bit of the PTE it replaces is lost.  A page written since
"clear_refs 4" then no longer shows as soft-dirty once it is merged, and a
soft-dirty based dumper treats it as unchanged.

Copy the soft-dirty bit from the original PTE to the new PTE.

Link: https://lore.kernel.org/20261021182157.1873726-1-samarth.colleges@gmail.com
Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/ksm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/ksm.c~mm-ksm-keep-soft-dirty-when-merging-a-page
+++ a/mm/ksm.c
@@ -1463,6 +1463,10 @@ static int replace_page(struct vm_area_s
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
+	/* Preserve soft-dirty when replacing the page. */
+	if (pte_soft_dirty(orig_pte))
+		newpte = pte_mksoft_dirty(newpte);
+
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
 	/*
 	 * No need to notify as we are replacing a read only page with another
_

Patches currently in -mm which might be from samarth.colleges@gmail.com are

mm-ksm-keep-soft-dirty-when-merging-a-page.patch

