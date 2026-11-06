Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793928078;
	b=IeoXZjoUQyYa0RBDovKwxZMFhjb3U8UXjmeU3KYSTNV/atayUeLZTxf781irW651djKZ
	 imkrW8hd5NK2+s3VFlv5o4ShQBOgN3J3F9ERjSs36KTaN7t0N7OJi440mgZSSkxu3SmjE
	 SgmqUKWOvdR72an+mlmuQG76g3FzQHnYznyRR1VC5p9lWY8B/irKmVw6C77DoTf8jkFMe
	 z4tKaZscG011W7AnXOFFxI/DJ4tDzvM4pR/EJJd5cFndyhjsXJEuaXna5fnD2TPCWVEPr
	 V5byB/XQP1nWF92T6+mqCjkkpgUJb5wX2zVjf3CPRZ5nbSCOrEHZTHK9VBJHK+xaj0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793928078;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=uGvkXJwqimlx/KgXYXRSDWpYEOZcolxmrwQUpCD9U6M=;
	b=VWegXHnyEKOockkgtkAuwEF6K7x1X8l9075EX7J81KG3zezJU4cnY7CUOpm1ghMqKVpi
	 jDkXFnhMzzeAMMypLT0Jti/08A/+OvRrTGsaDIW3sZ9eg6tpfTDghsDaGfH4U9/+7RDTi
	 7KBLawmejlKXPCNnufj1CUCVraYxGwJeTPL8NraKEQQmCoP0xyzKfPIYjUeS61t8DOP3o
	 uwl9gkHB2JVr48B9WRl0CVmVh+S3BbXEDBx/Fiwata7yromMOjxsFdUGnSDU8ZfXbIy9m
	 J3r3/RmDSSUWQkU74nkQBi1IPzfSS9xZzWCwffKbVDedI1cueFQmuXCmAuu3rhGxswQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AUI3jpOC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268F5606A31B
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 01:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AUI3jpOC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919541F0089F;
	Fri,  6 Nov 2026 01:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793928077;
	bh=uGvkXJwqimlx/KgXYXRSDWpYEOZcolxmrwQUpCD9U6M=;
	h=Date:To:From:Subject;
	b=AUI3jpOCCmES7FoLU7qmDCH7KgZXm5hWUMiirEp3GGz6foS+tH0kdqQwWv3RPf37H
	 M16RjlSvyBbduSUVjZ0YML1sGpdqWQbrEdX+XYRCrunDmv5otN+o4o+IPCbGloYk49
	 kOpt6q8L826UavmAw+Phk47gBZ7agT0pgHI52kG8=
Date: Thu, 05 Nov 2026 17:21:17 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lkp@intel.com,
	hao.ge@linux.dev,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch added to mm-new branch
Message-Id: <20261106012117.919541F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: alloc_tag: force inline the allocation tracing check
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: alloc_tag: force inline the allocation tracing check
Date: Thu, 05 Nov 2026 17:18:09 -0800

alloc_tag_trace_enabled() is declared inline, but the compiler can
still emit an out-of-line copy. Force it inline,

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202611052344.mDV2DB89-lkp@intel.com/
Cc: Abhishek Bapat <abhishekbapat@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>
---

 include/linux/alloc_tag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix
+++ a/include/linux/alloc_tag.h
@@ -161,7 +161,7 @@ static inline bool alloc_tag_is_traced(c
 	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
 }
 
-static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
+static __always_inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
 {
 	if (static_branch_unlikely(&alloc_tag_trace_key))
 		return tag && alloc_tag_is_traced(tag);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-use-one-node-set-for-interleave-weights.patch
maple_tree-fix-reverse-iterator-state-when-the-root-disappears.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix.patch
iommufd-enforce-memfd-write-seals-for-file-mappings.patch
fault-inject-initialize-random-state-on-first-use.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

