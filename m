Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672136;
	b=mcovWpfznWq3WMxQ8yT5RsOVPRXIjBmSUv74l50ZtZsrCxCHxorLoEcHImPZF14bpWt7
	 5KbvUalL61jt/uuYrWM+PGvBl0l82ChwNDRZU0FJs7yagMhJLXseSioZKBAiJgtvkj9F+
	 84njcCoSHcXdCRfgZnaIkDNHm98U91Esf+xyK0zlKs9z2WlYAe4WhNanmWRYTwWcBrdjs
	 QDDI4rLvsEU1FcEuKQsezuOy9bM8gIAFmtubmYWhc5fu3RVS4RUYlEUEbzc++FFHmgiWl
	 ZF2Cn97xYLjjN2ZJoxDTtd2p3LKMMfRrUIc59fMylTLuRTkIbCFjmgQ7g2nTz0VtNnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672136;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=81c/CIbeUI49AQeq8U0mWkFHFiq032kJ91gY7TvTAKQ=;
	b=pmDU+6L/TAU53FGGUmvaVUVgIx6am2B2hD6CVl5yS7jMnzTYnu+ufUToF0HyayJpXhVb
	 9WURhB04BUKdmRKJ58OQGcegCrOBqx8UMnpJzyRp75wq0dWYMPwKXdQqF1Ork+Fpbf419
	 RSsIHjyk9O0wm0Ss2OqAIqMR1xFm6dc33x+N4yONHWnXhdVqXF2AIJW6qkls+uGlL2ja1
	 NtdgpFHzlnjDR2l5e1V4TanO7X/ACxWwj2DwbUHgPXXe5esuWuRMn8XIcCBAk1P7VI2Tp
	 b7LRqnUFAOkFf1S9vFB4yiUrtTyNI0eDO0Fr0f1pFEuQbHjKXfeWwhJlRjkcJ/jkiYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EP5MTUec;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181AD606A332;
	Tue,  3 Nov 2026 02:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EP5MTUec
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65DB1F000C1;
	Tue,  3 Nov 2026 02:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672135;
	bh=81c/CIbeUI49AQeq8U0mWkFHFiq032kJ91gY7TvTAKQ=;
	h=Date:To:From:Subject;
	b=EP5MTUeclPHUNixWDa9HtbONA0uf35oIr1HwvYb7KcOVGSm7E+NfXxn74UjeXPurs
	 +zf4v+2dZP6jrvJ+K2H0VYquZ7izQHoXS0F/KIyyvIU8g0hQ/R4i5FCD/U2NS8v1nY
	 0WOtx9S+cS/8fv+muiyZsq+YbRjc5Llxb8TQEmlc=
Date: Mon, 02 Nov 2026 18:15:35 -0800
To: mm-commits@vger.kernel.org,xu.xin@linux.dev,stable@vger.kernel.org,
	rppt@kernel.org,peterx@redhat.com,lance.yang@linux.dev,kas@kernel.org,
	david@kernel.org,chengming.zhou@linux.dev,samarth.colleges@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-ksm-keep-soft-dirty-when-merging-a-page.patch removed from -mm tree
Message-Id: <20261103021535.D65DB1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/ksm: keep soft-dirty when merging a page
has been removed from the -mm tree.  Its filename was
     mm-ksm-keep-soft-dirty-when-merging-a-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
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


