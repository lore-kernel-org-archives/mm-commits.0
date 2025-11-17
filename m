Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026771E1E16
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343086; cv=none; b=tNWgQzLgworCsNZx9QdkgWoPq32nGkEpTcq1S6icWN2puDuSQVT+N2ljbuXGiyQzWqU5oi6k+Ni8QVTJUWdIs31sjFcuOG1xWC2qbQoa3zY2DJ/nie8e/1GYlZn94FNTPBe8mTH38RwGEzDghdAcnRjNd+hJqiplrQokpo7NcB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343086; c=relaxed/simple;
	bh=HX8IfHjk54djwR69OVmWUxtmQJ/JST1IJUNGLkK+4R8=;
	h=Date:To:From:Subject:Message-Id; b=qB1uHpU3k3uVfMIjKBIjWyoKQinSYFscPhdSBpMnOGUGY/KVAqA7yjuub92FM0Kq0dhbIUWdr7Ngxv4ikQIdZpiS+P5/EPdMJhsgqcso/XTSeTCPgFZlqkJKBTTrfclUjCBK/ofvdvlHxAvXpbcI6Mr8wJtxEIrVQsvJFLmheO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WzeSP5pO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WzeSP5pO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D93C113D0;
	Mon, 17 Nov 2025 01:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343085;
	bh=HX8IfHjk54djwR69OVmWUxtmQJ/JST1IJUNGLkK+4R8=;
	h=Date:To:From:Subject:From;
	b=WzeSP5pOZZbdA2kfgYkzCHGOHyZeMnumHyLuKOysYnDcArEKgYEePCyok65GCrBMR
	 9/WpWfLJ7q0ODgWGL9/vrDWlCmOTeZk3RQ4+AEkjwnAyyssVGOuo7cnB3fNDss7fot
	 H4TM9cU27klOlYap66UVmEnPQmlnEi++ZJkOKZLc=
Date: Sun, 16 Nov 2025 17:31:24 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch removed from -mm tree
Message-Id: <20251117013125.61D93C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kasan: support non-blocking GFP in kasan_populate_vmalloc()
has been removed from the -mm tree.  Its filename was
     mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/kasan: support non-blocking GFP in kasan_populate_vmalloc()
Date: Tue, 7 Oct 2025 14:20:31 +0200

A "gfp_mask" is already passed to kasan_populate_vmalloc() as an argument
to respect GFPs from callers and KASAN uses it for its internal
allocations.

But apply_to_page_range() function ignores GFP flags due to a hard-coded
mask.

Wrap the call with memalloc_apply_gfp_scope()/memalloc_restore_scope() so
that non-blocking GFP flags(GFP_ATOMIC, GFP_NOWAIT) are respected.

Link: https://lkml.kernel.org/r/20251007122035.56347-7-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/mm/kasan/shadow.c~mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc
+++ a/mm/kasan/shadow.c
@@ -377,18 +377,10 @@ static int __kasan_populate_vmalloc(unsi
 		 * page tables allocations ignore external gfp mask, enforce it
 		 * by the scope API
 		 */
-		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-			flags = memalloc_nofs_save();
-		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-			flags = memalloc_noio_save();
-
+		flags = memalloc_apply_gfp_scope(gfp_mask);
 		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
 					  kasan_populate_vmalloc_pte, &data);
-
-		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-			memalloc_nofs_restore(flags);
-		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-			memalloc_noio_restore(flags);
+		memalloc_restore_scope(flags);
 
 		___free_pages_bulk(data.pages, nr_pages);
 		if (ret)
_

Patches currently in -mm which might be from urezki@gmail.com are


