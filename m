Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B9A146A73;
	Tue, 24 Sep 2024 23:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727219247; cv=none; b=W9o0VMEQGjz+LioM0Pou3hH5lsVePdVlaN9xI7LHC9vNFa8kIcO/5xiSmlZbUmzCjyk1qJooZPMGQyjrB8lAN56iijAeFcgFbByNXhjJW55SdES9aM+1bwRwDYGmxfuvTtF2BCzMURcWXrnZmA1O4XzbDCbKx6r3pNfYx0Vsf4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727219247; c=relaxed/simple;
	bh=vC6aDKJ6N8lOC042IhCs5Tj7l+oGTa2aNH48qAZSDno=;
	h=Date:To:From:Subject:Message-Id; b=AQSo2exixArP6NjERVYU9K9tAwSUgiL5kyIYIus1yoBhDsyzYTcfzlWAF5N4xw8rB2+WcgvWbo9Xgisn9PXFp2WAZe5kxGCnwX059FPguPulUGj9RaTw2U5TAhcrWkbweaS6yDBb7sFvTsgq7k46a3mZbozOhHqYhK8GnuyapAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UXxwi6tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UXxwi6tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE988C4CEC4;
	Tue, 24 Sep 2024 23:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727219245;
	bh=vC6aDKJ6N8lOC042IhCs5Tj7l+oGTa2aNH48qAZSDno=;
	h=Date:To:From:Subject:From;
	b=UXxwi6tl/K+15yQJzdrlFzWAGMjTuajAq91wNMwNh2Mjjhidm6XKyL7u3ZzhLJzsE
	 IEuWIYsG0Td+mZNd+82Cu3MsR1I/7QxH9CozXxPaqaEkwX/Ncnf0ef7ayRr3qwV2WY
	 gXXz1WCrpwDdeRXWa/DH7LbGgo9zdPY9QjDYClKs=
Date: Tue, 24 Sep 2024 16:07:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,skhan@linuxfoundation.org,jhubbard@nvidia.com,david@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftests-mm-fix-wrong-__nr_userfaultfd-value.patch added to mm-hotfixes-unstable branch
Message-Id: <20240924230725.CE988C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftests: mm: fix wrong __NR_userfaultfd value
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kselftests-mm-fix-wrong-__nr_userfaultfd-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftests-mm-fix-wrong-__nr_userfaultfd-value.patch

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

kselftests-mm-fix-wrong-__nr_userfaultfd-value.patch

