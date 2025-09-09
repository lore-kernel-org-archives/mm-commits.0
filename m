Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B288304984
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 06:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757400352; cv=none; b=muC2b1xs51u5pqzve2x/TuRMniBvTfkrmEiObp3vK7wLFoWRPEn0StL4JNcXtYuhFDcYo8Ix5MFZNP4z+EbyvXZvesPaJ0egTZWS+CSSFpC8g+yBZghVYGxftYw8vfBH3hEXAmiav2PI26mcmEu33i0YYJAKqFcdqcNzit6YBI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757400352; c=relaxed/simple;
	bh=kkBeduqg+XDQlyhK3qn2uyNtDvsGwkhxe/BE76QaDs0=;
	h=Date:To:From:Subject:Message-Id; b=uFcIFmjQxwVtAc2fjKxeOOHBqwtaJyYvm47kTugcC1hg0xlOQiUJox5Bgqe12EJMLgIkwPIdQU8g6yAdVjnqE0q1mONqW6VBSYBds5nhwIPXeur9qpT/7/8U6MmPFX3uJqtjqcMCpnm8KrXoN4lmcVcnUw1AUkY0fe/PiZ1yjC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BhazOCq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BhazOCq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB039C4CEF4;
	Tue,  9 Sep 2025 06:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757400352;
	bh=kkBeduqg+XDQlyhK3qn2uyNtDvsGwkhxe/BE76QaDs0=;
	h=Date:To:From:Subject:From;
	b=BhazOCq4bWlqlTJxMGMavjbhaHAgLp0tu+7grC9LZYDgS2y9AzQrceyhMVoP/oRXS
	 l46Q1ljFDjRN6+r436UV30Lhj01n7YqRvm4zfb2T8Tn0uUIM9FPTIaTU1xxJ5o96Qo
	 H/1vmny/p1wdtXLMZGO6c96UJ2870zZkUA4QQONg=
Date: Mon, 08 Sep 2025 23:45:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-tree-entry-to-numa-memblocks-and-emulation-block.patch removed from -mm tree
Message-Id: <20250909064551.EB039C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add tree entry to numa memblocks and emulation block
has been removed from the -mm tree.  Its filename was
     maintainers-add-tree-entry-to-numa-memblocks-and-emulation-block.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add tree entry to numa memblocks and emulation block
Date: Fri, 5 Sep 2025 12:15:57 +0300

Link: https://lkml.kernel.org/r/20250905091557.3529937-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-tree-entry-to-numa-memblocks-and-emulation-block
+++ a/MAINTAINERS
@@ -16127,6 +16127,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
 F:	include/linux/numa_memblks.h
 F:	mm/numa.c
 F:	mm/numa_emulation.c
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-allow-scratch-areas-with-zero-size.patch
lib-test_kho-fixes-for-error-handling.patch
selftest-kho-update-generation-of-initrd.patch

