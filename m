Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195BD15ADB4
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313705; cv=none; b=tlx03HnWe9vdfXxkPsKoQhibxt3kRAiPNOt9VELphzWvzt6C+b8sZZxeDKT5RR+WoRP2gbjlkk1caBNekf8m0AjMjLrpQoWy60+/2Mee3LmLgb6Xb4Fll5iSjZ/j2NM2W3h/ogWFxkOGu6IaiT7lG3F6kuVDBaeXB9MM/CP32lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313705; c=relaxed/simple;
	bh=WKssiPOxvXfkJV0lEMZfCAa3Q686oFq1cO2h5Vldq6o=;
	h=Date:To:From:Subject:Message-Id; b=QMA/axABSFF8zcIeDL0jGtOOqv5rRiafhdsp2eWzkFpB4VLTi/oqqXj+aRzYKOrRN4L8iIfYSptkYqtQBcZP0p2fVGdUECAM5y8JAFALPDGM6SDUbVQgOwYAXn5NVI/H3XtL62p0PU5RQcC5RY39iVAVzkutKTO3suxzCCgzIyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nvQZtCLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nvQZtCLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931EFC4CED0;
	Mon, 11 Nov 2024 08:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313704;
	bh=WKssiPOxvXfkJV0lEMZfCAa3Q686oFq1cO2h5Vldq6o=;
	h=Date:To:From:Subject:From;
	b=nvQZtCLDZZJ6CJ+doc67/P4ui6cWhaWOH53civK3/5RCPG+Blg/l+SSCIeSefK1b/
	 jHbEjAf667NTz3sxZLYivSN6rMFi6B1bevTnNsAqZBeORcSQuirSe10/zJ4ohw+MjO
	 5jvPR0F0TvnocMef6QrpYTQOp20RcDN3TRjTpwms=
Date: Mon, 11 Nov 2024 00:28:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabkba@suse.cz,vbabka@suse.cz,tsbogend@alpha.franken.de,surenb@google.com,skhan@linuxfoundation.org,sidhartha.kumar@oracle.com,shuah@kernel.org,richard.henderson@linaro.org,paulmck@kernel.org,muchun.song@linux.dev,mattst88@gmail.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jeffxu@chromium.org,jcmvbkbc@gmail.com,jannh@google.com,James.Bottomley@HansenPartnership.com,hch@infradead.org,deller@gmx.de,david@redhat.com,chris@zankel.net,brauner@kernel.org,arnd@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-update-tools-uapi-header-for-mman-commonh.patch removed from -mm tree
Message-Id: <20241111082824.931EFC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: testing: update tools UAPI header for mman-common.h
has been removed from the -mm tree.  Its filename was
     tools-testing-update-tools-uapi-header-for-mman-commonh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools: testing: update tools UAPI header for mman-common.h
Date: Mon, 28 Oct 2024 14:13:30 +0000

Import the new MADV_GUARD_INSTALL/REMOVE madvise flags.

Link: https://lkml.kernel.org/r/ada462fa73fa1defc114242e446ab625b8290b71.1730123433.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Jann Horn <jannh@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabkba@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/asm-generic/mman-common.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/include/uapi/asm-generic/mman-common.h~tools-testing-update-tools-uapi-header-for-mman-commonh
+++ a/tools/include/uapi/asm-generic/mman-common.h
@@ -79,6 +79,9 @@
 
 #define MADV_COLLAPSE	25		/* Synchronous hugepage collapse */
 
+#define MADV_GUARD_INSTALL 102		/* fatal signal on access to range */
+#define MADV_GUARD_REMOVE 103		/* unguard range */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
docs-mm-add-vma-locks-documentation-fix.patch

