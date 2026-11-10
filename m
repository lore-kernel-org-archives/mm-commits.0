Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794342012;
	b=jfyxYenjrwdvcImQ8e4MT9nkGr0Tff/B9W5Nka1BIEF453eRmhNdgqE0CDZN9glhEXG2
	 g3Jaem2QYNQGAtAa0iUxRwG3wE3+CX6XDECJztnMT9E3pVxHjZCrQmRiwzjj3FyaJTUqK
	 hkGVnUUq9SIrFiUySsJxJGSz+TMNBl6rbdjxjTzPQsxr73pVae16x3mftr7cNz4QUvob6
	 LPQOKY/q47oicXO0Pz7C9WZZ3ofwiyNT49UQaEplvVf62gCEHPWkKZcX0WDx9lwPSuD+I
	 H/VGVbti0HQoB4CjT+2+QOcmFawZh8fGNcgs6leT6vnHXHr10YULBitaBrmAcV5kWJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794342012;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=JaUH5xTZVWG7jo5UuoshoqPl7MvBR2AZttWN0ZqyHDg=;
	b=DjEVTNuvx53Be/RKQK3cip2r3ycGj7rNwuNjww7ayPMRO02ExI96pUnnYNq6nJCcJ+sz
	 b/SemK/4XU9iCTlAZYcr2c28wtNFSrUAx/4FfwyYYv3m1agcOjqfyD5VmQeqfUiGr3cQN
	 sbMMmRKCJQ7V6mpTBGay6skKJ778mtob1OlkUX80/bQjdpJg6m+pVrMAnM2UgW09clx8d
	 /kj40txzagh8UwHVKSrfmWnUOOgPyp6p1C7x+O4VcNeVembFIhxa4F665l/oaPDHd9aUb
	 KWpqcB+Q2AyC32Sl2HDqOOE0Hs7O6XaXJIu5opRaM6wRCmLveeuBfISWzLwlzJjY3dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OoWm+82S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08EF606A320
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 20:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OoWm+82S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD261F0089F;
	Tue, 10 Nov 2026 20:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794342011;
	bh=JaUH5xTZVWG7jo5UuoshoqPl7MvBR2AZttWN0ZqyHDg=;
	h=Date:To:From:Subject;
	b=OoWm+82S1p4XmbGZv4L5oNtAI9q61bAQE3IbO13kwUIh36KfmGNjAtRb8ZLaA4JUp
	 p5+4uggffvb2hmodYUhYZrBH1jyl/pMz1MaQH6PT4w7OOCWjYQkypNDv5gAD1vrATL
	 vRTUY9PYSxDUCuJPn+/mx5oWbNEpTFIGjs1ilkEo=
Date: Tue, 10 Nov 2026 12:20:10 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,
	tongweilin@linux.alibaba.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-thpmaps-handle-carriage-returns-and-non-utf-8-filenames.patch added to mm-nonmm-unstable branch
Message-Id: <20261110202011.4CD261F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tools/mm/thpmaps: handle carriage returns and non-UTF-8 filenames
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-mm-thpmaps-handle-carriage-returns-and-non-utf-8-filenames.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-thpmaps-handle-carriage-returns-and-non-utf-8-filenames.patch

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
From: Weilin Tong <tongweilin@linux.alibaba.com>
Subject: tools/mm/thpmaps: handle carriage returns and non-UTF-8 filenames
Date: Wed, 04 Nov 2026 14:16:41 +0800

VMAList opens smaps with universal newline handling and strict decoding.
A carriage return in a mapped filename can split a header into multiple
records, while non-UTF-8 bytes cause UnicodeDecodeError.

Read LF-terminated records and use surrogateescape to preserve filename
bytes. Escape filename characters that stdout cannot encode to avoid
UnicodeEncodeError when printing mapping names.

Link: https://lore.kernel.org/20261104061641.1115805-1-tongweilin@linux.alibaba.com
Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/linux-mm/20261101211644.c63a2028bbede0f763f41f80@linux-foundation.org/
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 tools/mm/thpmaps |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/mm/thpmaps~tools-mm-thpmaps-handle-carriage-returns-and-non-utf-8-filenames
+++ a/tools/mm/thpmaps
@@ -196,7 +196,8 @@ class VMAList:
     # instance to receive VMAs.
     def __init__(self, pid='self', stats=[]):
         self.vmas = []
-        with open(f'/proc/{pid}/smaps', 'r') as file:
+        with open(f'/proc/{pid}/smaps', 'r', newline='\n',
+                  errors='surrogateescape') as file:
             for line in file:
                 elements = line.rstrip('\n').split(maxsplit=5)
                 if '-' in elements[0]:
@@ -363,12 +364,14 @@ def cont_parse(vma, order, ranges, anons
 def vma_print(vma, pid):
     # Prints a VMA instance in a format similar to smaps. The main difference is
     # that the pid is included as the first value.
+    name = vma.name.encode(sys.stdout.encoding, errors='backslashreplace')
+    name = name.decode(sys.stdout.encoding)
     print("{:010d}: {:016x}-{:016x} {}{}{}{} {:08x} {:02x}:{:02x} {:08x} {}"
         .format(
             pid, vma.start, vma.end,
             'r' if vma.read else '-', 'w' if vma.write else '-',
             'x' if vma.execute else '-', 'p' if vma.private else 's',
-            vma.pgoff, vma.major, vma.minor, vma.inode, vma.name
+            vma.pgoff, vma.major, vma.minor, vma.inode, name
         ))
 
 
_

Patches currently in -mm which might be from tongweilin@linux.alibaba.com are

tools-mm-thpmaps-fix-partial-thp-anon-file-accounting.patch
tools-mm-thpmaps-fix-missing-order-1-file-thp-statistics.patch
tools-mm-thpmaps-fix-missing-mapping-names.patch
tools-mm-thpmaps-handle-carriage-returns-and-non-utf-8-filenames.patch

