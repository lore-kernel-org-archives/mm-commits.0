Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB975283FEF;
	Thu, 18 Dec 2025 21:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766092900; cv=none; b=Pies+foeDXevNxxCB2ScFi+GpXqCCaNWkous6HA2nSJ8ALkgG0YvXA+tcO52oJ0KRBqxceThCc4WvWMn6uDb2bXFpQ+S/9+m1rNv9uslyA8noQNWHCmuPoKDC1hOp3ziS5XnRoaC28B5q9k+bBLw0HUIRbn9XbMOVcb3mV4DzLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766092900; c=relaxed/simple;
	bh=3pYZaXxohSvkAV3IhoGDdLwI1FBIso2wTVbEpTHUyq0=;
	h=Date:To:From:Subject:Message-Id; b=MMFOirPNbdCk0Pnvi6sLLj36At/YygY1MwGXTFiAi5mzZ4/2y3UD1CkYSPVdXXf1fbtP4KjE2mWmGZRNmwP57HcXVxxjgdwlFxMoBHXWRbh67h6N6bALyr72de88Vua41rx/3tIcaWLqo5k81oP94jcbbuAGoeGtMU1rLBi9KbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kydoo07D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kydoo07D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611F6C4CEFB;
	Thu, 18 Dec 2025 21:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766092899;
	bh=3pYZaXxohSvkAV3IhoGDdLwI1FBIso2wTVbEpTHUyq0=;
	h=Date:To:From:Subject:From;
	b=Kydoo07Dqx7fuTb7Iu2sNB8tP+TYGQAJVBslwrj6FyErbEjtUbH5WVfyamZbu0o0N
	 5NLTYnpoDcD0qH+xa9qTO1xKZ/9r4SWGBqHleyt4rdXFKSLD4GGjF4ubfTOgdXAuzl
	 n++eF3MUCUAkoMzqt9nc0Gfe0sZNDHOakNFCmqQ4=
Date: Thu, 18 Dec 2025 13:21:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,hch@lst.de,djwong@kernel.org,daniel@iogearbox.net,ast@kernel.org,andrii@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-buildid-use-__kernel_read-for-sleepable-context.patch added to mm-nonmm-unstable branch
Message-Id: <20251218212139.611F6C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/buildid: use __kernel_read() for sleepable context
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-buildid-use-__kernel_read-for-sleepable-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-buildid-use-__kernel_read-for-sleepable-context.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: lib/buildid: use __kernel_read() for sleepable context
Date: Thu, 18 Dec 2025 12:55:05 -0800

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

Link: https://lkml.kernel.org/r/20251218205505.2415840-1-shakeel.butt@linux.dev
Fixes: ad41251c290d ("lib/buildid: implement sleepable build_id_parse() API")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>Reported-by: syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09b7d050e4806540153d
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/buildid.c |   47 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 12 deletions(-)

--- a/lib/buildid.c~lib-buildid-use-__kernel_read-for-sleepable-context
+++ a/lib/buildid.c
@@ -5,6 +5,7 @@
 #include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
+#include <linux/fs.h>
 #include <linux/secretmem.h>
 
 #define BUILD_ID 3
@@ -37,6 +38,29 @@ static void freader_put_folio(struct fre
 	r->folio = NULL;
 }
 
+/*
+ * Data is read directly into r->buf. Returns pointer to the buffer
+ * on success, NULL on failure with r->err set.
+ */
+static const void *freader_fetch_sync(struct freader *r, loff_t file_off, size_t sz)
+{
+	ssize_t ret;
+	loff_t pos = file_off;
+	char *buf = r->buf;
+
+	do {
+		ret = __kernel_read(r->file, buf, sz, &pos);
+		if (ret <= 0) {
+			r->err = ret ?: -EIO;
+			return NULL;
+		}
+		buf += ret;
+		sz -= ret;
+	} while (sz > 0);
+
+	return r->buf;
+}
+
 static int freader_get_folio(struct freader *r, loff_t file_off)
 {
 	/* check if we can just reuse current folio */
@@ -46,20 +70,9 @@ static int freader_get_folio(struct frea
 
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
@@ -97,6 +110,16 @@ const void *freader_fetch(struct freader
 		return r->data + file_off;
 	}
 
+	/* reject secretmem folios created with memfd_secret() */
+	if (secretmem_mapping(r->file->f_mapping)) {
+		r->err = -EFAULT;
+		return NULL;
+	}
+
+	/* use __kernel_read() for sleepable context */
+	if (r->may_fault)
+		return freader_fetch_sync(r, file_off, sz);
+
 	/* fetch or reuse folio for given file offset */
 	r->err = freader_get_folio(r, file_off);
 	if (r->err)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-memcg-fix-unit-conversion-for-k-macro-in-oom-log.patch
lib-buildid-use-__kernel_read-for-sleepable-context.patch

