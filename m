Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998112261D
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 21:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719611010; cv=none; b=TLVCr0rDPvDlGH3zdiSJ4UOeIEWU3WXGLBNsFq+TLSrrCMKCa2VwGxLB0/xzeLAMUt8ilQ/il88ahGlWnZNuyK7qq5HxqroMg9QQkmAacjT7sr+ZbXHb68in4/slw6dsMtiHtJPl2BfFUUWMw772+BfGsr2UFuDfq8UQyfvfEbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719611010; c=relaxed/simple;
	bh=Q5tHv5TkXcX+PDELa6sh0x+Yt6H4W0GFECii0eGY62o=;
	h=Date:To:From:Subject:Message-Id; b=n5pfaKK0xANngdO2NxSJRHbqXZfaIWGzLuGoJ1igvew40Ss50J4jJEnzIKaPmF+hx9j9anlX4JFBGhAdvY2ih9smYwaBqwm56kRY8MaIRxP4ikG0oXeraJMvmpfY8A1wSWjWrs3/fAvLY+uxqZRgdr9wqPlxRXZsVkBPW0PucEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FfIWphD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FfIWphD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23350C116B1;
	Fri, 28 Jun 2024 21:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719611010;
	bh=Q5tHv5TkXcX+PDELa6sh0x+Yt6H4W0GFECii0eGY62o=;
	h=Date:To:From:Subject:From;
	b=FfIWphD/7WTw6JN5pksJOyFDUJDT+GNad2QFYl4Wd7B4DGZSzORUVvtHM5Woskr41
	 r0jf7XIRSJxQfoaqPKu9/j+KU0muVxWnXOlMr5sgAlQeIcJAxMJ7WIa0VIHQp5AitQ
	 x7dEiMj1gw7fK9rkJlxkEb4ZW96OeisOB2Q2Z/k0=
Date: Fri, 28 Jun 2024 14:43:29 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,rdunlap@infradead.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-userspace-controls-soft-offlining-pages-v7.patch added to mm-unstable branch
Message-Id: <20240628214330.23350C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-userspace-controls-soft-offlining-pages-v7
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-userspace-controls-soft-offlining-pages-v7.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-userspace-controls-soft-offlining-pages-v7.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm-memory-failure-userspace-controls-soft-offlining-pages-v7
Date: Fri, 28 Jun 2024 20:59:56 +0000

Link: https://lkml.kernel.org/r/20240628205958.2845610-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-userspace-controls-soft-offlining-pages-v7
+++ a/mm/memory-failure.c
@@ -2808,8 +2808,7 @@ int soft_offline_page(unsigned long pfn,
 	}
 
 	if (!sysctl_enable_soft_offline) {
-		pr_info_once("%#lx: disabled by /proc/sys/vm/enable_soft_offline\n",
-			pfn);
+		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
 		put_ref_page(pfn, flags);
 		return -EOPNOTSUPP;
 	}
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-unpoison_memory.patch
mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
mm-memory-failure-userspace-controls-soft-offlining-pages-v7.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
selftest-mm-test-enable_soft_offline-behaviors-v7.patch
docs-mm-add-enable_soft_offline-sysctl.patch

