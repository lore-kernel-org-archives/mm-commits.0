Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C306930E0F8;
	Mon, 27 Apr 2026 12:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294498; cv=none; b=ERdGZ8TGKtyTLoIiupgY6M9b0e3PTkBJfCzMre+oQUynmY8tltqTaA/k7Tz17vtUVimbL0YByuiaZ+4ejwih0vJpx1jH7a3rfjxExq2/KW8NqlRTS3NyqiGDpu0uGrxvBY5Gz+RGmaukI6I1I6lnqsHBNIXArEvE+7rnq8N2G2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294498; c=relaxed/simple;
	bh=wgVk72+XDVQUy97KVGpKHVmAAhh2QqpT7XggA7Tux0Q=;
	h=Date:To:From:Subject:Message-Id; b=jw+GxQyTIbeiAWDEFvbMPCmTdT70AJF8RX/cStzCfzSnWH0UYC90WuH+f80muSn5SJacO5KlKsBcTpSoGkXEbAqFEniCv7ui5y/Dw5dFsSaqYyBrBYk8FvnmM52wMbtlCh3Q7DnLCd000u765SILyUtIL8foS9swdT80fWMtSec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rJjF2DsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rJjF2DsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5DDC19425;
	Mon, 27 Apr 2026 12:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294498;
	bh=wgVk72+XDVQUy97KVGpKHVmAAhh2QqpT7XggA7Tux0Q=;
	h=Date:To:From:Subject:From;
	b=rJjF2DsGgRjMOrsD7Iojgpc/KG6LNy0akDM+VeIm1qRmYSSRoTkMjThLtECKbqmln
	 DbbcyJwyQLQ+WhSW/HUovkzXzxaDjYe+oYyQKoOVT7h7P88EPYoFbL9McsulidPmwG
	 qpwbRPhFdtfJp0kdWv3N0m1rE0qlf/pRGWlZQs8k=
Date: Mon, 27 Apr 2026 05:54:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,urezki@gmail.com,stable@vger.kernel.org,harry@kernel.org,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] vmalloc-fix-buffer-overflow-in-vrealloc_node_align.patch removed from -mm tree
Message-Id: <20260427125458.5C5DDC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: fix buffer overflow in vrealloc_node_align()
has been removed from the -mm tree.  Its filename was
     vmalloc-fix-buffer-overflow-in-vrealloc_node_align.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


