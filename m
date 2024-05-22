Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3BC146D65
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 23:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716419618; cv=none; b=Cu20C8MDJH3EcGH/eTgtCYKI6/2rKbcBmcA1UreBrxRs8bcpopmtXZgONhX+I2Z2VvaTf7/oe0e5jrl4VLT7Focvqrlp7ZLDjxhKl+fyi/fnLvr2NDGXdJt8TUlKcSIhJgLsRHrSD/WWpPsqXeBgNnHeNFD+IjfO3W0goXpGCBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716419618; c=relaxed/simple;
	bh=x5hW5yKZINsvkKGd5l3H8rcttwTovZefEKo95WQoF5M=;
	h=Date:To:From:Subject:Message-Id; b=T9vnlJ5WYcM0ClrNh0/8e0glSTdUBdHXc7KbDy42Or7L8G/4ei6dtD/eDwyeC1ldJ19nxkzt/lZI9kMhqasgJn5VKyXewSkElXV6kzPDJ144qFLvG4qYc7k04X6FJP6bLFH/BOwhuZePHzDWPrjrEdMhCnxwbJ8DUInIqhfEdzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zJobnGme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zJobnGme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857D0C2BBFC;
	Wed, 22 May 2024 23:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716419617;
	bh=x5hW5yKZINsvkKGd5l3H8rcttwTovZefEKo95WQoF5M=;
	h=Date:To:From:Subject:From;
	b=zJobnGmeKha3KWeNfoqYBMShS35VTG5UoGp1JnMrAY/n+PWqVoNp7SOjjWxZVT0Z2
	 qIomZsSJ2A7lioHrBnqUQwHsqHyGC0gnltWMspodmX/40h3rzjQXZiDXtK27ij8Fus
	 Q8+E08BzkdIYwpGc+pXZOYIZ+XEc9hwxcFVhct2I=
Date: Wed, 22 May 2024 16:13:36 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nao.horiguchi@gmail.com,minchan@kernel.org,linmiaohe@huawei.com,glider@google.com,elver@google.com,dvyukov@google.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-add-module_description.patch added to mm-unstable branch
Message-Id: <20240522231337.857D0C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: add MODULE_DESCRIPTION()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-add-module_description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-add-module_description.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: mm/zsmalloc: add MODULE_DESCRIPTION()
Date: Mon, 13 May 2024 12:37:41 -0700

Fix the 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in mm/zsmalloc.o

Link: https://lkml.kernel.org/r/20240513-mm-md-v1-4-8c20e7d26842@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-add-module_description
+++ a/mm/zsmalloc.c
@@ -2276,3 +2276,4 @@ module_exit(zs_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
+MODULE_DESCRIPTION("zsmalloc memory allocator");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
backtracetest-add-module_description.patch

