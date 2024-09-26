Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405E1184544;
	Thu, 26 Sep 2024 21:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384662; cv=none; b=XIRGKxEJW7Yjm8YbbIe7zYeqt0gsjsS+Fxf2gRE4eiUpkE6+A0lhyEh+AWlqVUlHzAFZdj020WNHKoNWWdahvluxK15qhyY/b+KiPmlrnxdEQfZ7RpKpfxOMIbF66KpeqgMEHEInc6rqsPbMM1IPFjxyu4m6SvzUu6s/Vaqdy5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384662; c=relaxed/simple;
	bh=oZ77fK3WLlMadIj9uxk5jsRHxUznuNrYBD5aryV2Z8s=;
	h=Date:To:From:Subject:Message-Id; b=OWKDwhh9Ptdkmr7DGYzHtTpnuFqRjCndYB/dfTznZ8nGNUQNlsPR97Hu5uSz9lRur7Nad1eAIcsDjUCheRGE/Xtp2ksoPAp1SohuUk0wXREi4KXbKfj1aldluaTFYB8OkX+UDtykvqzeWYeLoLI7TgeyQWtOp4upr9jSFGW+3WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VEU+ZBYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VEU+ZBYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10343C4CEC5;
	Thu, 26 Sep 2024 21:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384662;
	bh=oZ77fK3WLlMadIj9uxk5jsRHxUznuNrYBD5aryV2Z8s=;
	h=Date:To:From:Subject:From;
	b=VEU+ZBYrgUxx9qHhIll8P9BXqO6aEuhvnrjwawtZgQMx21sXL5rG6vNEjLKo/emkX
	 9F8TUdk7uahB0P9CeNCSYqC3HWMwycbOxFPu8ylUFSX1T7XsVNlHBYcEIoSGtDO22U
	 lVMGvfFgXlC81g4rxndusvtWxKncF+SqUzOxmgFE=
Date: Thu, 26 Sep 2024 14:04:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,skhan@linuxfoundation.org,jhubbard@nvidia.com,david@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kselftests-mm-fix-wrong-__nr_userfaultfd-value.patch removed from -mm tree
Message-Id: <20240926210422.10343C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftests: mm: fix wrong __NR_userfaultfd value
has been removed from the -mm tree.  Its filename was
     kselftests-mm-fix-wrong-__nr_userfaultfd-value.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: kselftests: mm: fix wrong __NR_userfaultfd value
Date: Mon, 23 Sep 2024 10:38:36 +0500

grep -rnIF "#define __NR_userfaultfd"
tools/include/uapi/asm-generic/unistd.h:681:#define __NR_userfaultfd 282
arch/x86/include/generated/uapi/asm/unistd_32.h:374:#define
__NR_userfaultfd 374
arch/x86/include/generated/uapi/asm/unistd_64.h:327:#define
__NR_userfaultfd 323
arch/x86/include/generated/uapi/asm/unistd_x32.h:282:#define
__NR_userfaultfd (__X32_SYSCALL_BIT + 323)
arch/arm/include/generated/uapi/asm/unistd-eabi.h:347:#define
__NR_userfaultfd (__NR_SYSCALL_BASE + 388)
arch/arm/include/generated/uapi/asm/unistd-oabi.h:359:#define
__NR_userfaultfd (__NR_SYSCALL_BASE + 388)
include/uapi/asm-generic/unistd.h:681:#define __NR_userfaultfd 282

The number is dependent on the architecture. The above data shows that:
x86	374
x86_64	323

The value of __NR_userfaultfd was changed to 282 when asm-generic/unistd.h
was included.  It makes the test to fail every time as the correct number
of this syscall on x86_64 is 323.  Fix the header to asm/unistd.h.

Link: https://lkml.kernel.org/r/20240923053836.3270393-1-usama.anjum@collabora.com
Fixes: a5c6bc590094 ("selftests/mm: remove local __NR_* definitions")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~kselftests-mm-fix-wrong-__nr_userfaultfd-value
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -15,7 +15,7 @@
 #include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <math.h>
-#include <asm-generic/unistd.h>
+#include <asm/unistd.h>
 #include <pthread.h>
 #include <sys/resource.h>
 #include <assert.h>
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


