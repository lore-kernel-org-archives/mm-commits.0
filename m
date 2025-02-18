Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C991DDC35
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 23:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739921371; cv=none; b=EBhkL+1utUh6NOz011WnOVHAZgjJGsI2afU5VYeBL6mbMr1DKNHnsJrbi9Avv4oD5UqfgYjZC3Lz/8RXHasukt7GiTu/WDssymZC29uFD7bZ4UQuaF21tTqXN2HTNo5naJLx8mWW6FnH82GBfqYoyuwkSdlHnf9uISZo/tcHnCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739921371; c=relaxed/simple;
	bh=8VlWyHEKmbGhUH9BEVqFyP0z9TuSSZLhZwZkYi+OEfE=;
	h=Date:To:From:Subject:Message-Id; b=V6Fa64b4GG4rVDezBQs526tQlJK0amfn9Ivyow349sPu0gJ/vpmwvO8gaF6MZTCVXnzNEqPNWFvOFL+f9JdDEWKJ6ILdxucTseKrHinXbfOU7XMmh27aKFsSICHGomS5023WDPszANlmmLVT63OhxONuh698DHcjqN7umaC0Dh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cl+K0C2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cl+K0C2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074BBC4CEE2;
	Tue, 18 Feb 2025 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739921371;
	bh=8VlWyHEKmbGhUH9BEVqFyP0z9TuSSZLhZwZkYi+OEfE=;
	h=Date:To:From:Subject:From;
	b=cl+K0C2ZwRFySv4BDcueycb+YDChuROLUkvMw4ybAgtY4M/UlHDCj6JG7O7v4+usv
	 GG69aoseDoAhUmvaR3tVacv7hmHc/v+uKGqazQFawqyYnKhTxCXV91c4/g4gQ/rAu1
	 kVV5pXAMT41QO3c0bs1MooPPYsQDClvHYURo3ty4=
Date: Tue, 18 Feb 2025 15:29:30 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,jserv@ccns.ncku.edu.tw,corbet@lwn.net,eleanor15x@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] documentation-core-api-min_heap-update-for-variable-types-change.patch removed from -mm tree
Message-Id: <20250218232931.074BBC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/core-api: min_heap: update for variable types change
has been removed from the -mm tree.  Its filename was
     documentation-core-api-min_heap-update-for-variable-types-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu-Chun Lin <eleanor15x@gmail.com>
Subject: Documentation/core-api: min_heap: update for variable types change
Date: Sat, 15 Feb 2025 23:54:21 +0800

Update the documentation to reflect the change in variable types of 'nr'
and 'size' from 'int' to 'size_t', ensuring consistency with commit
dec6c0aac4fc ("lib min_heap: Switch to size_t").

Link: https://lkml.kernel.org/r/20250215155421.2010336-1-eleanor15x@gmail.com
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Acked-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/min_heap.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/core-api/min_heap.rst~documentation-core-api-min_heap-update-for-variable-types-change
+++ a/Documentation/core-api/min_heap.rst
@@ -47,8 +47,8 @@ Example:
 
     #define MIN_HEAP_PREALLOCATED(_type, _name, _nr)
     struct _name {
-        int nr;         /* Number of elements in the heap */
-        int size;       /* Maximum number of elements that can be held */
+        size_t nr;         /* Number of elements in the heap */
+        size_t size;       /* Maximum number of elements that can be held */
         _type *data;    /* Pointer to the heap data */
         _type preallocated[_nr];  /* Static preallocated array */
     }
_

Patches currently in -mm which might be from eleanor15x@gmail.com are


