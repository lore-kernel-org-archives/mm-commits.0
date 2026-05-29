Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5565A36F8F3
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027649; cv=none; b=DDQNYqTwP4mhdRwSzHojiWwL5AXcMlTNp1O5lvRvBg5epxWwrf5kRejyRI71bC+M4GgaRKoWReePqw8Qez8W4myrlyvvfJ6vMbzawiMELIp9RT7TnAHx408IQPXplA/Yy49AaRKZTPjrgkdJyNw3s+6Vyu98o3ht+nfggu0zNMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027649; c=relaxed/simple;
	bh=puGNJ6GINhuQdRxc4P2xT3ywY7OaUZJrO5Wt9IfWMt0=;
	h=Date:To:From:Subject:Message-Id; b=tqBFE5nVdfHpWykxLfYt3NpB3uvkERPyaR/AnnR69L7uIr2eYdwykqN2hsEsTjQA3TQ23ENtrv4i6sbqnwGHo8KSEYaAHUda8X4BhgA3e7lPpTQv+dunwxtCjkQjyULmbs5EvqQ0MfdO52PyZ9qF/5CziutmGLZct5BxJCsClXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bSY1Bbpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bSY1Bbpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86591F00898;
	Fri, 29 May 2026 04:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027647;
	bh=unJ4pscIq64Bf9sB0/yobpwmP3V/ZY7f25ziFmfHnzQ=;
	h=Date:To:From:Subject;
	b=bSY1BbpgsjM2e/emAJErEVnUfJQnmMrCRUa+ipQ05ebuc9kDMI8pyEVcajHGtsET+
	 4WWy6RWeDMS1qbNXHykuNMciXrcxCLKMkpg3sW5YJFrSCUSLdP1IGvwWJJi9ADZmv5
	 /v4t2zUaBuLoB822rl6Lm1SdP0h2Q3fGRIuR8LYs=
Date: Thu, 28 May 2026 21:07:27 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,willy@infradead.org,vbabka@kernel.org,surenb@google.com,song@kernel.org,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,memxor@gmail.com,martin.lau@linux.dev,ljs@kernel.org,liam@infradead.org,jolsa@kernel.org,jannh@google.com,harry@kernel.org,glaubitz@physik.fu-berlin.de,eddyz87@gmail.com,dalias@libc.org,ast@kernel.org,andrii@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch removed from -mm tree
Message-Id: <20260529040727.D86591F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sh: use folio_mapped() instead of page_mapped() in sh4_flush_cache_page()
has been removed from the -mm tree.  Its filename was
     sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

sparc-mm-remove-register_page_bootmem_info.patch
mm-bootmem_info-drop-initialization-of-page-lru.patch
mm-bootmem_info-stop-using-pg_private.patch
mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch
mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch
mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch
s390-mm-use-free_reserved_page-in-vmem_free_pages.patch
powerpc-mm-remove-config_have_bootmem_info_node.patch

