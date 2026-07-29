Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FE62EA173
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297087; cv=none; b=DNEg/O40zKTQ4NNn7An6t3dWwpcOLly29qy5WUjQl1QivVnDnd6NokiOrnOXUucTbiikgc3ApkEuyiTrpHYfVupqQFp18rpP4ve3822FaUgaZuTYBlaAE9T4wcWr21JMtgMZX3gdquqbIERJQLM+9YEKniZwvUkhBvqy9OODCVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297087; c=relaxed/simple;
	bh=rp/tG6csy5xcH3K4uPtGfZ6g8oWyDEMEKw0kiXOjVEs=;
	h=Date:To:From:Subject:Message-Id; b=uqKhi6TmumWPsn9Cn/JSCvw/lBD38UZ91qaIF5+KbyFaK+cFomY5tR13Lgjn18O8qBAqb3hmMBfh/0F4xiFI2RwG23x/hhezDqb0clud7B5aDE95xejjoA+Wu6fR3wipVc9CsBivTtjh0T+MM8I0HZDiLiV+VW0OhfmbByfx/Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NMjdOl+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NMjdOl+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD401F000E9;
	Wed, 29 Jul 2026 03:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297085;
	bh=fowODIiBtZyYEsYyWJ26p+wHGCglQX+j1B5KF7nBspU=;
	h=Date:To:From:Subject;
	b=NMjdOl+XYhHW3VXNHOXP8s1paGT35Od0ZVGOGY4mko8/fMk4nkrvucrtLIwKSoLoc
	 EXVFzK/xeQNCBlxmbJZcI8UI2U5W/vNG4SfV457PlkNogNL7qZ3R3zzlEd/qHnDQyj
	 Gy+n383J5Ceg/C0a5GwJQ9HQHrm0I4bawPs9qkus=
Date: Tue, 28 Jul 2026 20:51:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shivankg@amd.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate-use-migrate_info-field-instead-of-private-fix.patch removed from -mm tree
Message-Id: <20260729035124.DAD401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: add missing kernel-doc for @migrate_info
has been removed from the -mm tree.  Its filename was
     mm-migrate-use-migrate_info-field-instead-of-private-fix.patch

This patch was dropped because it was folded into mm-migrate-use-migrate_info-field-instead-of-private.patch

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/migrate: add missing kernel-doc for @migrate_info
Date: Thu, 16 Jul 2026 19:21:46 -0700

Add a kernel-doc comment for @migrate_info so that kernel-doc won't
produce a warning about it:

WARNING: include/linux/mm_types.h:507 struct member 'migrate_info' not described in 'folio'

Link: https://lore.kernel.org/20260717022146.1290242-1-rdunlap@infradead.org
Fixes: f3768940afdc ("mm/migrate: use migrate_info field instead of private")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mm_types.h~mm-migrate-use-migrate_info-field-instead-of-private-fix
+++ a/include/linux/mm_types.h
@@ -368,6 +368,8 @@ typedef unsigned short mm_id_t;
  *    dax_associate_entry.
  * @private: Filesystem per-folio data (see folio_attach_private()).
  * @swap: Used for swp_entry_t if folio_test_swapcache().
+ * @migrate_info: Stores migration state (anon_vma pointer and
+ *    FOLIO_WAS_* markers).
  * @_mapcount: Do not access this member directly.  Use folio_mapcount() to
  *    find out how many times this folio is mapped by userspace.
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-migrate-use-migrate_info-field-instead-of-private.patch
mm-page_owner-document-page_owner-filter-fix.patch
radix-tree-add-correct-some-kernel-doc.patch
delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch
rbtree-fixup-kernel-doc-names.patch
llist-use-correct-function-parameter-name.patch
stacktrace-header-repair-kernel-doc-comments.patch

