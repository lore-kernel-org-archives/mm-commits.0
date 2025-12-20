Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEEF263F54
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 19:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766258602; cv=none; b=dJyxTBWxPd72oTJzwihOdxcUJ6wsXHMS8XZNtUfQdSKb+QNw30pQ0uwUQ4tGciCIqmbr1MMWIaI4ja8LufDsJitCet4OXqPtTUk42sfEWMUtMsnHwUNdbSKMjMmao7xUlFZBBkrEOcfpqwfebIYJ5fnRnCCVqLKMmX+9lx27zW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766258602; c=relaxed/simple;
	bh=P8zmB8K/JPdtoSoKxtEA7v2uVHDXXMkdUELE40cdsfI=;
	h=Date:To:From:Subject:Message-Id; b=UbeHZRhn/tAIPO6QG6BbexLIvifTSfdAntTcDjIcWauxCOjPzVMtzJoZAFf7YIrEsMZOt+1N1IuH6wAOenFPlBgxkRvQczPQAb0pJZ2KKODH22IWX25KByL0eqiwLv3fqymoRE9GGabIDP5WTlMHyQ2KWa59r6wZCIuOMxtsn/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y3K+wE8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y3K+wE8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594ECC4CEF5;
	Sat, 20 Dec 2025 19:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766258602;
	bh=P8zmB8K/JPdtoSoKxtEA7v2uVHDXXMkdUELE40cdsfI=;
	h=Date:To:From:Subject:From;
	b=Y3K+wE8RbuCAbkGvJKOeAOESLEwvOFndKJpHY/RaocuETVfv8isrj0ss8LDa2qCnI
	 xkfP1xy1j4TvKxXouPNRqYxeeERFNqiYQAov7e3zawyLLKssPKOy2NWw+WwSmOrX/K
	 FqFSp6JT6PZ9NBnoM27OOkw/MQI7F1x9RZ2+07IU=
Date: Sat, 20 Dec 2025 11:23:21 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stefani@seibold.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfifo-fix-kmalloc_array_node-argument-order.patch added to mm-nonmm-unstable branch
Message-Id: <20251220192322.594ECC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfifo: fix kmalloc_array_node() argument order
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kfifo-fix-kmalloc_array_node-argument-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfifo-fix-kmalloc_array_node-argument-order.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kfifo: fix kmalloc_array_node() argument order
Date: Fri, 19 Dec 2025 21:45:41 -0800

To be consistent, pass the kmalloc_array_node() parameters in the order
(number_of_elements, element_size).  Since only the product of the two
values is used, this is not a bug fix.

Link: https://lkml.kernel.org/r/20251220054541.2295599-1-rdunlap@infradead.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=216015
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kfifo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/kfifo.c~kfifo-fix-kmalloc_array_node-argument-order
+++ a/lib/kfifo.c
@@ -41,7 +41,7 @@ int __kfifo_alloc_node(struct __kfifo *f
 		return -EINVAL;
 	}
 
-	fifo->data = kmalloc_array_node(esize, size, gfp_mask, node);
+	fifo->data = kmalloc_array_node(size, esize, gfp_mask, node);
 
 	if (!fifo->data) {
 		fifo->mask = 0;
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-leafopsh-correct-kernel-doc-function-param-names.patch
sparse-update-maintainers-info.patch
kernelh-drop-hexh-and-update-all-hexh-users.patch
kfifo-fix-kmalloc_array_node-argument-order.patch

