Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A9536F914
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027650; cv=none; b=dFwUSq9/D8JEiOjU6WO9h2mX0Tb+c35bghPkmBijZxUlscm0PNOHF6oEvGXhWOqf47rz3aSAEsGg2WYcW9ugqZx5xPHfoxBugvErM/0ioAWXmd0/9AOMQbcSnDhXuFeO+XsgMi1vhl3uaddq/gHBA4svVNdAgOw7UoIb1hgT0aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027650; c=relaxed/simple;
	bh=UFRweKyz+0KyBxe49Jlw4onEAq6Mp+u4OyEoLlzvVU0=;
	h=Date:To:From:Subject:Message-Id; b=er96MXIrjXvIek5S7IfPwn8FQxIsJGnu7X9BN9F9etKC6MbvsqnCiLJKJvPZmJqqtvp3Qs9AIwR06kYKUQKOKT7r1Tejh2hhxbJKmUoTGolc2Ti6iYb++lmVKOd8IjK8fltz5+lRii2MaWMoytXt7HJEyGfjhifsHEWwaEINZDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DqFyr1dB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DqFyr1dB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3694D1F00893;
	Fri, 29 May 2026 04:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027649;
	bh=QjvU0/RnKtw69pfgSQtInGyllvZhJaKYRvozPNypIHA=;
	h=Date:To:From:Subject;
	b=DqFyr1dBxJcTjpVW7X+pEEig5dDS6LI0Y/PlbJy/kvl0KsqTQQM6uDviym5GLELHw
	 SqfzlAWFdPjvSbl1jkqBt0LYB3RDxJVsgTfsa3/1qLPa6g3JjiNZXATaZX+7/ZtruY
	 z20SkjpoIpl48FHIE4uzSvN28fb27cJBxOSy5voA=
Date: Thu, 28 May 2026 21:07:28 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,willy@infradead.org,vbabka@kernel.org,surenb@google.com,song@kernel.org,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,memxor@gmail.com,martin.lau@linux.dev,ljs@kernel.org,liam@infradead.org,jolsa@kernel.org,jannh@google.com,harry@kernel.org,glaubitz@physik.fu-berlin.de,eddyz87@gmail.com,dalias@libc.org,ast@kernel.org,andrii@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch removed from -mm tree
Message-Id: <20260529040729.3694D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bpf: arena: use page_ref_count() instead of page_mapped() in arena_free_pages()
has been removed from the -mm tree.  Its filename was
     bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: bpf: arena: use page_ref_count() instead of page_mapped() in arena_free_pages()
Date: Mon, 27 Apr 2026 13:43:15 +0200

Pages that BPF arena code maps are allocated through
bpf_map_alloc_pages(), which does not allocate folios but pages.

In the future, pages will not have a mapcount, only folios will. 
Converting the code to use folios and rely on folio_mapped() sounds like
the wrong approach.

Should BPF arena code allocate folios and use folio_mapped() here?  But
likely we would not want to use folios here longterm, as we don't really
need folio information.

Hard to tell.  But in the meantime, we can simply use the page refcount
instead, as a heuristic whether the page might be mapped to user space and
we would want to try zapping it, so we can get rid of page_mapped().

Page allocation will give us a page with a refcount of 1.  Any user space
mapping adds a page reference.  While there can be references from other
subsystems (e.g., GUP), in the common case for this test here relying on
the page count is good enough.

Link: https://lore.kernel.org/20260427-page_mapped-v1-2-e89c3592c74c@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

 kernel/bpf/arena.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/arena.c~bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages
+++ a/kernel/bpf/arena.c
@@ -729,7 +729,7 @@ static void arena_free_pages(struct bpf_
 
 	llist_for_each_safe(pos, t, __llist_del_all(&free_pages)) {
 		page = llist_entry(pos, struct page, pcp_llist);
-		if (page_cnt == 1 && page_mapped(page)) /* mapped by some user process */
+		if (page_cnt == 1 && page_ref_count(page) > 1) /* maybe mapped by user space */
 			/* Optimization for the common case of page_cnt==1:
 			 * If page wasn't mapped into some user vma there
 			 * is no need to call zap_pages which is slow. When
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-remove-register_page_bootmem_info.patch
mm-bootmem_info-drop-initialization-of-page-lru.patch
mm-bootmem_info-stop-using-pg_private.patch
mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch
mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch
mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch
s390-mm-use-free_reserved_page-in-vmem_free_pages.patch
powerpc-mm-remove-config_have_bootmem_info_node.patch

