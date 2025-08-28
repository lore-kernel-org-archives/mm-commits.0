Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB8979DA
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 23:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756422128; cv=none; b=QPxejf8moP1/xJPZ+LdQm+GG+sPonrBa7aL9FV4dZ9U40KS3AILO/fzo7bxw2uY3mNbDnvnnriGPUwSP+0bndXZ4FKcFKTw/GuAcOlDFKkdf/0JMMc+cT0otRV7xyq8ofXUk3DFXWlHvAZPJuhza5gvSioAOv9OUiLJwBy28S7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756422128; c=relaxed/simple;
	bh=ifjBd+krHnXd2d+4v2YrIpZ4V0GNDMzOa68nKfXEPnk=;
	h=Date:To:From:Subject:Message-Id; b=rW7F9lzV8WF0pxz+oCTnLDkNx3SG3U9GS+e17Ldwh8P9M+2mk0bSI28fRfV8twI8G16E41iitj8GNmPTUaDfyll/+YpPqciVLamYmizIno+8eDSZs+LHZttof2mVn5ccrwcV0wmvX7a6XDCwHPa1ZE2fhowdsQZ6obmIP+nH6xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F3xQJkv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F3xQJkv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFE0C4CEEB;
	Thu, 28 Aug 2025 23:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756422127;
	bh=ifjBd+krHnXd2d+4v2YrIpZ4V0GNDMzOa68nKfXEPnk=;
	h=Date:To:From:Subject:From;
	b=F3xQJkv0thDm66OUKcG1JQaEg4OwwbZnhCy5MgOiZj5hchPhgETx7AHjAilYmbNmi
	 z9LA9sOf5uXvmUW3jR9u9ufcbjy+puA3Se3KkChmvZpPubYkRituvn4ZGJEM+jmgPl
	 m/WC7lh4zrRrqcjP/E+Pt1pTd+w7eECc84g0acYA=
Date: Thu, 28 Aug 2025 16:02:06 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-include-implement-a-couple-of-atomic_t-ops.patch added to mm-new branch
Message-Id: <20250828230207.6EFE0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/include: implement a couple of atomic_t ops
has been added to the -mm mm-new branch.  Its filename is
     tools-include-implement-a-couple-of-atomic_t-ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-include-implement-a-couple-of-atomic_t-ops.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Brendan Jackman <jackmanb@google.com>
Subject: tools/include: implement a couple of atomic_t ops
Date: Thu, 28 Aug 2025 12:27:58 +0000

Patch series "tools: testing: Use existing atomic.h for vma/maple tests",
v2.

De-duplicating this lets us delete a bit of code. 

Ulterior motive: I'm working on a new set of the userspace-based unit
tests, which will need the atomics API too.  That would involve even more
duplication, so while the win in this patchset alone is very minimal, it
looks a lot more significant with my other WIP patchset.

I've tested these commands:

make -C tools/testing/vma -j 
tools/testing/vma/vma

make -C tools/testing/radix-tree -j
tools/testing/radix-tree/maple

Note the EXTRA_CFLAGS patch is actually orthogonal, let me know if you'd
prefer I send it separately.


This patch (of 4):

The VMA tests need an operation equivalent to atomic_inc_unless_negative()
to implement a fake mapping_map_writable().  Adding it will enable them to
switch to the shared atomic headers and simplify that fake implementation.

In order to add that, also add atomic_try_cmpxchg() which can be used to
implement it.  This is copied from Documentation/atomic_t.txt.  Then,
implement atomic_inc_unless_negative() itself based on the
raw_atomic_dec_unless_positive() in
include/linux/atomic/atomic-arch-fallback.h.

There's no present need for a highly-optimised version of this (nor any
reason to think this implementation is sub-optimal on x86) so just
implement this with generic C, no x86-specifics.

Link: https://lkml.kernel.org/r/20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com
Link: https://lkml.kernel.org/r/20250828-b4-vma-no-atomic-h-v2-1-02d146a58ed2@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/atomic.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/tools/include/linux/atomic.h~tools-include-implement-a-couple-of-atomic_t-ops
+++ a/tools/include/linux/atomic.h
@@ -12,4 +12,26 @@ void atomic_long_set(atomic_long_t *v, l
 #define  atomic_cmpxchg_release         atomic_cmpxchg
 #endif /* atomic_cmpxchg_relaxed */
 
+static inline bool atomic_try_cmpxchg(atomic_t *ptr, int *oldp, int new)
+{
+	int ret, old = *oldp;
+
+	ret = atomic_cmpxchg(ptr, old, new);
+	if (ret != old)
+		*oldp = ret;
+	return ret == old;
+}
+
+static inline bool atomic_inc_unless_negative(atomic_t *v)
+{
+	int c = atomic_read(v);
+
+	do {
+		if (unlikely(c < 0))
+			return false;
+	} while (!atomic_try_cmpxchg(v, &c, c + 1));
+
+	return true;
+}
+
 #endif /* __TOOLS_LINUX_ATOMIC_H */
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-remove-is_migrate_highatomic.patch
mm-page_alloc-harmonize-should_compact_retry-type.patch
tools-include-implement-a-couple-of-atomic_t-ops.patch
tools-testing-allow-importing-arch-headers-in-sharedmk.patch
tools-testing-support-extra_cflags-in-sharedmk.patch
tools-testing-use-existing-atomich-for-vma-maple-tests.patch

