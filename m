Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293134;
	b=MLA7o0tuC+3R519skS9R3RI4g3DkaLLnD9Y+hicPVprzrdjSXhEDzsJZjWzDpFsM9Hnd
	 qCfwbZbbJ47/xf8rHfsFEboUwp07XAIXgtyhtlE5SNhkRWB1t8ZBgsG7xvePlHK5Mo6Je
	 S/TAStps7YmTmem+WAkeGzvbdIZwBp1kM7b6fDL456cZJRHV1BKqNNi1zdJjW0nxR/MAZ
	 Uycs7TCB8txH0J5uXlZ6ct737HjK28A6naPGDr5B8zZSf+CJi9JUMw1eyS1f6aFfxT11/
	 aJrNFwAP9XHR5xynDAY996zqtnof4zD8JP/oKb4GzunnVysWLIQz3fY3kH7i1TIlb3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293134;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MlixK3uT8l7pB3nTPpVBJL6WBRkvQGFSDgTM04GEmMw=;
	b=LCs5DUWP9NF47KLRhOWaMq4iJhTcOCqTkYpjp5Nadhgs4Vf4wMuGcRsEtFmvvJTFhf6g
	 jfpILFLenpiKgSRtjL0nuqhK01MKRhHf3xThf0D9+tuZbpF+BbDkRz+FmvW3qQBU45Eu0
	 nc4oDfNyAp6Og1jL9FwKfuDDDq1YSSJ55jhzu14wQW51eK17omBiJQ4Am+ROo8Jjxgjs3
	 1+pRbChAqfsi1rJkQT0YI7vDlxqKHN02BeXlL5lJbeCQGtSphYSqmOgkzGfiaIee6lSs3
	 W765DCCB7dpoeK9oxywMrL+whJJ8ewVu5+fZvdV24yzSftYYMeORHMfDCt0elgdO5RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=os+R+Lpl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDC9606CB30;
	Tue, 10 Nov 2026 06:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=os+R+Lpl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87811F008A1;
	Tue, 10 Nov 2026 06:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293133;
	bh=MlixK3uT8l7pB3nTPpVBJL6WBRkvQGFSDgTM04GEmMw=;
	h=Date:To:From:Subject;
	b=os+R+LplUEhsOgZ1JAUmkcxuh9zrT8Nh+tuAu006OQCEB608SpNMHzRhlVRNJWZVU
	 o1zkO/7WMERWfhJFtV38h8C8cnoFXBnFc0tBDysMtnlXvBZIBNB77HzkzJgMMlo1p9
	 6Tmfhccfb9P3aVj8i+tl/wBbrny3DyVqp6W7XprY=
Date: Mon, 09 Nov 2026 22:45:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,
	pfalcato@suse.de,krystianmkaniewski@gmail.com,jack@suse.cz,david@kernel.org,
	akpm@linux-foundation.org,jose.fernandez@linux.dev
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-filemap-stop-fault-around-when-the-walk-steps-back.patch removed from -mm tree
Message-Id: <20261110064533.A87811F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/filemap: stop fault-around when the walk steps back
has been removed from the -mm tree.  Its filename was
     mm-filemap-stop-fault-around-when-the-walk-steps-back.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Subject: mm/filemap: stop fault-around when the walk steps back
Date: Sat, 31 Oct 2026 04:33:59 +0000

filemap_map_pages() can dereference a PTE pointer outside the page table
it locked.  KASAN has reported this as a use-after-free read [1].  The
same path can also write out of bounds.  When the stray entry reads as
none, the fault-around loop maps a page there with set_pte_range().

Its fault-around loop walks the page cache and moves vmf->pte by the
change in index.  A lower index moves it back.  xas_find() can step back
to a lower index when a multi-index entry is split during the walk.

[1] fixes xas_find(), but the loop still relies on the walk never stepping
back.  Stop the fault-around when the walk steps back.  ->fault() maps the
faulting page if the loop did not.

Link: https://lore.kernel.org/20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev
Link: https://lore.kernel.org/20260904121301.200049-1-krystianmkaniewski@gmail.com [1]
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
---

 mm/filemap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/filemap.c~mm-filemap-stop-fault-around-when-the-walk-steps-back
+++ a/mm/filemap.c
@@ -3968,6 +3968,13 @@ vm_fault_t filemap_map_pages(struct vm_f
 		unsigned long end;
 		vm_fault_t map_ret;
 
+		/* A lower index could move vmf->pte out of its page table. */
+		if (unlikely(xas.xa_index < last_pgoff)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			break;
+		}
+
 		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
 		vmf->pte += xas.xa_index - last_pgoff;
 		last_pgoff = xas.xa_index;
_

Patches currently in -mm which might be from jose.fernandez@linux.dev are


