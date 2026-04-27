Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5871930EF9B
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292306; cv=none; b=drKe+JI7eqBvdyNiI1Rj10Vl5+UjdySYTq/jVGR2wtz7kmbJg1Cwb63kyr+2jtIJr8z6Wp8HF8Qj+zjYfL3JfAv+shW07W8ANvow2UWeTwo1Aj0XPEeQU3mtROSfWgZ/l9yHxTXsE8vJi6UdkMdtREyfDRYcb7IM2sEr1ESoGys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292306; c=relaxed/simple;
	bh=rxcFqBCy8z4ZpGGQw5x+cr1+n92H28hZnM+uQ3w+cNc=;
	h=Date:To:From:Subject:Message-Id; b=W+PUWy2Bb+6lpJqGBFXndHJuh1Jbevcgwee1q1SSy1TPMRKuLvMDkAVJRm2tdl17t8uGmvGVDTTCzQYRrp8EgdIVsu3PLm0FMDsfxkvviv1wu4ohqjCC4p5sxxChOS1n+9nSBsUOnYpcdGs55qzcioOPgB2XjnJyjzMsHARJ/mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HUHdLPj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HUHdLPj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79DEC19425;
	Mon, 27 Apr 2026 12:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777292305;
	bh=rxcFqBCy8z4ZpGGQw5x+cr1+n92H28hZnM+uQ3w+cNc=;
	h=Date:To:From:Subject:From;
	b=HUHdLPj4D+U4SGptMh9pUlJjXwGtn9QMAg860m/ilvJ7/s2/MzEYu+8WRpHcT76Wf
	 9J0QCWpMWQyz+ZNmbLKy/iwaS4/MqNi6lQxfEQYGDbUgcN8n0a8cGGOL7waOkVUKov
	 wlmhHJxSkEN/HhZKPOw0dv60/sWcis/jUQyScUvw=
Date: Mon, 27 Apr 2026 05:18:25 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,willy@infradead.org,vbabka@kernel.org,surenb@google.com,song@kernel.org,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,memxor@gmail.com,martin.lau@linux.dev,ljs@kernel.org,liam@infradead.org,jolsa@kernel.org,jannh@google.com,harry@kernel.org,glaubitz@physik.fu-berlin.de,eddyz87@gmail.com,dalias@libc.org,ast@kernel.org,andrii@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch added to mm-new branch
Message-Id: <20260427121825.D79DEC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: use folio_mapped() instead of page_mapped() in sh4_flush_cache_page()
has been added to the -mm mm-new branch.  Its filename is
     sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: sh: use folio_mapped() instead of page_mapped() in sh4_flush_cache_page()
Date: Mon, 27 Apr 2026 13:43:14 +0200

Patch series "mm: remove page_mapped()".

While preparing my slides for an LSF/MM talk, I realized that I did not
yet remove page_mapped().

So let's do that.  In the BPF arena code it's unclear which memdesc we
would want to allocate in the future: certainly something with a refcount,
but likely none with a mapcount.  So let's just rely on the page refcount
instead to decide whether we want to try zapping the page from user page
tables.


This patch (of 3):

We already have the folio in our hands, so let's just use folio_mapped().

Link: https://lore.kernel.org/20260427-page_mapped-v1-0-e89c3592c74c@kernel.org
Link: https://lore.kernel.org/20260427-page_mapped-v1-1-e89c3592c74c@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <song@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/cache-sh4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/mm/cache-sh4.c~sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page
+++ a/arch/sh/mm/cache-sh4.c
@@ -248,7 +248,7 @@ static void sh4_flush_cache_page(void *a
 		 */
 		map_coherent = (current_cpu_data.dcache.n_aliases &&
 			test_bit(PG_dcache_clean, folio_flags(folio, 0)) &&
-			page_mapped(page));
+			folio_mapped(folio));
 		if (map_coherent)
 			vaddr = kmap_coherent(page, address);
 		else
_

Patches currently in -mm which might be from david@kernel.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch
sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch
bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch
mm-remove-page_mapped.patch

