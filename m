Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D64335BB4
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465779; cv=none; b=oNUr/nlqKwJgeVC0kxBhy2FrvACgtXHKoApO21y7VBXJRmE30EdqB8yH+ho+ZmwRMOuQppf4rOxDbqudjPWon3y6a6OePvYpos+k7lQU8wc/NJTUkKlFXBFqiizXmgKvj/v9I8j+cEBt5KTW9tItRmQd1Uh+B6sOrqk56gNumjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465779; c=relaxed/simple;
	bh=L00wIasMTr741x7YKEHmrd9HLjP7UE15PG6pb1H809U=;
	h=Date:To:From:Subject:Message-Id; b=Wn3N/95oh09P4MpEYocQoCORkjwHVNBqezzJMBITQxwzCgzOZlmQ9juxmoGfB6YDL09b7ukJ5PSsP999CCiUkuMocHkMlUVts+amh5IEwmUFL9Hq1X367TICSA967Ku9tJqnbMgQrrnUWcW3z+E+3r02QWniyRlVA5+Bcz7cUiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tu5Y7lxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tu5Y7lxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDD41F00A3A;
	Fri, 31 Jul 2026 02:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465778;
	bh=yom8Prf7pZbjPHjvPwLqNV2r9BQupe+9GCvG6SfRemo=;
	h=Date:To:From:Subject;
	b=tu5Y7lxmx0sD6uOCGlR9u/wBYqAgKpohvsN56pZrolErfWM9DRsZKgLayvhs+t/ZY
	 k02wFq6ggTUMq6tpZTnKCTN2vvI/aArd3qkOkbsSzXH6lX+vgCnksxshN8FJajzSOv
	 mqgXlLwvFPF9FhLJ/zVkAB0yc0KRfgNzKw+D8nik=
Date: Thu, 30 Jul 2026 19:42:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,hughd@google.com,brauner@kernel.org,yanzhen20011121@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-mapping_seek_hole_data-overflow-on-last-page.patch removed from -mm tree
Message-Id: <20260731024258.5DDD41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix mapping_seek_hole_data() overflow on last page
has been removed from the -mm tree.  Its filename was
     mm-fix-mapping_seek_hole_data-overflow-on-last-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhen Yan <yanzhen20011121@163.com>
Subject: mm: fix mapping_seek_hole_data() overflow on last page
Date: Tue, 30 Jun 2026 20:50:47 +0800

A local unprivileged process can create a shmem/tmpfs file with i_size ==
LLONG_MAX using memfd_create() and fallocate().  If the last page is
present in the page cache, lseek(SEEK_HOLE) on that page returns
0x8000000000000000 as a successful offset, which is LLONG_MIN when stored
in loff_t.

The same file has readable data at the last byte, but SEEK_DATA from that
offset returns ENXIO.

The overflow is in mapping_seek_hole_data():

  pos = round_up((u64)pos + 1, seek_size);

For the final page below LLONG_MAX, the next page boundary is
0x8000000000000000, which is then used as a signed file offset.  When
assigned to the loff_t pos, this overflows to LLONG_MIN, so a subsequent
"pos > end" comparison does not catch it.

Keep mapping_seek_hole_data() inside its documented [start, end) search
range: compute round_up() into a u64 variable and compare against (u64)end
so the overflow is detected, then clamp pos to end when the rounded-up
value goes past the search limit.

Link: https://lore.kernel.org/20260630125047.703170-1-yanzhen20011121@163.com
Signed-off-by: Zhen Yan <yanzhen20011121@163.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~mm-fix-mapping_seek_hole_data-overflow-on-last-page
+++ a/mm/filemap.c
@@ -3229,6 +3229,7 @@ loff_t mapping_seek_hole_data(struct add
 	while ((folio = find_get_entry(&xas, max, XA_PRESENT))) {
 		loff_t pos = (u64)xas.xa_index << PAGE_SHIFT;
 		size_t seek_size;
+		u64 next;
 
 		if (start < pos) {
 			if (!seek_data)
@@ -3237,7 +3238,11 @@ loff_t mapping_seek_hole_data(struct add
 		}
 
 		seek_size = seek_folio_size(&xas, folio);
-		pos = round_up((u64)pos + 1, seek_size);
+		next = round_up((u64)pos + 1, seek_size);
+		if (next > (u64)end)
+			pos = end;
+		else
+			pos = next;
 		start = folio_seek_hole_data(&xas, mapping, folio, start, pos,
 				seek_data);
 		if (start < pos)
_

Patches currently in -mm which might be from yanzhen20011121@163.com are


