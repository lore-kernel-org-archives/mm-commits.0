Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E323A1E94
	for <mm-commits@vger.kernel.org>; Sat,  3 Jan 2026 18:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767464270; cv=none; b=CQRDQc6pd5uAV2o61TjI6zbmBkPw91INq//DTYMOHOrxKmfwJm1+16cM8g6jMI72rR+Bi0qpD639yrrvAZyaAN4/OF6NYziR6Uk1mTti5T+iTX0uGPzG+wXFdzMRXCrApPAnB4gyuOYgr8FUat6Nbq9cJxp6d7eesAeKuUd+zgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767464270; c=relaxed/simple;
	bh=p1gh1oIF9nYgE7CmPdPDnCF4ktRpMQwY0qY4F1phUXI=;
	h=Date:To:From:Subject:Message-Id; b=DZWj7yypDE6fZFkbU4S9dOtMqgVRmiSJpOIf9pmRP1XscKF6omAXJC1t1+Zamryap1m3gNNpH05xFxKQgRcvsM4s48oxViNnjvu+Vf9luFP6q9kzdc0DdVocx4V8TiOZrlcjy4CqhwznNxgATzU0MqZtfgu6zhW251wypSAlcEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sNimlUge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sNimlUge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93C2C113D0;
	Sat,  3 Jan 2026 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767464269;
	bh=p1gh1oIF9nYgE7CmPdPDnCF4ktRpMQwY0qY4F1phUXI=;
	h=Date:To:From:Subject:From;
	b=sNimlUge0ojrElNEIJOrnjv3r7+uFHZZfzAEKUCwNBtmj6HQOI0ZoUiDiz7S+I7dy
	 3FzlLhUVDjc7h2bguzLQJGSYwiFbYf7FZCI3wpmhPMGQFp2eJU0/IfQ1lCGmNeWmDc
	 AArql7sPs4l8Nfr/MqYh1BuiELWK6gmGGLTQiTcM=
Date: Sat, 03 Jan 2026 10:17:49 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,sj@kernel.org,shakeel.butt@linux.dev,mkoutny@suse.com,hannes@cmpxchg.org,corbet@lwn.net,gthelen@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-v1-remove-folio_memcg_lock-doc-reference.patch added to mm-new branch
Message-Id: <20260103181749.A93C2C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-v1: remove folio_memcg_lock() doc reference
has been added to the -mm mm-new branch.  Its filename is
     memcg-v1-remove-folio_memcg_lock-doc-reference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-v1-remove-folio_memcg_lock-doc-reference.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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

memcg-v1-remove-folio_memcg_lock-doc-reference.patch

