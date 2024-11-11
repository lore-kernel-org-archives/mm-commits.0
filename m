Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A813E02E
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313715; cv=none; b=nxxHDFo9vDiuQ84GuYSLXvUeVgl4JdhDiZfZd1Gzpo0rYalbWnTV+2fUzRkakw7XNHnOi6vslBxyLLFgQsQARqlP34CdY4FjXfA22FhroodMLx7eRqke7tEMv5IiDGNSUw78HJqEGQdZf1MJMz0RoVHh/C3K5zJ5GGGCXVzKzQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313715; c=relaxed/simple;
	bh=ZLduYPOnsNGCtiblHvYT7IpdMhLcuNiy1zoruwjv0aE=;
	h=Date:To:From:Subject:Message-Id; b=D7YzrBR04rkwuzHttt2wzho2kxw7U2QuNrJC5qbn6WPnem3pnG/KcZSOXqXqYg45CbL7KfDGkiSBAPeOC3femdCFn6iqS75Rl5trZwAnMNxwM9MWoafd2vLTMhROe6RN9sygyNZFggXXlyVSilMEYeAlaukwcATl9pD/Or2w2vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HwoK0TGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HwoK0TGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6935FC4CED0;
	Mon, 11 Nov 2024 08:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313715;
	bh=ZLduYPOnsNGCtiblHvYT7IpdMhLcuNiy1zoruwjv0aE=;
	h=Date:To:From:Subject:From;
	b=HwoK0TGfVLFw+gms51mXmzzTeEFU/XO7+YtMx3EyhBBozC7dh5cDbj/yYq/l3u857
	 +HgHFahP07RCtiwtRDyLIDlVwAkVMcLoV3RAce8aAD5gT3xFT1h9Ca97xdfHW6srze
	 H/O6KzMxjX4OFj0S3/ntLADEqSILGvh8laAE4l8Q=
Date: Mon, 11 Nov 2024 00:28:34 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,paul.walmsley@sifive.com,palmer@rivosinc.com,charlie@rivosinc.com,alex@ghiti.fr,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-mm-fix-typo-in-virtual_address_range.patch removed from -mm tree
Message-Id: <20241111082835.6935FC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: fix typo in virtual_address_range
has been removed from the -mm tree.  Its filename was
     selftest-mm-fix-typo-in-virtual_address_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Subject: selftest/mm: fix typo in virtual_address_range
Date: Tue, 8 Oct 2024 17:41:40 +0800

The function name should be *hint* address, so correct it.

Link: https://lkml.kernel.org/r/20241008094141.549248-4-zhangchunyan@iscas.ac.cn
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftest-mm-fix-typo-in-virtual_address_range
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -64,7 +64,7 @@
 #define NR_CHUNKS_HIGH  NR_CHUNKS_384TB
 #endif
 
-static char *hind_addr(void)
+static char *hint_addr(void)
 {
 	int bits = HIGH_ADDR_SHIFT + rand() % (63 - HIGH_ADDR_SHIFT);
 
@@ -185,7 +185,7 @@ int main(int argc, char *argv[])
 	}
 
 	for (i = 0; i < NR_CHUNKS_HIGH; i++) {
-		hint = hind_addr();
+		hint = hint_addr();
 		hptr[i] = mmap(hint, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
 			       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
_

Patches currently in -mm which might be from zhangchunyan@iscas.ac.cn are


