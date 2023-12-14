Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1E6697AB
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 19:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zQIQBYwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BADDC433C8;
	Thu, 14 Dec 2023 19:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702582911;
	bh=rZGMO6jataU2hgPAnMMZzTGSTGRfL3R+Vm+HoaZpyNw=;
	h=Date:To:From:Subject:From;
	b=zQIQBYwHp0F4w1H73ki0PtcsLhGITcmVBnKM6yMxKqFEckFX+HDYkT0CYpC7W/rfB
	 TFWaRvZn8UdXSGmFP9ulyXCQ87IaBbwk7jXzq0Kuc4jXJ6nk9u9CIe9Rv+K3EEUyn3
	 mJ7WO39rsXmWKGgA6z4CCycv7P2LYxgXNnahHIhI=
Date: Thu, 14 Dec 2023 11:41:50 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,James.Bottomley@HansenPartnership.com,bot@kernelci.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-secretmem-floor-the-memory-size-to-the-multiple-of-page_size.patch added to mm-nonmm-unstable branch
Message-Id: <20231214194151.0BADDC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: secretmem: floor the memory size to the multiple of page_size
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-secretmem-floor-the-memory-size-to-the-multiple-of-page_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-secretmem-floor-the-memory-size-to-the-multiple-of-page_size.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: selftests: secretmem: floor the memory size to the multiple of page_size
Date: Thu, 14 Dec 2023 15:19:30 +0500

The "locked-in-memory size" limit per process can be non-multiple of
page_size.  The mmap() fails if we try to allocate locked-in-memory with
same size as the allowed limit if it isn't multiple of the page_size
because mmap() rounds off the memory size to be allocated to next multiple
of page_size.

Fix this by flooring the length to be allocated with mmap() to the
previous multiple of the page_size.

Link: https://lkml.kernel.org/r/20231214101931.1155586-1-usama.anjum@collabora.com
Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memfd_secret.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/memfd_secret.c~selftests-secretmem-floor-the-memory-size-to-the-multiple-of-page_size
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -62,6 +62,9 @@ static void test_mlock_limit(int fd)
 	char *mem;
 
 	len = mlock_limit_cur;
+	if (len % page_size != 0)
+		len = (len/page_size) * page_size;
+
 	mem = mmap(NULL, len, prot, mode, fd, 0);
 	if (mem == MAP_FAILED) {
 		fail("unable to mmap secret memory\n");
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-secretmem-floor-the-memory-size-to-the-multiple-of-page_size.patch

