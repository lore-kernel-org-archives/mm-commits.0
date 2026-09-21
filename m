Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F5333260C
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961503; cv=none; b=lw+rpuyPk/RBi97fPjvws8SRrYxFgFPrxRzmEvnIF0KYhzRTEx/4c4tCoMt7qQge1cPvOfAhBFC7J4WiWV4/nCHDcBoDQKxKKbyr/l9I6IefuehpWeMD6hjSQV5N9JVYicvNnLO2nxK5ooOhTemeYRTcPPdnb1oIysyRwGy5pyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961503; c=relaxed/simple;
	bh=OPf++3TsuFhiEWHfFtBvZWC82mzxFUJwAar6W4XLoz0=;
	h=Date:To:From:Subject:Message-Id; b=C+wKeGQdmp5nxYI/Riywdgc5y3kjtEm83B43y6cBmKEFrlayRQvKe1sGo4eblJHo+0deaD7d6f4wMyWvQwc8Ys5skDdxYBBlNMZkaHbWdPPTJpG3ci/sml5OHOfKAyh8MRn0sWHbUuwOFuRqRldRd58ZuiJJ/mkWBkeRZMqQJJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZUTjOVvw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZUTjOVvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DCA1F000FF;
	Mon, 21 Sep 2026 03:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961502;
	bh=Cods5BRqQWfqw5QSJ4tbnn2NhsBH8EX7dkAnIZZWUEk=;
	h=Date:To:From:Subject;
	b=ZUTjOVvw75VOJpdpaPt9u5+y4BUtbjtvvFxaonEbT4J9LnpvyF62pFNA9lzjLPI9f
	 VkkRmFZC4T0dPN5O5hH1KogPs8qLwnkZ5k4BMF1Jmue6pPf9Queu8lSRQ8JmmTFXxL
	 ZEpgADloIOLbjSq9dmFniNdJxZnqsItm/Zb+vm+s=
Date: Sun, 20 Sep 2026 20:31:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ceph-replace-pageprivate-with-page_private.patch removed from -mm tree
Message-Id: <20260921033141.F0DCA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ceph: replace PagePrivate() with page_private()
has been removed from the -mm tree.  Its filename was
     ceph-replace-pageprivate-with-page_private.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: ceph: replace PagePrivate() with page_private()
Date: Sun, 13 Sep 2026 22:24:10 -0400

PagePrivate() is going to be removed along with PG_private and its
implementation is the same as page_private().

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-12-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Alex Markuze <amarkuze@redhat.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
---

 fs/ceph/addr.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/ceph/addr.c~ceph-replace-pageprivate-with-page_private
+++ a/fs/ceph/addr.c
@@ -70,9 +70,7 @@ static int ceph_netfs_check_write_begin(
 
 static inline struct ceph_snap_context *page_snap_context(struct page *page)
 {
-	if (PagePrivate(page))
-		return (void *)page->private;
-	return NULL;
+	return (void *)page_private(page);
 }
 
 /*
@@ -124,8 +122,8 @@ static bool ceph_dirty_folio(struct addr
 	spin_unlock(&ci->i_ceph_lock);
 
 	/*
-	 * Reference snap context in folio->private.  Also set
-	 * PagePrivate so that we get invalidate_folio callback.
+	 * Reference snap context in folio->private. Setting folio->private is
+	 * what gets us the invalidate_folio callback.
 	 */
 	VM_WARN_ON_FOLIO(folio->private, folio);
 	folio_attach_private(folio, snapc);
_

Patches currently in -mm which might be from ziy@nvidia.com are

md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

