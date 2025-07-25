Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0838E2BAF4
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 01:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753406151; cv=none; b=RtowgC7wYutNVQ6zF6JLkZG1rt2OcEyU+ALy5irSTsAdiQXB3zbBhiolNnCMv6sUTT6QfutbGz8e8n6i8zuNXtxZQKVi8rPq2yvs5zT7fHZqnXxqTsuCkLQ44UvhnhpRLO4//BV0HnU6e9XmM9YhNgmtmFHGxP0DwjWjCpQG0jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753406151; c=relaxed/simple;
	bh=cjcis14RxSytQB+6/Lj+xhPqlOY5lTm0jMf6Qrrw18Y=;
	h=Date:To:From:Subject:Message-Id; b=ey2tpX0CSuybEOjiIl578ExCEC/VAXS70BK1n2Byf1xCk4PoOdvBL/wHGBbfrOjRQcNZWhonT2sL9FrMds4Q5Eg9JzH1m9L/9TTbSOaQj6pmvJH2xw9tfRlBAO2z9KuCDYPe9NNY2GEujgaim0JX6nNofyDlH9y/Z4/57YI/Kv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CiinIuII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CiinIuII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8113BC4CEED;
	Fri, 25 Jul 2025 01:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753406150;
	bh=cjcis14RxSytQB+6/Lj+xhPqlOY5lTm0jMf6Qrrw18Y=;
	h=Date:To:From:Subject:From;
	b=CiinIuIIrAd75hKfogCSdQrn8wRjz0pNYnft9yQVZzGYIvABfDdZ6d2LXAgH4z72/
	 mPPK12KQKedmqh8gZZ8FuA8XRkQVxZvNq05JqKN18MD3q9Ig/kN8YLe3iRihPDF5F0
	 lEhxU7CUUECfKqbej+1NIhew2+hsw1hQiZOAbYTU=
Date: Thu, 24 Jul 2025 18:15:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,shivankg@amd.com,osalvador@suse.de,harry.yoo@oracle.com,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-util-introduce-snapshot_page-fix.patch removed from -mm tree
Message-Id: <20250725011550.8113BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-util-introduce-snapshot_page-fix
has been removed from the -mm tree.  Its filename was
     mm-util-introduce-snapshot_page-fix.patch

This patch was dropped because it was folded into mm-util-introduce-snapshot_page.patch

------------------------------------------------------
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm-util-introduce-snapshot_page-fix
Date: Thu, 17 Jul 2025 11:54:07 -0400

fix set_ps_flags() commentary

Link: https://lkml.kernel.org/r/d5c75701-b353-4536-a306-187fab0655b3@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/util.c~mm-util-introduce-snapshot_page-fix
+++ a/mm/util.c
@@ -1198,10 +1198,12 @@ static void set_ps_flags(struct page_sna
  * Create a snapshot of the page and store both its struct page and struct
  * folio representations in @ps.
  *
- * Note that creating a faithful snapshot may fail if the compound
- * state of the page keeps changing (e.g., due to a folio split). In
- * this case, ps->faithful is set to false, and the snapshot assumes
- * that @page refers to a single page.
+ * A snapshot is marked as "faithful" if the compound state of @page was
+ * stable and allowed safe reconstruction of the folio representation. In
+ * rare cases where this is not possible (e.g. due to folio splitting),
+ * snapshot_page() falls back to treating @page as a single page and the
+ * snapshot is marked as "unfaithful". The snapshot_page_is_faithful()
+ * helper can be used to check for this condition.
  */
 void snapshot_page(struct page_snapshot *ps, const struct page *page)
 {
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-util-introduce-snapshot_page.patch
proc-kpagecount-use-snapshot_page.patch
fs-stable_page_flags-use-snapshot_page.patch

