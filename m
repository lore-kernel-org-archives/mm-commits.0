Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719541714C6
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739852822; cv=none; b=uuXXi3BiMPbOqKuyiAQfuoxrbk25tEUV6yW2FpXivglLJS8zIXt6GqJsZd67ZyrHUTqDrE+zU0022x/Lb1sxkiIWKrTmMCfmt7A6T0sSGmHYprxyVhOCKhVHHda8n3zj4TR9ldX2R5XzBsGTN+RrPENiVlR2o7GxzBz9k5pN3GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739852822; c=relaxed/simple;
	bh=eDpTmU67SEnuycc790OOevX18vw2rnHh2/Z1rNjfnlg=;
	h=Date:To:From:Subject:Message-Id; b=qjXox4IsilImCtTOGwluZKKHU3VJPBHS0cvx/O6cZ+VAZ79AghEp1UsTut3zDCXZTKtKUBE7I56ZRi+hYp97os/DLgS8pH44AeFvncVbmNB2v4be21CHdxxUWds7dg9DXBfSS1ohJwkltWBP8iuziwbDs2YvUYyZG5kQNkAVL/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Adolo3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Adolo3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F27C4CEE2;
	Tue, 18 Feb 2025 04:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739852821;
	bh=eDpTmU67SEnuycc790OOevX18vw2rnHh2/Z1rNjfnlg=;
	h=Date:To:From:Subject:From;
	b=2Adolo3dejI71+6VtIKKeBpHTuKNKQR614bIhcUj7g2ULKYlxOQiNM8iYkqntpNUq
	 VlsEJz/hvw5avhdN31TNJyqp8qK1DPqbPabGqnooF8VpJXQddyCoOu853Hm01kM6Kx
	 u5H0KA77Rsk2+/f+aDMGtTQtjupRSokqxP0y+/mM=
Date: Mon, 17 Feb 2025 20:27:01 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,jserv@ccns.ncku.edu.tw,corbet@lwn.net,eleanor15x@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-core-api-min_heap-update-for-variable-types-change.patch added to mm-nonmm-unstable branch
Message-Id: <20250218042701.C2F27C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/core-api: min_heap: update for variable types change
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-core-api-min_heap-update-for-variable-types-change.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-core-api-min_heap-update-for-variable-types-change.patch

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

documentation-core-api-min_heap-update-for-variable-types-change.patch

