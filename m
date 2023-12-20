Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B146B1D6A6;
	Wed, 20 Dec 2023 21:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bcGSDzIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CB2C433CA;
	Wed, 20 Dec 2023 21:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703108836;
	bh=jHy9CO2D6femDX9poeN61ivC2qjBG3Ghcv/4Max6mU8=;
	h=Date:To:From:Subject:From;
	b=bcGSDzIBx/OcA6i/OQ8o2Si7G4PA1vWga4qN0TBsC7VWdptsJ9V4CUbcQ8SFcPiRC
	 rqbu31B4AY9QuFuFCPM0tEDq6NrLYM+hjDsOWZakhXWuN+4bTNzJZnhQmcegEeCa5P
	 WNI5M96ynh831twEgNUTTcFN4NMyR3lU8TGn45AI=
Date: Wed, 20 Dec 2023 13:47:15 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,James.Bottomley@HansenPartnership.com,bot@kernelci.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-secretmem-floor-the-memory-size-to-the-multiple-of-page_size.patch removed from -mm tree
Message-Id: <20231220214716.76CB2C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: secretmem: floor the memory size to the multiple of page_size
has been removed from the -mm tree.  Its filename was
     selftests-secretmem-floor-the-memory-size-to-the-multiple-of-page_size.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

This was getting triggered on KernelCI regularly because of different
ulimit settings which wasn't multiple of the page_size.  Find logs
here: https://linux.kernelci.org/test/plan/id/657654bd8e81e654fae13532/
The bug in was present from the time test was first added.

Link: https://lkml.kernel.org/r/20231214101931.1155586-1-usama.anjum@collabora.com
Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Closes: https://linux.kernelci.org/test/plan/id/657654bd8e81e654fae13532/
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
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


