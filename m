Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16B21442EF
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 06:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161821; cv=none; b=gveMK7moOzHMsN83xJljRnYozcqywiGd0flVNCoU6u+jlxP+W1rmLlX0de/cpf/Huv/FikHu5hvvKAsOPFkis+7ADoJ/6m6tY3xoYEcic4ubYI9ONPXvHMNLb2LX0WtlNaS5MyUpQxt59Cf0DwTHXTXb4pXoeP+fDrLQ1mT4qOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161821; c=relaxed/simple;
	bh=tDTK14cuAtw1vC3UyCHcv6SUSo355mDZZaB850/ZNmg=;
	h=Date:To:From:Subject:Message-Id; b=PfD/KLzr+wfzv3PrONmI6zsie0WO25GujCAtRU53Rl4VGhoUBw6SMMuL40XRpLjD16amd29HsYzAoItI9gZUevv1eYzCLRRGqqGSqORKr5LGPVUJbL9eF9B4d6w0hW/H75dvZxwgpWQk1fnN8sH9DTUV+MSN15OuMmmW4B1U1iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SNCnjR0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SNCnjR0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C8DC4AF0F;
	Fri,  5 Jul 2024 06:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720161821;
	bh=tDTK14cuAtw1vC3UyCHcv6SUSo355mDZZaB850/ZNmg=;
	h=Date:To:From:Subject:From;
	b=SNCnjR0p73DXzSA6nUVgl6YDrtlZ79LcYd7FaOWGubxJ3lobtlDdz3eqaY2k8xKRz
	 POcpUGxc2yykNO/z8m+MUcxgxNbhO7cZYYLWzDzkxbp1TsB58fxIjrUqTiIRkFU+O4
	 F2DiFFkFft/ZQFoJD08fFjlgZlcq8IKqvaWcdMik=
Date: Thu, 04 Jul 2024 23:43:41 -0700
To: mm-commits@vger.kernel.org,dushistov@mail.ru,brauner@kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-ufs-add-module_description.patch removed from -mm tree
Message-Id: <20240705064341.95C8DC4AF0F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: ufs: add MODULE_DESCRIPTION()
has been removed from the -mm tree.  Its filename was
     fs-ufs-add-module_description.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: fs: ufs: add MODULE_DESCRIPTION()
Date: Fri, 10 May 2024 12:02:15 -0700

Fix make W=1 warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in fs/ufs/ufs.o

Link: https://lkml.kernel.org/r/20240510-ufs-md-v1-1-85eaff8c6beb@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ufs/super.c~fs-ufs-add-module_description
+++ a/fs/ufs/super.c
@@ -1540,4 +1540,5 @@ static void __exit exit_ufs_fs(void)
 
 module_init(init_ufs_fs)
 module_exit(exit_ufs_fs)
+MODULE_DESCRIPTION("UFS Filesystem");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are


