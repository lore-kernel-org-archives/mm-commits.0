Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C9D31619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486653; cv=none; b=IX50i7oYZMXd6kZCAQjG7+w58k3nS03V+yftBVkfozJGaldbpLzBcwz5QJf/phl/1TdLsuRJUw3tc+nxxhFpbN/XVe4sHo+lnenxyGXcOlVbd5u6aImVHN7yjm/kJJ1FK8S3swwUhbPiYml+j1ZIQypQlAtj3U16bDNJclIFyKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486653; c=relaxed/simple;
	bh=9pVU8MUotnkCNLeByOxC49aIDLFe90mtv8hIZu3xQ8w=;
	h=Date:To:From:Subject:Message-Id; b=UnTD7sHWIOgDHc7Aztq0/8kMnBP56onn/DyF92q3j8V/kH0Wp8CfYwDje/K8kOM9xxjcs5Ih3yv9cK8eGzGQ36SCTpbKgG4FGcuUOdQOs8iPe9KVdevcJJz7eQe5Lb2cbCudwjGhHK3JIsYmnpj5OO+n16uyqwpvCEtwWWda5QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QK3R5vnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QK3R5vnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE62C116C6;
	Tue, 27 Jan 2026 04:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486653;
	bh=9pVU8MUotnkCNLeByOxC49aIDLFe90mtv8hIZu3xQ8w=;
	h=Date:To:From:Subject:From;
	b=QK3R5vnLWm/dkLAMcT7LoNDCeeRhOqGPRNxGlNpryQbAkMwF1zGq8Pcaii50aq/st
	 IwsvzrdMCbdxmMY6BoceRzgZO9JGZC0trqR2r/1m/IMlNpF1lTfFfijLULKfEoahEr
	 KPLt+/deO2QpYaxNKgvjskwZBWePZKpm6DhgcJ6A=
Date: Mon, 26 Jan 2026 20:04:12 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,sj@kernel.org,shakeel.butt@linux.dev,mkoutny@suse.com,hannes@cmpxchg.org,corbet@lwn.net,gthelen@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-v1-remove-folio_memcg_lock-doc-reference.patch removed from -mm tree
Message-Id: <20260127040412.EBE62C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-v1: remove folio_memcg_lock() doc reference
has been removed from the -mm tree.  Its filename was
     memcg-v1-remove-folio_memcg_lock-doc-reference.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg-v1: remove folio_memcg_lock() doc reference
Date: Thu, 1 Jan 2026 14:55:51 -0800

Commit a29c0e4b2e86 ("memcg-v1: remove memcg move locking code") removed
folio_memcg_lock().  Delete the final lingering documentation reference.

Link: https://lkml.kernel.org/r/20260101225552.3423108-1-gthelen@google.com
Fixes: a29c0e4b2e86 ("memcg-v1: remove memcg move locking code")
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-v1-remove-folio_memcg_lock-doc-reference
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -311,9 +311,8 @@ Lock order is as follows::
 
   folio_lock
     mm->page_table_lock or split pte_lock
-      folio_memcg_lock (memcg->move_lock)
-        mapping->i_pages lock
-          lruvec->lru_lock.
+      mapping->i_pages lock
+        lruvec->lru_lock.
 
 Per-node-per-memcgroup LRU (cgroup's private LRU) is guarded by
 lruvec->lru_lock; the folio LRU flag is cleared before
_

Patches currently in -mm which might be from gthelen@google.com are


