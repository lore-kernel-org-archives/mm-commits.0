Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DAB1DF736;
	Tue, 23 Dec 2025 00:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450182; cv=none; b=OfTTbPlmK/DkB3M/9BfnHC7ZipItL7LLTX09YwbIoXCr5Enq0ynOeVpk1MOz4WPDUrZSuqKnwfRlmvf6ry0d45T6whse8T48HpIuSh6JQ10GIVx27gjFLfAmb7U2Sp5RM5RSub+UaLthAZZoEjFOTzVK2hhFPJm4YUS99VW5UWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450182; c=relaxed/simple;
	bh=cVQl2SFKLEK4K92yzymemUS+sSWEstr0zTH0p7BPN7A=;
	h=Date:To:From:Subject:Message-Id; b=qgqL5++TN/w0UTwdvlh6xcMdjwNya3HhL4gr8+ekoJCJN6CAMT7pRVhH69UtNLhNJel/bDl++HTt352aT9V094JARIimK1Z/bdSjblRcazaJEukQzuC7VIc6xLLXHOB9byZWLMXRZRwJ0QNlUMt8iQuXz7Y7KACVEznWXSyKOHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Px4DCXCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Px4DCXCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA6CC4CEF1;
	Tue, 23 Dec 2025 00:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766450181;
	bh=cVQl2SFKLEK4K92yzymemUS+sSWEstr0zTH0p7BPN7A=;
	h=Date:To:From:Subject:From;
	b=Px4DCXCNhxltkqKzNJE2mQGl2Afplj6fDQtJyI4cIxdqqsqxHuKW7VkiDIQTnYjq6
	 VSDSTS915tZ7sro7oGfVl8Mgz6tBRTGaFgEDOapok8Kgla5mTbFvfnO1i9Qwt6OC15
	 YjxEjOCLuFaiYRPSB+VCSJSdwKg00iO6uw7BX5yQ=
Date: Mon, 22 Dec 2025 16:36:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,hch@lst.de,djwong@kernel.org,daniel@iogearbox.net,ast@kernel.org,andrii@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-buildid-use-__kernel_read-for-sleepable-context.patch added to mm-hotfixes-unstable branch
Message-Id: <20251223003621.3CA6CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/buildid: use __kernel_read() for sleepable context
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-buildid-use-__kernel_read-for-sleepable-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-buildid-use-__kernel_read-for-sleepable-context.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-memcg-fix-unit-conversion-for-k-macro-in-oom-log.patch
lib-buildid-use-__kernel_read-for-sleepable-context.patch

