Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD5A1877;
	Sat, 30 Mar 2024 03:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711767671; cv=none; b=tm0ibajUTLkOUjM6bAU23EP13rtB3bqKrXat+uaxEroSdvFxUo51+3DW+GVRAL+hq2WaMZTBxLeTNlOQm9VRuLsLfSn7iHQPsw/UR/8BUK7A785MzHhAHA5LMHL4qhEilieZc/Ao4AJ+GiFEA/X/748UewP7Nlggym6tP88n1x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711767671; c=relaxed/simple;
	bh=9s+WOMBAk+hqlNPN4XO0Ywl6yp3mwYmBRWGiItBx6oI=;
	h=Date:To:From:Subject:Message-Id; b=QG5wQG7ApegTFNIh4nwVwn4grt25OsDpTcetGWB2Pyxba3E33H5j7rdZGJLVX9f01WVPxbiuMI3y2GhF3oDTn39FjsKE8oz23R7pdBQBk2REfIXUwHPstEcnj0If7GYU0Q39cXtYlSyTsmcvjhsNorjWdjBzjOTGSX6hOOyA+x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ar2VlvEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ar2VlvEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B925C433F1;
	Sat, 30 Mar 2024 03:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711767670;
	bh=9s+WOMBAk+hqlNPN4XO0Ywl6yp3mwYmBRWGiItBx6oI=;
	h=Date:To:From:Subject:From;
	b=Ar2VlvEcfsrh6jrEyaee2wzUG2teeP4P8ktwjjaif6zcv7VMYl5FyQEGKi5XCr7SY
	 o9wK8U+yd7P6RK6109SCmofl7t2SDI7qK2egwExHU3BTImKBhjZa1kNV1JSjhRxOgO
	 W+/kDLwfHEE+DdlCCuAuqVB05vW9pCDPswi8xjRA=
Date: Fri, 29 Mar 2024 20:01:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,david@redhat.com,axelrasmussen@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-include-stringsh-for-ffsl.patch added to mm-hotfixes-unstable branch
Message-Id: <20240330030110.5B925C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: include strings.h for ffsl
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-include-stringsh-for-ffsl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-include-stringsh-for-ffsl.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Edward Liaw <edliaw@google.com>
Subject: selftests/mm: include strings.h for ffsl
Date: Fri, 29 Mar 2024 18:58:10 +0000

Got a compilation error on Android for ffsl after 91b80cc5b39f
("selftests: mm: fix map_hugetlb failure on 64K page size systems")
included vm_util.h.

Link: https://lkml.kernel.org/r/20240329185814.16304-1-edliaw@google.com
Fixes: af605d26a8f2 ("selftests/mm: merge util.h into vm_util.h")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-include-stringsh-for-ffsl
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -3,7 +3,7 @@
 #include <stdbool.h>
 #include <sys/mman.h>
 #include <err.h>
-#include <string.h> /* ffsl() */
+#include <strings.h> /* ffsl() */
 #include <unistd.h> /* _SC_PAGESIZE */
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
_

Patches currently in -mm which might be from edliaw@google.com are

selftests-mm-include-stringsh-for-ffsl.patch

