Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6834A42069
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 23:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738969706; cv=none; b=OZoP+gdQnSQx9DZn4v1Les9Vj93Lrf0hF9/UvOz+XOXjwrZx5k4EWBGVCzXocSHz0gIHW9LlRfg/LslZHRskxhhYNJsOyIG7AkdvNihaY5G64oNc5zVjLPAzyc++iywVLKqRoyt/Qb6DkM8Hq4WDVRF8D8k550Ri5CE3v0ARtOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738969706; c=relaxed/simple;
	bh=AfuQr3pVKUDCoRWNxopVy6VLOwEev/V/bFJDURKYGyY=;
	h=Date:To:From:Subject:Message-Id; b=ZzQv2Q2eq/3x+Re8pyFdaA7CruwnVRpX/s2U/i2x3N5ucS99DTah2Ou+AYo2tWbE1TTGsVt4bsLbq+4JD+Stkr7X/OoxvjChoane2mCht7bD9vaOF2sQ42AicEAOeGzSRHtJFTVs8QcJl0iLAclP9bWSGPDQIoD06zYQ7vUSp8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H9jjTz6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H9jjTz6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2677C4CED1;
	Fri,  7 Feb 2025 23:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738969705;
	bh=AfuQr3pVKUDCoRWNxopVy6VLOwEev/V/bFJDURKYGyY=;
	h=Date:To:From:Subject:From;
	b=H9jjTz6FtfchOtMNTYpiiPEXp9ui1E9/TpoNQbWNvTYHyBWufUiWrS4iQbFVVCUTx
	 rUFCofrxJIZq/RWfTkwFX6tFtDOhf64IhwW9iOJQasjWoTydPWqgRDyyBbXKUTtfYR
	 fMTBF3wh3cpnsqpZINmjNEmylw/NQAoA0ZnRnm44=
Date: Fri, 07 Feb 2025 15:08:25 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-kexec-handover-kho-generation-helpers-fix-2.patch added to mm-unstable branch
Message-Id: <20250207230825.B2677C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: make bin_attr_dt_kern static
has been added to the -mm mm-unstable branch.  Its filename is
     kexec-add-kexec-handover-kho-generation-helpers-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-kexec-handover-kho-generation-helpers-fix-2.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: make bin_attr_dt_kern static
Date: Fri, 7 Feb 2025 09:55:03 +0200

Link: https://lkml.kernel.org/r/Z6W_EcyPO5lBbCKZ@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_handover.c~kexec-add-kexec-handover-kho-generation-helpers-fix-2
+++ a/kernel/kexec_handover.c
@@ -74,7 +74,7 @@ static ssize_t dt_read(struct file *file
 	return count;
 }
 
-struct bin_attribute bin_attr_dt_kern = __BIN_ATTR(dt, 0400, dt_read, NULL, 0);
+static struct bin_attribute bin_attr_dt_kern = __BIN_ATTR(dt, 0400, dt_read, NULL, 0);
 
 static int kho_expose_dt(void *fdt)
 {
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch
memblock-add-memblock_rsrv_kern-flag.patch
memblock-introduce-memmap_init_kho_scratch.patch
kexec-add-kexec-handover-kho-generation-helpers-fix.patch
kexec-add-kexec-handover-kho-generation-helpers-fix-2.patch
kexec-add-kho-parsing-support-fix.patch
x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch
documentation-kho-add-memblock-bindings.patch

