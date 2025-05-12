Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BEA18C00B
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011053; cv=none; b=JwtWVlIoQrSWG825aepqdbEDAaxPyloFwaa3Ce8WmtahYslZtliCnt9pOHMUfB3G2kWLHIlr/BNOyG34uYBqs67VErFAD5g5I0PNHbec5iR1+CgRJm/8Y2EomwR7ZE1XN+aPYKb8+nIC5TbHhFQ53KgQqtm0J8wrTnrFgiGJB+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011053; c=relaxed/simple;
	bh=2IRD5aUZGxmpyblJrXiW2SLlFVH6gr4QSww+E2B6adg=;
	h=Date:To:From:Subject:Message-Id; b=sUe3ADZjT0i/Vw/I4qASoq/IefOHSP0JVKMmmyyXOo/WxcmCMB+cBX4KeBG1cM6PgWzhN0w8Q476DLft8stUhGzkY9MYmn4tclfW3tGzd+JG4c3k/AFyPWGoQNgmsqI+SEe8H2ntJcXSXs2Z/HObiCemVvAaDMTQMAg17MKBCNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=acstIhH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="acstIhH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA5EC4CEE4;
	Mon, 12 May 2025 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011053;
	bh=2IRD5aUZGxmpyblJrXiW2SLlFVH6gr4QSww+E2B6adg=;
	h=Date:To:From:Subject:From;
	b=acstIhH70qs0id+wim4B1896UIrpieuTNS5OInjk5f+mhev/7mjCgPMT5KwS7C7Fy
	 njaxx/D0NIOheVlEoOF0uM4wzTWWwupRePD1I1SDV+sBwj/utTgg5UB3UJIwDYhBe9
	 R3Fquua+q4AXLO5HzJfRocpAI0OySkZAvXd2C/yI=
Date: Sun, 11 May 2025 17:50:52 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,corbet@lwn.net,avagin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-headers-uapi-sync-linux-fsh-with-the-kernel-sources.patch removed from -mm tree
Message-Id: <20250512005052.EEA5EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools headers UAPI: sync linux/fs.h with the kernel sources
has been removed from the -mm tree.  Its filename was
     tools-headers-uapi-sync-linux-fsh-with-the-kernel-sources.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrei Vagin <avagin@gmail.com>
Subject: tools headers UAPI: sync linux/fs.h with the kernel sources
Date: Mon, 24 Mar 2025 06:53:27 +0000

Required for a new PAGEMAP_SCAN test to verify guard region reporting.

Link: https://lkml.kernel.org/r/20250324065328.107678-3-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/linux/fs.h |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/tools/include/uapi/linux/fs.h~tools-headers-uapi-sync-linux-fsh-with-the-kernel-sources
+++ a/tools/include/uapi/linux/fs.h
@@ -40,6 +40,15 @@
 #define BLOCK_SIZE_BITS 10
 #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
 
+/* flags for integrity meta */
+#define IO_INTEGRITY_CHK_GUARD		(1U << 0) /* enforce guard check */
+#define IO_INTEGRITY_CHK_REFTAG		(1U << 1) /* enforce ref check */
+#define IO_INTEGRITY_CHK_APPTAG		(1U << 2) /* enforce app check */
+
+#define IO_INTEGRITY_VALID_FLAGS (IO_INTEGRITY_CHK_GUARD | \
+				  IO_INTEGRITY_CHK_REFTAG | \
+				  IO_INTEGRITY_CHK_APPTAG)
+
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
@@ -329,9 +338,16 @@ typedef int __bitwise __kernel_rwf_t;
 /* per-IO negation of O_APPEND */
 #define RWF_NOAPPEND	((__force __kernel_rwf_t)0x00000020)
 
+/* Atomic Write */
+#define RWF_ATOMIC	((__force __kernel_rwf_t)0x00000040)
+
+/* buffered IO that drops the cache after reading or writing data */
+#define RWF_DONTCACHE	((__force __kernel_rwf_t)0x00000080)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
-			 RWF_APPEND | RWF_NOAPPEND)
+			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
+			 RWF_DONTCACHE)
 
 #define PROCFS_IOCTL_MAGIC 'f'
 
@@ -347,6 +363,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_PFNZERO		(1 << 5)
 #define PAGE_IS_HUGE		(1 << 6)
 #define PAGE_IS_SOFT_DIRTY	(1 << 7)
+#define PAGE_IS_GUARD		(1 << 8)
 
 /*
  * struct page_region - Page region with flags
_

Patches currently in -mm which might be from avagin@gmail.com are


