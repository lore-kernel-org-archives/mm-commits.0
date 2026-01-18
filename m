Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37189500976
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 20:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768769686; cv=none; b=cMsmfHZ0bnyaJ+a1n+kZW7hPDehkslBdGO9tHxJ1oFA+Q8n1Mr3Npn5UuYzMC58bdpH+/TuiDwz1h9UPcfHNSeFtIhIXMvk2r47zmLPAnS7tEQ+X/6DwgaloZ6IHE578alEMefB+S40uUMC/tc5Npgn/CeQr/h5VIjNuSMxuwDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768769686; c=relaxed/simple;
	bh=jvcKnp/e1eMV1QQtRXeQJVCgMx/Cjdp8g/BOQzNpW3w=;
	h=Date:To:From:Subject:Message-Id; b=VruWW764LZvD6KnGXWlIKG6A6A+oXRTZOR/QT0LVqO7tFYoMJ3mK2q8OhT6E1EUcujZyOzJpOze4v1pZSRbSexIYWlDODYMmpeFKeoVFCwNDZ7U2u/g+Rtz5cntWsTLflGR7X0wcKdLAbqbouKf9Lv3l60We2nV2+vBBETXm3ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZGcAXCes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZGcAXCes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46CEC116D0;
	Sun, 18 Jan 2026 20:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768769685;
	bh=jvcKnp/e1eMV1QQtRXeQJVCgMx/Cjdp8g/BOQzNpW3w=;
	h=Date:To:From:Subject:From;
	b=ZGcAXCese03rYxNLoEUVq8MzaFVG7oaY0V0go9E0krhvgiVxrtNFyoXvGcwKlN/GV
	 pi5pV61Kz70aMPmvqjLuusfgG334HYBlprjbMB+TsXxhUZpuyqMUzXQogFrgUFvb8R
	 9WhDWjHNFOzd0we17fqWnTxfXQKldQTk7+3lP/4Y=
Date: Sun, 18 Jan 2026 12:54:45 -0800
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,shuah@kernel.org,richard.weiyang@gmail.com,kraxel@redhat.com,akpm@linux-foundation.org,zishun.yi.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-udmabuf-fix-hugepage-size-calculation.patch added to mm-nonmm-unstable branch
Message-Id: <20260118205445.B46CEC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: udmabuf: fix hugepage size calculation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-udmabuf-fix-hugepage-size-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-udmabuf-fix-hugepage-size-calculation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: zishun yi <zishun.yi.dev@gmail.com>
Subject: selftests: udmabuf: fix hugepage size calculation
Date: Sun, 18 Jan 2026 21:51:26 +0800

udmabuf's test 6 and 7 is intended to verify the behavior of 2MB huge
pages migration, but the helper function still calculates the size using
standard (4KB) pages.

Link: https://lkml.kernel.org/r/20260118135126.102472-1-zishun.yi.dev@gmail.com
Signed-off-by: zishun yi <zishun.yi.dev@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/drivers/dma-buf/udmabuf.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/drivers/dma-buf/udmabuf.c~selftests-udmabuf-fix-hugepage-size-calculation
+++ a/tools/testing/selftests/drivers/dma-buf/udmabuf.c
@@ -69,7 +69,7 @@ static int create_udmabuf_list(int devfd
 	for (i = 0; i < NUM_ENTRIES; i++) {
 		list->list[i].memfd  = memfd;
 		list->list[i].offset = i * (memfd_size / NUM_ENTRIES);
-		list->list[i].size   = getpagesize() * NUM_PAGES;
+		list->list[i].size   = page_size * NUM_PAGES;
 	}
 
 	list->count = NUM_ENTRIES;
@@ -115,8 +115,8 @@ static int compare_chunks(void *addr1, v
 	while (i < NUM_ENTRIES) {
 		off = i * (memfd_size / NUM_ENTRIES);
 		for (j = 0; j < NUM_PAGES; j++, k++) {
-			char1 = *((char *)addr1 + off + (j * getpagesize()));
-			char2 = *((char *)addr2 + (k * getpagesize()));
+			char1 = *((char *)addr1 + off + (j * page_size));
+			char2 = *((char *)addr2 + (k * page_size));
 			if (char1 != char2) {
 				ret = -1;
 				goto err;
@@ -126,7 +126,7 @@ static int compare_chunks(void *addr1, v
 	}
 err:
 	munmap(addr1, memfd_size);
-	munmap(addr2, NUM_ENTRIES * NUM_PAGES * getpagesize());
+	munmap(addr2, NUM_ENTRIES * NUM_PAGES * page_size);
 	return ret;
 }
 
@@ -240,7 +240,7 @@ int main(int argc, char *argv[])
 	addr1 = mmap_fd(memfd, size);
 	write_to_memfd(addr1, size, 'a');
 	buf = create_udmabuf_list(devfd, memfd, size);
-	addr2 = mmap_fd(buf, NUM_PAGES * NUM_ENTRIES * getpagesize());
+	addr2 = mmap_fd(buf, NUM_PAGES * NUM_ENTRIES * page_size);
 	write_to_memfd(addr1, size, 'b');
 	ret = compare_chunks(addr1, addr2, size);
 	if (ret < 0)
@@ -256,7 +256,7 @@ int main(int argc, char *argv[])
 	size = MEMFD_SIZE * page_size;
 	memfd = create_memfd_with_seals(size, true);
 	buf = create_udmabuf_list(devfd, memfd, size);
-	addr2 = mmap_fd(buf, NUM_PAGES * NUM_ENTRIES * getpagesize());
+	addr2 = mmap_fd(buf, NUM_PAGES * NUM_ENTRIES * page_size);
 	addr1 = mmap_fd(memfd, size);
 	write_to_memfd(addr1, size, 'a');
 	write_to_memfd(addr1, size, 'b');
_

Patches currently in -mm which might be from zishun.yi.dev@gmail.com are

selftests-udmabuf-fix-hugepage-size-calculation.patch

