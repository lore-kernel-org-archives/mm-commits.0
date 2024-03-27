Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDE642A83
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711568434; cv=none; b=jj1+Y8naheDZ1TEP2ovji//yDK2T6JN53nJjdNC7mc4dNOyqXohKDekNCmBrmi6ZT2Ysx3OnqrPWy/ya0YrrfaCTyWqGwOIuXGNawRF/8OFc7wrqX/jKxNkjip2xgzpqGVcG+g5yOEt40FpSss+hNW3YdaOMwU+I4rABQ+AVlfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711568434; c=relaxed/simple;
	bh=TJ9rNXrcISSuzq7/HXv/Ean2Ees70jRvsNU2wZhnpo4=;
	h=Date:To:From:Subject:Message-Id; b=HnrDnUV6VqJuIHukNyKUH1rv0zI7HBlja77LdKpzhFwwqV5anhP8Ih6EoqoNOV6ku+35ImIi0YXD43LwS4Uts9U+3UEhYAGFFyNlvYv7PHBMQPG2fHJIFv1wX9yf3GsNcfSOzkkvCSa9k9D8MJz9VHvElLmsqvTMY/PslttdmCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zig+U0KN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zig+U0KN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09685C433C7;
	Wed, 27 Mar 2024 19:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711568434;
	bh=TJ9rNXrcISSuzq7/HXv/Ean2Ees70jRvsNU2wZhnpo4=;
	h=Date:To:From:Subject:From;
	b=zig+U0KNAjivsesWPkr0HtMu4Rp16exnaNMbM+cK3nWuXfMem0MRCCrF8swJKeKjG
	 PI6NNDmbLU0+PGKK4QXsCwaw4/2sBae0h/FR700raousj/JXNdDapDhxYJnTbRCaWQ
	 EgKxkviXWNHd+HoTHAjdl7lfRx9MhwrseQShCqZY=
Date: Wed, 27 Mar 2024 12:40:33 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,surenb@google.com,sunnanyong@huawei.com,peterx@redhat.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,david@redhat.com,axelrasmussen@google.com,zhangpeng362@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-early-return-in-dup_userfaultfd.patch added to mm-unstable branch
Message-Id: <20240327194034.09685C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: early return in dup_userfaultfd()
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-early-return-in-dup_userfaultfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-early-return-in-dup_userfaultfd.patch

This patch will later appear in the mm-unstable branch at
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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: userfaultfd: early return in dup_userfaultfd()
Date: Wed, 27 Mar 2024 17:08:35 +0800

When vma->vm_userfaultfd_ctx.ctx is NULL, vma->vm_flags should have
cleared __VM_UFFD_FLAGS. Therefore, there is no need to down_write or
clear the flag, which will affect fork performance. Fix this by
returning early if octx is NULL in dup_userfaultfd().

By applying this patch we can get a 1.3% performance improvement for
lmbench fork_prot. Results are as follows:
                   base      early return
Process fork+exit: 419.1106  413.4804

Link: https://lkml.kernel.org/r/20240327090835.3232629-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/userfaultfd.c~userfaultfd-early-return-in-dup_userfaultfd
+++ a/fs/userfaultfd.c
@@ -657,7 +657,10 @@ int dup_userfaultfd(struct vm_area_struc
 	struct userfaultfd_fork_ctx *fctx;
 
 	octx = vma->vm_userfaultfd_ctx.ctx;
-	if (!octx || !(octx->features & UFFD_FEATURE_EVENT_FORK)) {
+	if (!octx)
+		return 0;
+
+	if (!(octx->features & UFFD_FEATURE_EVENT_FORK)) {
 		vma_start_write(vma);
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

userfaultfd-early-return-in-dup_userfaultfd.patch
filemap-replace-pte_offset_map-with-pte_offset_map_nolock.patch

