Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD2A762C9
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100706; cv=none; b=QeggmaYLDz+rDN+BjZRPrAnekRszDuef7WGvZVGfhRT7ti0n2EDUe9PWmqTr1xNGs5IlZV6c8CxsMZFlF9J1TlbgSghNd+PFs0NIcbeLef8/ZxY8ah1KKrURjR7+EzxtWsLhIYoT9EPP6zqoZa6MHOBAOdiP4kJcG3DlIXIV/8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100706; c=relaxed/simple;
	bh=kAUCCMLhcEr4yB0sTA6ifDBwmKYv4TySvfwNoGj7MLY=;
	h=Date:To:From:Subject:Message-Id; b=V+xOmmtwhMaBwac+PjYpWkwcf04XgS3Un4GNUEhVmeF+aqfzH/BLw18CCmCb+8r6UlCZLP9qH3fbpLuJl7PYvvlGTHRdVgi5olDCPdLMvWc+faWJXOmqMrUFEHbuxmbEteX/lRY5p2kjV9+YXD6R7GHlVzn29ZIVlFELZHII9z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N41WCVdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N41WCVdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663F2C32781;
	Fri, 26 Apr 2024 03:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100705;
	bh=kAUCCMLhcEr4yB0sTA6ifDBwmKYv4TySvfwNoGj7MLY=;
	h=Date:To:From:Subject:From;
	b=N41WCVddUtOgHkvLg2h9aek9Aki9ZHOV9y720JbRAwnQ6awv5S/WWt9a+fn4njomD
	 dMTuaPkZPFIUuPFf2QnNRloMSAAYFYnNC7KedJmuwECvh8bTHscMZlD1Z0D7Pqv1ya
	 zMai8tW6evITG0sAF/HsbIxtrKxoS3ZGrY5l9/XU=
Date: Thu, 25 Apr 2024 20:05:04 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fix-missing-vmalloch-includes-fix-4.patch removed from -mm tree
Message-Id: <20240426030505.663F2C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! fix missing vmalloc.h includes
has been removed from the -mm tree.  Its filename was
     fix-missing-vmalloch-includes-fix-4.patch

This patch was dropped because it was folded into fix-missing-vmalloch-includes.patch

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: fixup! fix missing vmalloc.h includes
Date: Wed, 3 Apr 2024 23:47:43 -0400

Few places were depending on sizes.h (convenience human-readable-units
size macros) iplicitly; fix

Link: https://lkml.kernel.org/r/20240327002152.3339937-1-kent.overstreet@linux.dev
Link: https://lkml.kernel.org/r/20240404034744.1664840-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/io.h |    1 +
 include/linux/io.h       |    1 +
 2 files changed, 2 insertions(+)

--- a/include/asm-generic/io.h~fix-missing-vmalloch-includes-fix-4
+++ a/include/asm-generic/io.h
@@ -9,6 +9,7 @@
 
 #include <asm/page.h> /* I/O is all done through memory accesses */
 #include <linux/string.h> /* for memset() and memcpy() */
+#include <linux/sizes.h>
 #include <linux/types.h>
 #include <linux/instruction_pointer.h>
 
--- a/include/linux/io.h~fix-missing-vmalloch-includes-fix-4
+++ a/include/linux/io.h
@@ -6,6 +6,7 @@
 #ifndef _LINUX_IO_H
 #define _LINUX_IO_H
 
+#include <linux/sizes.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/bug.h>
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

fix-missing-vmalloch-includes.patch
asm-generic-ioh-kill-vmalloch-dependency.patch
mm-slub-mark-slab_free_freelist_hook-__always_inline.patch
scripts-kallysms-always-include-__start-and-__stop-symbols.patch
fs-convert-alloc_inode_sb-to-a-macro.patch
rust-add-a-rust-helper-for-krealloc.patch
mempool-hook-up-to-memory-allocation-profiling.patch
mm-percpu-introduce-pcpuobj_ext.patch
mm-percpu-add-codetag-reference-into-pcpuobj_ext.patch
mm-vmalloc-enable-memory-allocation-profiling.patch
rhashtable-plumb-through-alloc-tag.patch
maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch
memprofiling-documentation.patch

