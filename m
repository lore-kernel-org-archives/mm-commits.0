Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B914679DA
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 23:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756422131; cv=none; b=EQ2h6j4VMMrvUgOsyUlTPri5r688YVInPwl+jUQglbkt2HoPr5TEiuP2qcir14bABIEtXlb6POdqMtyXtzQcPJfESNXFaeAWE5OeXBjM4aMXcx+UlxuX+jt4bw+CKZ0U18c30xbvdENBEj4iWm/ZJjMn+L34kBP6Rh78pmPRb+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756422131; c=relaxed/simple;
	bh=B2db/jIfYhGRUfExZBHwxpqOydE2aTpvKwyk42P7fxQ=;
	h=Date:To:From:Subject:Message-Id; b=bobOwGYfoqwgrX1lgnEW6Mjj2zH1504Lai9SFLnDuLwUSfzBKlo5A5VgY10KMOVcqGOqJKfwvVwMKi1QglU6k+xT5iStMTuS9UvzGiR29kEy2Hf01+6ALNAnjJzX9o5ToTMJz36AXA4ys4QXEMgNcLJLBIAa3TsKavLcSAOd5+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1N+C2HeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1N+C2HeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D3CC4CEEB;
	Thu, 28 Aug 2025 23:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756422131;
	bh=B2db/jIfYhGRUfExZBHwxpqOydE2aTpvKwyk42P7fxQ=;
	h=Date:To:From:Subject:From;
	b=1N+C2HeZk2gm5HxWu7GhTDGw3EdlsyQ2r8ejXsXr7sgIppRyvdgEtQqiiWPRH4OM0
	 5GJtxbYuLA2JkFn7LKXCd6fS/e5VH5Ve64sIIBLFZcRbWYkoO9wuQooklU/u84GTKM
	 3upp+zo4FoGk6hWBls4uFMmS0MiuS1EqoBuNNUjM=
Date: Thu, 28 Aug 2025 16:02:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-support-extra_cflags-in-sharedmk.patch added to mm-new branch
Message-Id: <20250828230211.44D3CC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: testing: support EXTRA_CFLAGS in shared.mk
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-support-extra_cflags-in-sharedmk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-support-extra_cflags-in-sharedmk.patch

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
Subject: tools: testing: support EXTRA_CFLAGS in shared.mk
Date: Thu, 28 Aug 2025 12:28:00 +0000

This allows the user to set cflags when building tests that use this
shared build infrastructure.

For example, it enables building with -Werror so that patch-check scripts
will fail:

	make -C tools/testing/vma -j EXTRA_CFLAGS=-Werror

Link: https://lkml.kernel.org/r/20250828-b4-vma-no-atomic-h-v2-3-02d146a58ed2@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/shared.mk |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/shared/shared.mk~tools-testing-support-extra_cflags-in-sharedmk
+++ a/tools/testing/shared/shared.mk
@@ -4,6 +4,7 @@ include ../../scripts/Makefile.arch
 CFLAGS += -I../shared -I. -I../../include -I../../arch/$(SRCARCH)/include \
 	  -I../../../lib -g -Og -Wall \
 	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
+CFLAGS += $(EXTRA_CFLAGS)
 LDFLAGS += -fsanitize=address -fsanitize=undefined
 LDLIBS += -lpthread -lurcu
 LIBS := slab.o find_bit.o bitmap.o hweight.o vsprintf.o
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-remove-is_migrate_highatomic.patch
mm-page_alloc-harmonize-should_compact_retry-type.patch
tools-include-implement-a-couple-of-atomic_t-ops.patch
tools-testing-allow-importing-arch-headers-in-sharedmk.patch
tools-testing-support-extra_cflags-in-sharedmk.patch
tools-testing-use-existing-atomich-for-vma-maple-tests.patch

