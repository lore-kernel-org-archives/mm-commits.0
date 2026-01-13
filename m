Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71152DBF78;
	Tue, 13 Jan 2026 05:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280965; cv=none; b=QaaYJMfpivg2cfnznw00N/F620U7hPdJBBZgxKhyd4qef1fCNymHkEMXblHBCyNv7YA7tSOPvuekxOzpxgTGy7JM3Ell++JfEb8DYWu+5su7qvRUb/M4FFJHIzwdH5rzKtuX6dlj9CExbogKbJnaS7bHdjJ4WWZaZx5ugIHgcgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280965; c=relaxed/simple;
	bh=V4KBSY8WlyaDQVCUg34Xc30tOxyP/Y0VwUwYRVh/cWA=;
	h=Date:To:From:Subject:Message-Id; b=Z+FA/uLGMyw1f0sZScAixce1RP+zOLq1TRaSo4lgKV9OIL7U3v8Y9LqTPuA31DIYKzPSXwZaZUOfPZ3q2gy7LOdLuJn9MPC+CC2imeqM17UoZaJ4+U3AgsTY8GFPP+EeDuKW2DMJf/u7g0TtAbNmJay31PhB6QHSUcoQvAAD66I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IzWOFpn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IzWOFpn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F22C116C6;
	Tue, 13 Jan 2026 05:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280965;
	bh=V4KBSY8WlyaDQVCUg34Xc30tOxyP/Y0VwUwYRVh/cWA=;
	h=Date:To:From:Subject:From;
	b=IzWOFpn0bZWzKQn0RAYU4nir8ZEBb7ObT69uwFwfzDdmKHXH+JSL03sDcfoY1OUcr
	 6Xxv3WD8lGJMDyh8HTCgo7FKESRryXzTijgga/7McK6uhlRtLevidJMxtdzYrhE0wM
	 Bgugq0x2nCQrj2lRYeiXtrYHdz6CJEUXV9xiqPhA=
Date: Mon, 12 Jan 2026 21:09:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangjinchao600@gmail.com,stable@vger.kernel.org,hch@lst.de,djwong@kernel.org,daniel@iogearbox.net,brauner@kernel.org,ast@kernel.org,andrii@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-buildid-use-__kernel_read-for-sleepable-context.patch removed from -mm tree
Message-Id: <20260113050925.66F22C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/buildid: use __kernel_read() for sleepable context
has been removed from the -mm tree.  Its filename was
     lib-buildid-use-__kernel_read-for-sleepable-context.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: lib/buildid: use __kernel_read() for sleepable context
Date: Mon, 22 Dec 2025 12:58:59 -0800

Prevent a "BUG: unable to handle kernel NULL pointer dereference in
filemap_read_folio".

For the sleepable context, convert freader to use __kernel_read() instead
of direct page cache access via read_cache_folio().  This simplifies the
faultable code path by using the standard kernel file reading interface
which handles all the complexity of reading file data.

At the moment we are not changing the code for non-sleepable context which
uses filemap_get_folio() and only succeeds if the target folios are
already in memory and up-to-date.  The reason is to keep the patch simple
and easier to backport to stable kernels.

Syzbot repro does not crash the kernel anymore and the selftests run
successfully.

In the follow up we will make __kernel_read() with IOCB_NOWAIT work for
non-sleepable contexts.  In addition, I would like to replace the
secretmem check with a more generic approach and will add fstest for the
buildid code.

Link: https://lkml.kernel.org/r/20251222205859.3968077-1-shakeel.butt@linux.dev
Fixes: ad41251c290d ("lib/buildid: implement sleepable build_id_parse() API")
Reported-by: syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09b7d050e4806540153d
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jinchao Wang <wangjinchao600@gmail.com>
  Link: https://lkml.kernel.org/r/aUteBPWPYzVWIZFH@ndev
Reviewed-by: Christian Brauner <brauner@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/buildid.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/lib/buildid.c~lib-buildid-use-__kernel_read-for-sleepable-context
+++ a/lib/buildid.c
@@ -5,6 +5,7 @@
 #include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
+#include <linux/fs.h>
 #include <linux/secretmem.h>
 
 #define BUILD_ID 3
@@ -46,20 +47,9 @@ static int freader_get_folio(struct frea
 
 	freader_put_folio(r);
 
-	/* reject secretmem folios created with memfd_secret() */
-	if (secretmem_mapping(r->file->f_mapping))
-		return -EFAULT;
-
+	/* only use page cache lookup - fail if not already cached */
 	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
 
-	/* if sleeping is allowed, wait for the page, if necessary */
-	if (r->may_fault && (IS_ERR(r->folio) || !folio_test_uptodate(r->folio))) {
-		filemap_invalidate_lock_shared(r->file->f_mapping);
-		r->folio = read_cache_folio(r->file->f_mapping, file_off >> PAGE_SHIFT,
-					    NULL, r->file);
-		filemap_invalidate_unlock_shared(r->file->f_mapping);
-	}
-
 	if (IS_ERR(r->folio) || !folio_test_uptodate(r->folio)) {
 		if (!IS_ERR(r->folio))
 			folio_put(r->folio);
@@ -97,6 +87,24 @@ const void *freader_fetch(struct freader
 		return r->data + file_off;
 	}
 
+	/* reject secretmem folios created with memfd_secret() */
+	if (secretmem_mapping(r->file->f_mapping)) {
+		r->err = -EFAULT;
+		return NULL;
+	}
+
+	/* use __kernel_read() for sleepable context */
+	if (r->may_fault) {
+		ssize_t ret;
+
+		ret = __kernel_read(r->file, r->buf, sz, &file_off);
+		if (ret != sz) {
+			r->err = (ret < 0) ? ret : -EIO;
+			return NULL;
+		}
+		return r->buf;
+	}
+
 	/* fetch or reuse folio for given file offset */
 	r->err = freader_get_folio(r, file_off);
 	if (r->err)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-private-id-api-for-in-kernel-users.patch
memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch
memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch
memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch
mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch
mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch
memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix.patch

