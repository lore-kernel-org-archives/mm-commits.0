Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4D51AF0D4;
	Thu, 14 Nov 2024 23:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731627233; cv=none; b=eyA0EHJman7FYjYl7bd437XspGHhXdG6w2AtTsuDagk0e+ij7oCVrDsb9pb1PgMn99RU9YuFsegSktf975evOaZ8pW6r+E4v1uJrECopRwUAJTZHnkt/WMKryZOGvJeiem0A1ZOW/33FDCGBGl3qk8JtdXPETxXQMEdKb/3fG4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731627233; c=relaxed/simple;
	bh=HxfVJAKVBRXDILqPRBYKR6cmZOGKpsvCCpwWYj6e5ms=;
	h=Date:To:From:Subject:Message-Id; b=h66QJL1ujCpKRtyhuqFYs6/cKm29cBkro2ZLlt78D0sfA4PtIZ3GKaN04HeXziaUMulGEadC4wdH+Qw6XPsAH0TjpQ/aFHbw6pLiXuKG5A2pNyrqQZD7XWTf5OQApfkl/2Kc3RnaqTy6OXmTeGF9Dc8csZzSfOrScZpPF20pWS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dWJ6miJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dWJ6miJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D12BC4CECD;
	Thu, 14 Nov 2024 23:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731627233;
	bh=HxfVJAKVBRXDILqPRBYKR6cmZOGKpsvCCpwWYj6e5ms=;
	h=Date:To:From:Subject:From;
	b=dWJ6miJ4zaJz+IErBRNDc6ynTlOKac1xBncxEqAYIrLDjhAQIk6AaOvwcSkppoWY9
	 iQJFhZTDNerAX4qCaDKQ6Bpm7G/R/M4sGetnhdVQv4QPsPYUD5lrLyBNhDY4LbE1Yu
	 dsVPk4ZoSMqN98+ZnN8R80QTwbjwY+I22YvhcudQ=
Date: Thu, 14 Nov 2024 15:33:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,stable@vger.kernel.org,ryan.roberts@arm.com,peterx@redhat.com,osalvador@suse.de,mirq-linux@rere.qmqm.pl,david@redhat.com,avagin@google.com,arnd@arndb.de,andrii@kernel.org,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-prevent-integer-overflow-in-pagemap_scan_get_args.patch added to mm-hotfixes-unstable branch
Message-Id: <20241114233352.5D12BC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: prevent integer overflow in pagemap_scan_get_args()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-prevent-integer-overflow-in-pagemap_scan_get_args.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-prevent-integer-overflow-in-pagemap_scan_get_args.patch

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: fs/proc/task_mmu: prevent integer overflow in pagemap_scan_get_args()
Date: Thu, 14 Nov 2024 11:59:32 +0300

The "arg->vec_len" variable is a u64 that comes from the user at the start
of the function.  The "arg->vec_len * sizeof(struct page_region))"
multiplication can lead to integer wrapping.  Use size_mul() to avoid
that.

Also the size_add/mul() functions work on unsigned long so for 32bit
systems we need to ensure that "arg->vec_len" fits in an unsigned long.

Link: https://lkml.kernel.org/r/39d41335-dd4d-48ed-8a7f-402c57d8ea84@stanley.mountain
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Andrei Vagin <avagin@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-prevent-integer-overflow-in-pagemap_scan_get_args
+++ a/fs/proc/task_mmu.c
@@ -2665,8 +2665,10 @@ static int pagemap_scan_get_args(struct
 		return -EFAULT;
 	if (!arg->vec && arg->vec_len)
 		return -EINVAL;
+	if (UINT_MAX == SIZE_MAX && arg->vec_len > SIZE_MAX)
+		return -EINVAL;
 	if (arg->vec && !access_ok((void __user *)(long)arg->vec,
-			      arg->vec_len * sizeof(struct page_region)))
+				   size_mul(arg->vec_len, sizeof(struct page_region))))
 		return -EFAULT;
 
 	/* Fixup default values */
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

fs-proc-task_mmu-prevent-integer-overflow-in-pagemap_scan_get_args.patch

