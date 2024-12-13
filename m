Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5782C16EB76
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 04:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734062468; cv=none; b=QLYgP7BrC2J1sIvg5/gFG1WGxvmwABCKWFDSqWFpNdJBN8N04AHtkPv0BT8oCx+biANy+9KnRmcTs5RDUM88kN3NuBceGx/6+v46vQAkafcJybgKmZA72f234+ENGksGp/xNXJgcy6SyiQsdUjcd2vmsSbxepjoB7uv7R/HHrd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734062468; c=relaxed/simple;
	bh=zhUsUcIHAPP3PLUIk5ndFyfnReQlyFla4p02Ap6MqXQ=;
	h=Date:To:From:Subject:Message-Id; b=ZakE3m0EABXmq6IpHpOqJLwXHs3cPRlNo1WmKOAwLxZRIXWJ7IVEjmwIYOTJOGROYv0SXm0VqqiTUZ3NFHcdnH3KVnDVFRkX9nkPsFgiRJkseYIU4eoGzEWAO4vOuNMnqIeGtqWh3fUjQn8HOACT+sm49AipTyNJ+HNJfotAv/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sH7MR9xq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sH7MR9xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152D9C4CED4;
	Fri, 13 Dec 2024 04:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734062468;
	bh=zhUsUcIHAPP3PLUIk5ndFyfnReQlyFla4p02Ap6MqXQ=;
	h=Date:To:From:Subject:From;
	b=sH7MR9xqgmfH/UXV+y017/rXMy6D2JWqzQuSxTjoyN8c3igvB+UpkXZUuLVFRAE9e
	 4Grnzz4tckyHtk382y+lCn7Tee2MJ2Z8gaYJVQtbjNsiNuub7xYT+4i+GW2MtXqvHo
	 p/Kat7/QYZorlLPzGYc/1Q237hsyjpqKb3DaUZw0=
Date: Thu, 12 Dec 2024 20:01:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-distinguish-large-entries-correctly-in-xas_split_alloc.patch added to mm-nonmm-unstable branch
Message-Id: <20241213040108.152D9C4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Xarray: distinguish large entries correctly in xas_split_alloc()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-distinguish-large-entries-correctly-in-xas_split_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-distinguish-large-entries-correctly-in-xas_split_alloc.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: Xarray: distinguish large entries correctly in xas_split_alloc()
Date: Fri, 13 Dec 2024 20:25:21 +0800

We don't support large entries which expand two more level xa_node in
split.  For case "xas->xa_shift + 2 * XA_CHUNK_SHIFT == order", we also
need two level of xa_node to expand.  Distinguish entry as large entry in
case "xas->xa_shift + 2 * XA_CHUNK_SHIFT == order".

As max order of folio in pagecache (MAX_PAGECACHE_ORDER) is <=
(XA_CHUNK_SHIFT * 2 - 1), this change is more likely a cleanup...

Link: https://lkml.kernel.org/r/20241213122523.12764-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/xarray.c~xarray-distinguish-large-entries-correctly-in-xas_split_alloc
+++ a/lib/xarray.c
@@ -1027,7 +1027,7 @@ void xas_split_alloc(struct xa_state *xa
 	unsigned int mask = xas->xa_sibs;
 
 	/* XXX: no support for splitting really large entries yet */
-	if (WARN_ON(xas->xa_shift + 2 * XA_CHUNK_SHIFT < order))
+	if (WARN_ON(xas->xa_shift + 2 * XA_CHUNK_SHIFT <= order))
 		goto nomem;
 	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
 		return;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

xarray-do-not-return-sibling-entries-from-xas_find_marked.patch
xarray-move-forward-index-correctly-in-xas_pause.patch
xarray-distinguish-large-entries-correctly-in-xas_split_alloc.patch
xarray-remove-repeat-check-in-xas_squash_marks.patch
xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent.patch

