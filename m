Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D746E3126AB
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421689; cv=none; b=Ozu0TAVz+9YF4IOWJtOpPyl9IYtbDFRKCwOHcHRNOzjJdixpsOo/2Ce3Rdo2niIeVgY8dMkGNbO/qirKVf1gDzxrjDLH4Z7W1GzD20IKBDEVVM8iEdrTydH+CT9R/Dc8i9cYy0S4k64yD/2OAq4LbwgYrGmr2eEL98rlg4I9ORE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421689; c=relaxed/simple;
	bh=oS7diYkC+vVu4jEzQbpPb4oyRDJotn2MZN1sxwZu2gQ=;
	h=Date:To:From:Subject:Message-Id; b=FTyb1aCpf+uQCjiJ6AgJRIIo2broBi8CkWfkF9AYKvhPRP+K0xzHtFg8lFBNd0s5wwEPBxi5ZWzuPOSry9JAZ+9NhkCTFenpslrBBlBUnssDyuvQChCErQp6BAjTiXe0faa60QCnWB7mQAaZ8Wy+dhmn5VLOnEBb6WNMyIgO6/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A8yfmaAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A8yfmaAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764CEC116C6;
	Fri,  6 Feb 2026 23:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421689;
	bh=oS7diYkC+vVu4jEzQbpPb4oyRDJotn2MZN1sxwZu2gQ=;
	h=Date:To:From:Subject:From;
	b=A8yfmaAVQDhw/fttbJQLWDYY0jP3Zf8r0nBX+YsHYLagICW6waOMM0buJyMD3DZk3
	 JawDYjGwRUIlX8dDd31Q0Dcc6x6oiSwpfnkvLKW8iRX5DHBTFr6zQgwUWnIvOEkVQT
	 32ukypkaGQnVV6w+OsHS6HgBtXooeea2aCeyznFI=
Date: Fri, 06 Feb 2026 15:48:08 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,cheng20011202@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-fix-typo-in-comment.patch removed from -mm tree
Message-Id: <20260206234809.764CEC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: fix typo in comment
has been removed from the -mm tree.  Its filename was
     mm-readahead-fix-typo-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wilson Zeng <cheng20011202@gmail.com>
Subject: mm/readahead: fix typo in comment
Date: Tue, 27 Jan 2026 23:25:35 +0800

Fix a typo in a comment: max_readhead -> max_readahead.

Link: https://lkml.kernel.org/r/20260127152535.321951-1-cheng20011202@gmail.com
Signed-off-by: Wilson Zeng <cheng20011202@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/readahead.c~mm-readahead-fix-typo-in-comment
+++ a/mm/readahead.c
@@ -436,7 +436,7 @@ static unsigned long get_next_ra_size(st
  * based on I/O request size and the max_readahead.
  *
  * The code ramps up the readahead size aggressively at first, but slow down as
- * it approaches max_readhead.
+ * it approaches max_readahead.
  */
 
 static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
_

Patches currently in -mm which might be from cheng20011202@gmail.com are


