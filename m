Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDA379DA
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 23:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756422129; cv=none; b=RBSz/Mapyx147Nyzus0YL4BirulY7i+PkSxpZgFkHLsGLB84s5AaWcA8VqQGBbDNMFA8tzM0pVnj1HV4NC6bzlAvXU1gmNJsZcAEZGYlzioY0er7EgPO4iGzaSujV3731Sc8zpBjEuu66gk8YKwSUswy7IO02n4JTAtlKbKgf0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756422129; c=relaxed/simple;
	bh=wobaDZMEnA3DwhOAJEqJ0c7kgPHQkBajSW6kT+y8MrM=;
	h=Date:To:From:Subject:Message-Id; b=nxj068tlNFSnf0vhtID963fQgoqfa+79s/ws9Idw7k19R84fi2c5SFlNIyvevHxD/RW3whPXMDylOxKveaerEp6q7PKloAsSXbhwPto3ScAC48LMooOG2B/JGAWhhzjy0JliNsZsrHcjqBkxuDCPkojcONT59mUsTvNDFd6QmnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BsToWqAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BsToWqAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695A0C4CEEB;
	Thu, 28 Aug 2025 23:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756422129;
	bh=wobaDZMEnA3DwhOAJEqJ0c7kgPHQkBajSW6kT+y8MrM=;
	h=Date:To:From:Subject:From;
	b=BsToWqAuoSyWSpjEANQJpZFMa/47pIYVXW4BX8D1qO7g16KZq5Jo8gfv03Xuo/u0d
	 oKDouMMQtnE/GXkQuUTUIW3kMh2AnFrx4vIc8FMvGOXFhifbd0K8u9nr6Wzc+6YIig
	 fQDm95kEN1c+tUri2/QutoAZn1WD+d1DWM0TzlEo=
Date: Thu, 28 Aug 2025 16:02:08 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-allow-importing-arch-headers-in-sharedmk.patch added to mm-new branch
Message-Id: <20250828230209.695A0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: testing: allow importing arch headers in shared.mk
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-allow-importing-arch-headers-in-sharedmk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-allow-importing-arch-headers-in-sharedmk.patch

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
Subject: tools: testing: allow importing arch headers in shared.mk
Date: Thu, 28 Aug 2025 12:27:59 +0000

There is an arch/ tree under tools.  This contains some useful stuff, to
make that available, add it to the -I flags.  This requires $(SRCARCH),
which is provided by Makefile.arch, so include that..

There still aren't that many headers so also just smush all of them into
SHARED_DEPS instead of starting to do any header dependency hocus pocus.

Link: https://lkml.kernel.org/r/20250828-b4-vma-no-atomic-h-v2-2-02d146a58ed2@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/shared.mk |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/shared/shared.mk~tools-testing-allow-importing-arch-headers-in-sharedmk
+++ a/tools/testing/shared/shared.mk
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
+include ../../scripts/Makefile.arch
 
-CFLAGS += -I../shared -I. -I../../include -I../../../lib -g -Og -Wall \
+CFLAGS += -I../shared -I. -I../../include -I../../arch/$(SRCARCH)/include \
+	  -I../../../lib -g -Og -Wall \
 	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
 LDFLAGS += -fsanitize=address -fsanitize=undefined
 LDLIBS += -lpthread -lurcu
@@ -11,6 +13,7 @@ SHARED_DEPS = Makefile ../shared/shared.
 	generated/bit-length.h generated/autoconf.h \
 	../../include/linux/*.h \
 	../../include/asm/*.h \
+	../../arch/$(SRCARCH)/include/asm/*.h \
 	../../../include/linux/xarray.h \
 	../../../include/linux/maple_tree.h \
 	../../../include/linux/radix-tree.h \
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-remove-is_migrate_highatomic.patch
mm-page_alloc-harmonize-should_compact_retry-type.patch
tools-include-implement-a-couple-of-atomic_t-ops.patch
tools-testing-allow-importing-arch-headers-in-sharedmk.patch
tools-testing-support-extra_cflags-in-sharedmk.patch
tools-testing-use-existing-atomich-for-vma-maple-tests.patch

