Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A405E33B94B
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 20:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769115441; cv=none; b=L7/ecbVC0hs6jUxXzkkT5zXFCGwAF9ctjiv+jglhluMSDS0xIN7ZaNPal5wuRgz/QgcLXnryWXTH1nDqPzJCdxOYakis7pY6Y15mUPaB3mr32zUxskovKg7OtXhW3YbMrLANDFsXMet6tDV6fyffWbh2OkWKYjGX/uPZYbHzBBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769115441; c=relaxed/simple;
	bh=qdjYw2vo51dch0bPfGCyYEl6p1XZ8bhKYGBtY2gdzqg=;
	h=Date:To:From:Subject:Message-Id; b=mbBqZClzNE+BBFJ0ZWDoBPKz50CKM5g6fXtoY/xzv3UnpEF+ypeP8A3YLzjGiPoDR1xYPzAY2jQn2ckQ4FHz2za04vO5CKJfLA45N4hwCITi6KYqpfR/ETO2vn7rz2i993SZTflnwCWREPE3YwDzAs86hjwReBqJ4wn0z2NpWHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GAi5Aj1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GAi5Aj1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CE8C116C6;
	Thu, 22 Jan 2026 20:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769115440;
	bh=qdjYw2vo51dch0bPfGCyYEl6p1XZ8bhKYGBtY2gdzqg=;
	h=Date:To:From:Subject:From;
	b=GAi5Aj1on5oQTkxM3NJC3jYzo6ClCvKGQE6T6jz0bVa+pfXVIcFoyaKJPsrfeIymB
	 FCpO7OCuLu/r3vyf8ctu83FePkwVcKqozXTOrNhHFW6jwR65rVyJ0gdjnVSbubvS/K
	 ANN/7JZt16L8GNoLzTVJgsxbiN2R7hbn99Fzw4UU=
Date: Thu, 22 Jan 2026 12:57:23 -0800
To: mm-commits@vger.kernel.org,zhiquan1.li@intel.com,xueshuai@linux.alibaba.com,vgoyal@redhat.com,tony.luck@intel.com,osandov@osandov.com,dyoung@redhat.com,bhe@redhat.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcoreinfo-make-hwerr_data-visible-for-debugging.patch added to mm-nonmm-unstable branch
Message-Id: <20260122205719.E8CE8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmcoreinfo: make hwerr_data visible for debugging
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     vmcoreinfo-make-hwerr_data-visible-for-debugging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmcoreinfo-make-hwerr_data-visible-for-debugging.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: vmcoreinfo: make hwerr_data visible for debugging
Date: Thu, 22 Jan 2026 02:39:36 -0800

If the kernel is compiled with LTO, hwerr_data symbol might be lost, and
vmcoreinfo doesn't have it dumped.  This is currently seen in some
production kernels with LTO enabled.

Remove the static qualifier from hwerr_data so that the information is
still preserved when the kernel is built with LTO.  Making hwerr_data a
global symbol ensures its debug info survives the LTO link process and
appears in kallsyms.  Also document it, so, it doesn't get removed in the
future as suggested by akpm.

Link: https://lkml.kernel.org/r/20260122-fix_vmcoreinfo-v2-1-2d6311f9e36c@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhiquan Li <zhiquan1.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/vmcore_info.c~vmcoreinfo-make-hwerr_data-visible-for-debugging
+++ a/kernel/vmcore_info.c
@@ -36,7 +36,11 @@ struct hwerr_info {
 	time64_t timestamp;
 };
 
-static struct hwerr_info hwerr_data[HWERR_RECOV_MAX];
+/*
+ * The hwerr_data[] array is declared with global scope so that it remains
+ * accessible to vmcoreinfo even when Link Time Optimization (LTO) is enabled.
+ */
+struct hwerr_info hwerr_data[HWERR_RECOV_MAX];
 
 Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
 			  void *data, size_t data_len)
_

Patches currently in -mm which might be from leitao@debian.org are

vmcoreinfo-make-hwerr_data-visible-for-debugging.patch

