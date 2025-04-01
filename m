Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E661DA62E
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 19:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743534382; cv=none; b=Pou9oPjUQxBmfeyVpHDi6/ZFHzffod9hdnBEPZfDgBl9CypiMsZqyq1GkzXJ517yNlxQ+VNybT+VI0f+oSX88qxEATXOYWEWM8gQXDIiMrbyLKB8bWIEP7Fl4wbbWgf1sXz+yZyne60Ngu4ZgnEHGC56WB+cYxNwcVkRVr8bWQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743534382; c=relaxed/simple;
	bh=ZyQjXzJoJAUQRc2w55xz1MvLW8btOlhtuS/kN8aoyf0=;
	h=Date:To:From:Subject:Message-Id; b=Ad5PR9pABx9p+XE8keWT9xWAMQeLAQjUO8525gTxer0tIPvVSFh5c1zB7GuA2UrBSb1Q0mmZBd4VkAL6ddKhptbQ3Qk1mDL8OGL7dDVF3RPbpWTJO/E3rCZ/4gjzNzg5HzbU/iH1lwySl2MxgkNoLqWxV0cweum/i/dVPZ0fVgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wujC0WSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wujC0WSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AE4C4CEE4;
	Tue,  1 Apr 2025 19:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743534381;
	bh=ZyQjXzJoJAUQRc2w55xz1MvLW8btOlhtuS/kN8aoyf0=;
	h=Date:To:From:Subject:From;
	b=wujC0WSpeTtV1B8Lx2zuqaxJf8m1cvdukuZcdC+PzfBp1XbLccJSuMFRrDxSeFJoU
	 fImUnDyWlXDvSJTbzlOG97wCUKkbk8nYNWXdBOlVu4CoN7tej8AV49PQ5L27qYX571
	 Rkymmptt6+Lt/IDo8luvdFpU9rRrBKINAzQ+WBps=
Date: Tue, 01 Apr 2025 12:06:20 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,aarcange@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20250401190621.48AE4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes.patch

This patch was dropped because it was folded into maintainers-add-myself-as-userfaultfd-reviewer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes
Date: Fri Mar 21 05:54:54 PM PDT 2025

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#37: FILE: MAINTAINERS:15228:
+F:	mm/userfaultfd.c
+F:	fs/userfaultfd.c

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#39: FILE: MAINTAINERS:15230:
+F:	include/uapi/linux/userfaultfd.h
+F:	include/asm-generic/pgtable_uffd.h

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#40: FILE: MAINTAINERS:15231:
+F:	include/asm-generic/pgtable_uffd.h
+F:	Documentation/admin-guide/mm/userfaultfd.rst

total: 0 errors, 3 warnings, 17 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/maintainers-add-myself-as-userfaultfd-reviewer.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes
+++ a/MAINTAINERS
@@ -15224,11 +15224,11 @@ MEMORY USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Peter Xu <peterx@redhat.com>
 S:	Maintained
-F:	mm/userfaultfd.c
+F:	Documentation/admin-guide/mm/userfaultfd.rst
 F:	fs/userfaultfd.c
-F:	include/uapi/linux/userfaultfd.h
 F:	include/asm-generic/pgtable_uffd.h
-F:	Documentation/admin-guide/mm/userfaultfd.rst
+F:	include/uapi/linux/userfaultfd.h
+F:	mm/userfaultfd.c
 F:	tools/testing/selftests/mm/uffd-*.[ch]
 
 MEMORY TECHNOLOGY DEVICES (MTD)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-myself-as-userfaultfd-reviewer.patch
maintainers-add-myself-as-userfaultfd-reviewer-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch

