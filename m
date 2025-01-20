Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED0B8BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337170; cv=none; b=sFXN6xc78BNofXLOiJxW4Z31blNA3q9eJBYFFtJoNnjIMnZ6qyVTgF+5d2P9u1skwogVFmplBZ5SNb2lHdsRzEO8zZlrDMfSd3UQeqbS6O+5Cq8vcigFe9opIp6jKqtEsC4IM3QhMig7WqCjVBROQCzy0JtH1sd3RuZBIZaBL+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337170; c=relaxed/simple;
	bh=7eyTnRtrA5Lw+AkYbitE74e9Sjr499pF6v8YGAEqOUA=;
	h=Date:To:From:Subject:Message-Id; b=aryJmwHEojSXYvy/d/HGAWlqG9bhvY5U1wVYQkCBU3/G3sVWhrS/oyhG1qsjj+WPrp/f5ZRqZHMGtyqNRtDgnIjk3nu68NNxWXs54HulZfOPZ4X3xOY+Kcxfo/74iCmjz12dfjPiOvmsYWfwy0Qs2apZLkGvFYU5+x1XE1xOm+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OPdJPNs7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OPdJPNs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C66C4CED6;
	Mon, 20 Jan 2025 01:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337169;
	bh=7eyTnRtrA5Lw+AkYbitE74e9Sjr499pF6v8YGAEqOUA=;
	h=Date:To:From:Subject:From;
	b=OPdJPNs7CFoetyu0UPdnTpSUT2LqbBZ7oFykVifzpf2Voe67wTrwdeBp1BXTLfmMs
	 5n2EqSYnhow0kKmXx0sxIpxDSNoeazNwC0aQgMuf4YZrexdmfS4lY+U2nM9qiY07Vp
	 FgQ/gzzQnwDIdy43hzb9DbtiybXrWgIJLblK9Z/w=
Date: Sun, 19 Jan 2025 17:39:29 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,sfr@canb.auug.org.au,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,liam.howlett@oracle.com,david@redhat.com,boqun.feng@gmail.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] seqlock-add-missing-parameter-documentation-for-raw_seqcount_try_begin.patch removed from -mm tree
Message-Id: <20250120013929.96C66C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: seqlock: add missing parameter documentation for raw_seqcount_try_begin()
has been removed from the -mm tree.  Its filename was
     seqlock-add-missing-parameter-documentation-for-raw_seqcount_try_begin.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: seqlock: add missing parameter documentation for raw_seqcount_try_begin()
Date: Thu, 16 Jan 2025 10:27:30 -0800

Add missing documentation for raw_seqcount_try_begin() start parameter.

Link: https://lkml.kernel.org/r/20250116182730.801497-1-surenb@google.com
Fixes: dba4761a3e40 ("seqlock: add raw_seqcount_try_begin")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20250116170522.23e884d5@canb.auug.org.au/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seqlock.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/seqlock.h~seqlock-add-missing-parameter-documentation-for-raw_seqcount_try_begin
+++ a/include/linux/seqlock.h
@@ -322,6 +322,7 @@ SEQCOUNT_LOCKNAME(mutex,        struct m
  * raw_seqcount_try_begin() - begin a seqcount_t read critical section
  *                            w/o lockdep and w/o counter stabilization
  * @s: Pointer to seqcount_t or any of the seqcount_LOCKNAME_t variants
+ * @start: count to be passed to read_seqcount_retry()
  *
  * Similar to raw_seqcount_begin(), except it enables eliding the critical
  * section entirely if odd, instead of doing the speculation knowing it will
_

Patches currently in -mm which might be from surenb@google.com are


