Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1450A485924;
	Tue, 13 Oct 2026 04:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866014; cv=none; b=utVprd7UcN+FQ/gitA/F+cEQqEbZHZQwmpe9kjDdMfuyAbypsNKODuyp/9Tz3yiEzWf7wv6prC50p5rV7DaiRdfKBLj8QJBZOEEc42AKFUFNrw3gcQK+1IXKNu13X5HBq5eKMnJ0KR/JTJ3J6ZngPh+0RIHJUPoHnVIC0jabOVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866014; c=relaxed/simple;
	bh=QPZqEh1JG1JowJVES+t4fse0kI0krnywPLOVHu42Y1I=;
	h=Date:To:From:Subject:Message-Id; b=U9shJSyeo0QYaXlKT5SAVCZmF8cuB/eocyI1GJaDNldM0p34HdXsaAXT4GwAtTiW9F2ZxicIi8D5Jy7t43EhvpkLEFubq+SvLyQJwgJjxk15xhR4EsjTj9jPCiq1qXjkMyLMKvmX/eLPyWaO7abUacbLGw6w88h9l5DfxeqSt14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kQdCiEL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kQdCiEL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDA41F000FF;
	Tue, 13 Oct 2026 04:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866013;
	bh=qPja8RIU9noBswcpGbCo4OC3FRdK7PD8zJ441cKnado=;
	h=Date:To:From:Subject;
	b=kQdCiEL9+AAPr33KkiNrHo5iFLmsOYRHm54YqbfqsqH+tV7Ahq34pdgLoJ/41l0Tk
	 eNPIVM5ltcO0w42O4uAhfbOxQJM74mx5byyauu5gdVimhZ+gYTuEZlBVBy3WPaIyFi
	 +Al38SwP20DCejNfVL3O9iuOZHrlJ7B+M+tQ3Q7k=
Date: Mon, 12 Oct 2026 21:33:32 -0700
To: mm-commits@vger.kernel.org,syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,hughd@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-dont-release-a-swapin-error-marker-as-a-swap-entry.patch removed from -mm tree
Message-Id: <20261013043332.DEDA41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: don't release a swapin-error marker as a swap entry
has been removed from the -mm tree.  Its filename was
     mm-shmem-dont-release-a-swapin-error-marker-as-a-swap-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Carlier <devnexen@gmail.com>
Subject: mm/shmem: don't release a swapin-error marker as a swap entry
Date: Sun, 20 Sep 2026 16:50:02 +0100

A failed shmem swapin (eg, EIO) frees the swap slot and leaves a
PTE_MARKER_POISONED entry in the page cache.  On truncate or eviction
shmem_free_swap() passes that marker to swap_put_entries_direct(), which
warns because it is not a swap entry.  There is nothing left to release
either way.

Skip the release for non-swap entries, as every other caller already does.

Link: https://lore.kernel.org/20260920155002.1030454-1-devnexen@gmail.com
Fixes: ac2d3268284b ("mm/swapfile.c: remove the unneeded checking")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=23b25ba3c6bf971f9c57
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chis Li <chrisl@kernel.org> (Google)
Cc: Hugh Dickens <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/shmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-dont-release-a-swapin-error-marker-as-a-swap-entry
+++ a/mm/shmem.c
@@ -1184,6 +1184,7 @@ static long shmem_free_swap(struct addre
 			    pgoff_t index, pgoff_t end, void *radswap)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	const softleaf_t swp = radix_to_swp_entry(radswap);
 	unsigned int nr_pages = 0;
 	pgoff_t base;
 	void *entry;
@@ -1200,8 +1201,9 @@ static long shmem_free_swap(struct addre
 	}
 	xas_unlock_irq(&xas);
 
-	if (nr_pages)
-		swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
+	/* A swapin-error marker holds no swap slot, so just drop it. */
+	if (nr_pages && softleaf_is_swap(swp))
+		swap_put_entries_direct(swp, nr_pages);
 
 	return nr_pages;
 }
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

