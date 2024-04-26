Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26F57FBD2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104079; cv=none; b=c6Dtvgwa5VjxGMH9qddGjn2+VtGmUw2OGx+00RTmEChsY5CaOxBc5+JkMNmag7+FyA/pCynlCPUpsjLzM4j2tSlWcVjCYegfiBXGucniBHtszC2lxBiQ/2XWuFQu/1lZ3OhjSm2rJTjvp4KwpJCh+tfWxHPGi8xPoWMxFFjtaJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104079; c=relaxed/simple;
	bh=0fknQrwgg5VAxidCetoN8sbkM770Z4qQql2yWu2p77c=;
	h=Date:To:From:Subject:Message-Id; b=ca0gzCvKw+Al7Lzp6k3U8Vw+nNRBK2/tm3igCgaT/MOhK1s4eiQxd3EbKSgZc9bfMY4zhKr0roRTHnGuJakmfvhAB4oH5iGd2KB+66LZxF4+8JvMRO1+BET8NEHvEep05tgInHIp6nn3nCZlgAmkJg2h5FpDXIJ/wIxZJo77moE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bh5rxpzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bh5rxpzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A79C113CD;
	Fri, 26 Apr 2024 04:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104078;
	bh=0fknQrwgg5VAxidCetoN8sbkM770Z4qQql2yWu2p77c=;
	h=Date:To:From:Subject:From;
	b=Bh5rxpzq53ec6jgFBzLjCbVuI0HySqk1l4bmqmE/HdOf41E+EJkHqvTWcylc2nldy
	 dafDTLDpsOtoFjjTNypTwPWm01kX6LLxE8ITr6P6uAj9nk1GZ/oVFcIOlRwl2SvpGL
	 FgGm2/CPFTWcrEr+hrfhxpZkk3T8yd8m2UZRR1rw=
Date: Thu, 25 Apr 2024 21:01:18 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,surenb@google.com,sunnanyong@huawei.com,peterx@redhat.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,david@redhat.com,axelrasmussen@google.com,zhangpeng362@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-early-return-in-dup_userfaultfd.patch removed from -mm tree
Message-Id: <20240426040118.B8A79C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: early return in dup_userfaultfd()
has been removed from the -mm tree.  Its filename was
     userfaultfd-early-return-in-dup_userfaultfd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

filemap-replace-pte_offset_map-with-pte_offset_map_nolock.patch

