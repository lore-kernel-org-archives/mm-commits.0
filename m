Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07C41DF73A
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896519; cv=none; b=u+X7UePBtYxp9c6BQHT471FSevL1dxJTDARSm/nrYZcqIb3BbhXkr+zXDvhF8+sCQu+EW6iepVTkhRLCyGdz2rOqy9hq7JXQfiVYFnpJBZ+t8GtwY5NsmRpSZiIT0Py/HtIa8AK/vw3RBohyCi1Q2x25GsjePBJkA9XmXlMggZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896519; c=relaxed/simple;
	bh=Naq2X6qFsAYeTdtOnrPqTnI/cX1xTjTAO8totkEI//0=;
	h=Date:To:From:Subject:Message-Id; b=YA0801GVWOj6heK0+WHPK1mu1Y/hCvxZxGMXyRIAYENBqKLuaKBgk6dOx+V4+YTHIJ1uBGWtegVfmRHFMwMYosKVELJXf+1d9m/MWQiGYKrJULXMGPj4YET70WpIs+PK99QRZWwMFzdjA2B6hiG9UDHPyh17VEwMr+9cqCCbRDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2thOFwbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2thOFwbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDCFC4CEF1;
	Sat, 31 Jan 2026 21:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896519;
	bh=Naq2X6qFsAYeTdtOnrPqTnI/cX1xTjTAO8totkEI//0=;
	h=Date:To:From:Subject:From;
	b=2thOFwbJuVev2nlvJaBJZM/8BM43hyQHGeW7+SDG/sGtRcAIYlUFqw+hARMYskRi6
	 zVqB07S5vuCCh0KUyDVkLnXbXMsiobff5jOSJ6dcoH3UgrniLHSdzFRY3bzFnxqoVM
	 v+Jf4zQ9I89LA1MP9/4EZ17WHqD7kohjBHY+V83c=
Date: Sat, 31 Jan 2026 13:55:18 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch removed from -mm tree
Message-Id: <20260131215519.1DDCFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix
has been removed from the -mm tree.  Its filename was
     mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch

This patch was dropped because it was folded into mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix
Date: Mon Jan 26 12:08:39 PM PST 2026

fix typo, per Suren

Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix
+++ a/include/linux/mm_types.h
@@ -1023,7 +1023,7 @@ struct vm_area_struct {
 	 *
 	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
 	 * write-locking or detaching a VMA is waiting on readers to
-	 * exit. IMPORTANT - as above, no ruther readers can increment the
+	 * exit. IMPORTANT - as above, no further readers can increment the
 	 * reference count.
 	 *
 	 * NOTE: Unstable RCU readers are allowed to read this.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

