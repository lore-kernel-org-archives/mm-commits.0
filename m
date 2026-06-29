Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F30C338593
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 05:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782709780; cv=none; b=kyY4BEULzunGyd1j37meC8lfdlvtRh7iQKU1oYWVTNTj0uQzP5BtzLxCUV9ySpHtwz7T43QIJ1JRtNn2P2LFi51mUlrwJrpDnLjnl+3zf0WPUOSnimDOTkI7BSLS6QZh4cEDLAc9oZCvUbfM84hliorYS0r71TR12LsH/KkC1uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782709780; c=relaxed/simple;
	bh=stYguVuuxCFotLAE++sYsbWBVyh9JYm/f8AVeuA1Lx0=;
	h=Date:To:From:Subject:Message-Id; b=e8KvWjLy5L8KT1hhwW254veupvaTb92/0QpbmHveG2RpFTEvJzcDABiGa82jqdhMGQZD37aI6ixPWB+RVopcNiPYVisDy//Yb5IGviLGvGq2cLRb6wUST9Dem33nS4KhPWo3yem3M2rXL9l42Jaf1s1v9bFKqveIvcnEYKMC+W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBE11F000E9;
	Mon, 29 Jun 2026 05:09:38 +0000 (UTC)
Date: Sun, 28 Jun 2026 22:09:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,skhan@linuxfoundation.org,ljs@kernel.org,gregkh@linuxfoundation.org,corbet@lwn.net,doehyunbaek@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-driver-api-uio-howto-document-mmap_prepare-callback.patch removed from -mm tree
Message-Id: <20260629050938.8CBE11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/driver-api/uio-howto: document mmap_prepare callback
has been removed from the -mm tree.  Its filename was
     docs-driver-api-uio-howto-document-mmap_prepare-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Doehyun Baek <doehyunbaek@gmail.com>
Subject: Docs/driver-api/uio-howto: document mmap_prepare callback
Date: Mon, 22 Jun 2026 18:18:21 +0000

The UIO howto still documents an mmap callback in struct uio_info.  That
field was replaced by mmap_prepare, which takes a struct vm_area_desc.

A UIO driver following the current howto no longer builds because struct
uio_info has no mmap member.  Update the documented callback signature and
matching text to match the current API.

Link: https://lore.kernel.org/20260622181821.1195257-1-doehyunbaek@gmail.com
Fixes: 933f05f58ac6 ("uio: replace deprecated mmap hook with mmap_prepare in uio_info")
Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/driver-api/uio-howto.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/driver-api/uio-howto.rst~docs-driver-api-uio-howto-document-mmap_prepare-callback
+++ a/Documentation/driver-api/uio-howto.rst
@@ -246,10 +246,10 @@ the members are required, others are opt
    hardware interrupt number. The flags given here will be used in the
    call to :c:func:`request_irq()`.
 
--  ``int (*mmap)(struct uio_info *info, struct vm_area_struct *vma)``:
+-  ``int (*mmap_prepare)(struct uio_info *info, struct vm_area_desc *desc)``:
    Optional. If you need a special :c:func:`mmap()`
    function, you can set it here. If this pointer is not NULL, your
-   :c:func:`mmap()` will be called instead of the built-in one.
+   ``mmap_prepare`` will be called instead of the built-in one.
 
 -  ``int (*open)(struct uio_info *info, struct inode *inode)``:
    Optional. You might want to have your own :c:func:`open()`,
_

Patches currently in -mm which might be from doehyunbaek@gmail.com are


