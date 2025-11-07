Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EF518C2C
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 00:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762476408; cv=none; b=FDYiYe0ZbUHA+apICH6GRUDPkE8Kbj0/IWcGZ80DNJ96h+MrxOgYfg/hH0ra0rSNyueKiPm0lOoMIefUyuzc9MKoDtnXyQjpfVOlvxM1RtiHVxX5AgAJ9Z4JPGfmdzyNCoGTM1mID1oxdWB+15lqPgg4OMQClhA539Kic/Gw7XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762476408; c=relaxed/simple;
	bh=UOzq1SoPIFYiXV79bfUp31DxIxSELbdszp8XamcpTEs=;
	h=Date:To:From:Subject:Message-Id; b=jbWtJqRg5APIJ9gcjYUn2hwIzKD0kyijmXRbAnW7i3344Qrimhi2kpqZm0L36sLNz55h/P4NWFRI29FsAObTWX2MO1LQiBGYafraic/+jLfXYaVrdTMxwKJRoaKwGd3is7lPFiEhnF56lhIp9VV6S1avH0EAX28qM/fshl6wN/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q98RhXyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q98RhXyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26259C113D0;
	Fri,  7 Nov 2025 00:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762476408;
	bh=UOzq1SoPIFYiXV79bfUp31DxIxSELbdszp8XamcpTEs=;
	h=Date:To:From:Subject:From;
	b=q98RhXyAUkZ77xeKiGMMd2LUmKhb4S209yxkDZA8APC1AYT3rnxOkOu3vOjgC5fdL
	 ye59L82oEw4AQidhSOZW0VL7dcfipMDi8SYlaieG3wyIEhEaNrfARVC5jRtkWmHf99
	 G9/qFgu5LrQJJ7PwqSu+NLIqsGq7TtKNLqIfJ0Zs=
Date: Thu, 06 Nov 2025 16:46:47 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,luizcap@redhat.com,liuye@kylinos.cn,linmiaohe@huawei.com,david@redhat.com,zhangjiao2@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-page-remove-unused-kpmbits.patch added to mm-nonmm-unstable branch
Message-Id: <20251107004648.26259C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/page: remove unused KPMBITS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-proc-page-remove-unused-kpmbits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-page-remove-unused-kpmbits.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: fs/proc/page: remove unused KPMBITS
Date: Thu, 6 Nov 2025 09:07:34 +0800

KPMBITS is never referenced in the code. Just remove it.

Link: https://lkml.kernel.org/r/20251106010735.1603-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Ye <liuye@kylinos.cn>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/proc/page.c~fs-proc-page-remove-unused-kpmbits
+++ a/fs/proc/page.c
@@ -20,7 +20,6 @@
 
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
-#define KPMBITS (KPMSIZE * BITS_PER_BYTE)
 
 enum kpage_operation {
 	KPAGE_FLAGS,
_

Patches currently in -mm which might be from zhangjiao2@cmss.chinamobile.com are

fs-proc-page-remove-unused-kpmbits.patch

