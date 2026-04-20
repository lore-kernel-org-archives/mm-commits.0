Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E1C33E377;
	Mon, 20 Apr 2026 16:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700943; cv=none; b=f+iPnWFXIeYGmI8EUuUKbZjXRbJ7dVTiO4b67bWIU8nc7QhAuISJgdbOEB1tI2DFzIBCn5kCWWH16ChE3IhV4FwHIhM8KXCMngiZbfom6l9tNH9QuoD/Ktth/O1Ctd6t2UQuXFma0a6UdzGPE90wx0qvWeA0cWnvBO900cmuAgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700943; c=relaxed/simple;
	bh=2oIhMKk5lIFp7QMHv3phBe62aQKpniqvOir5C2/gYYE=;
	h=Date:To:From:Subject:Message-Id; b=WzlmrztI2sJ0TOdx6xRfqqcFJEtnjS2m4OsOzihakOtDLmM3qJw7DV1fqrb72Rqq+8MAkzwV4DQKFx4AEAJg1GaWrHDaqFfgrk+eainQComRAZtYQ7Kb5HvTYMii37stIuw9vOBI918GmYxg8mEHfYJWvOy1E4y84RUH3BRNYfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ccr1FAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ccr1FAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FC8C2BCB6;
	Mon, 20 Apr 2026 16:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776700943;
	bh=2oIhMKk5lIFp7QMHv3phBe62aQKpniqvOir5C2/gYYE=;
	h=Date:To:From:Subject:From;
	b=0ccr1FABWDOLmo2ducxbZgAfOK9ROolbmPmAQvRb8TGHEUDAdweZj4ci+kfZz/Ea6
	 VjZlXvgg6ohOTfxa95NaXEybZU45nYPB80wGGpPNJkANBaAjGaCNr4+D2RxajJPaEZ
	 zMVGksS1MT5c7FWmHaoxm0yd7FnzotVkaZ2OZ07A=
Date: Mon, 20 Apr 2026 09:02:20 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,urezki@gmail.com,stable@vger.kernel.org,harry@kernel.org,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-fix-buffer-overflow-in-vrealloc_node_align.patch added to mm-hotfixes-unstable branch
Message-Id: <20260420160222.91FC8C2BCB6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: fix buffer overflow in vrealloc_node_align()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     vmalloc-fix-buffer-overflow-in-vrealloc_node_align.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-fix-buffer-overflow-in-vrealloc_node_align.patch

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
From: Marco Elver <elver@google.com>
Subject: vmalloc: fix buffer overflow in vrealloc_node_align()
Date: Mon, 20 Apr 2026 13:47:26 +0200

Commit 4c5d3365882d ("mm/vmalloc: allow to set node and align in
vrealloc") added the ability to force a new allocation if the current
pointer is on the wrong NUMA node, or if an alignment constraint is not
met, even if the user is shrinking the allocation.

On this path (need_realloc), the code allocates a new object of 'size'
bytes and then memcpy()s 'old_size' bytes into it.  If the request is to
shrink the object (size < old_size), this results in an out-of-bounds
write on the new buffer.

Fix this by bounding the copy length by the new allocation size.

Link: https://lore.kernel.org/20260420114805.3572606-2-elver@google.com
Fixes: 4c5d3365882d ("mm/vmalloc: allow to set node and align in vrealloc")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~vmalloc-fix-buffer-overflow-in-vrealloc_node_align
+++ a/mm/vmalloc.c
@@ -4361,7 +4361,7 @@ need_realloc:
 		return NULL;
 
 	if (p) {
-		memcpy(n, p, old_size);
+		memcpy(n, p, min(size, old_size));
 		vfree(p);
 	}
 
_

Patches currently in -mm which might be from elver@google.com are

vmalloc-fix-buffer-overflow-in-vrealloc_node_align.patch

