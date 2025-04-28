Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEE1188CB1
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 04:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745812908; cv=none; b=aSVX73E5wAEyjpp/Kxs/dhHdlwigJRQgps3fjC77EVxn9e93nwH7VUmOdrbShpK7RJwLRz8opD5gVVpvEog+b6JxOoMQQ3g45o6UASf984PVMT/l7DGLlwJRf+9tnmvQZVnXVPlR9dUj3biEXZ+7dLZ0IZ9ce2q0+gOmAnkFBlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745812908; c=relaxed/simple;
	bh=/5T4CkAg2YEsHhl+KuBsQkQhSRA+GFMownz+gC+g5/w=;
	h=Date:To:From:Subject:Message-Id; b=RghR6RRFGrHOs3rgVa5r2uRKMXxmDOCk2YnGgaFPZ+Qtfef/X+eSokfNgWej+hR73q7EK8YZjENJFKerH4cMhT0V4FggZ12EWfkPaDpL3Ok7DPHBWnbdDVMRwMlg4x7XDPOL7EjbtHpOkh+2Q+m71aYI1lCeXRKx9CQ5uk01IZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0NiMojnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0NiMojnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60110C4CEE4;
	Mon, 28 Apr 2025 04:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745812907;
	bh=/5T4CkAg2YEsHhl+KuBsQkQhSRA+GFMownz+gC+g5/w=;
	h=Date:To:From:Subject:From;
	b=0NiMojnzIVPR7wIxN9LPylKwh/UCiwPB9JuNf5t2CtMrWVjX4pw37rQmJzpq/gLQB
	 XHkETplPOr93IExIS5fSpjlmcmjmzX1bFvRheIMoc5pV7oqVIFA3KImJ4eyXRG7b72
	 Z55JXSTtfSAujqKVLWdIP1NPazf3iZLY14W0ziR4=
Date: Sun, 27 Apr 2025 21:01:46 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,thuth@redhat.com,rostedt@goodmis.org,paulmck@kernel.org,jcmvbkbc@gmail.com,gregkh@linuxfoundation.org,corbet@lwn.net,chris@zankel.net,chenhuacai@kernel.org,bp@alien8.de,ardb@kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-kernel-parameters-update-memtest-parameter.patch added to mm-hotfixes-unstable branch
Message-Id: <20250428040147.60110C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/kernel-parameters: Update memtest parameter
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     documentation-kernel-parameters-update-memtest-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-kernel-parameters-update-memtest-parameter.patch

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
From: WangYuli <wangyuli@uniontech.com>
Subject: Documentation/kernel-parameters: Update memtest parameter
Date: Mon, 28 Apr 2025 11:47:46 +0800

LoongArch, MIPS and XTENSA has supported memtest now.
Update documentation for them.

Link: https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=dce44566192ec0b38597fdfd435013c2d54653ff
Link: https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fb8e9f59d6f292c3d9fea6c155c22ea5fc3053ab
Link: https://lkml.kernel.org/r/0FC3D21CA22E8251+20250428034746.21216-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Christian Zankel <chris@zankel.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Huth <thuth@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~documentation-kernel-parameters-update-memtest-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3620,7 +3620,7 @@
 			Note that even when enabled, there are a few cases where
 			the feature is not effective.
 
-	memtest=	[KNL,X86,ARM,M68K,PPC,RISCV,EARLY] Enable memtest
+	memtest=	[KNL,X86,ARM,LOONGARCH,MIPS,M68K,PPC,RISCV,XTENSA,EARLY] Enable memtest
 			Format: <integer>
 			default : 0 <disable>
 			Specifies the number of memtest passes to be
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

documentation-kernel-parameters-update-memtest-parameter.patch
ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch
treewide-fix-typo-previlege.patch

