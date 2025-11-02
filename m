Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F51D322A
	for <mm-commits@vger.kernel.org>; Sun,  2 Nov 2025 18:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762109080; cv=none; b=iBl0bcEMilLWGSQuxrJSxNNuBYafxXR6ZwWAm7lL5mYY+a/ykRdYUNsyypNzxj+ireA3akCdm64my6hnEPxU5kYdEQBjo1kTG+gNLUpBLDe7AvRduYIglkbyBmsxGwvx3tii+2qiT9dthaNC6936nTaepAbWQAm2T3pzIiGC80Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762109080; c=relaxed/simple;
	bh=e4m8CEMzlgICtz4uo5YFFBptmkLjtcTmBaFdat9xQZc=;
	h=Date:To:From:Subject:Message-Id; b=l066qk1F54LeZUSuG0MVXEXhu6/XpJ3DsjvdGMdPwiwhOS2JvQI6anSFaE8XEaBRFLjS0ZCFj4L6+LxoTfMRZVuIG1D90yFlqn7Y4iYJzmi26ZIf/OnmyTXzq38IKftM4991+dtKHE2wcpe8PWtWIXTkTlB+UyqI4E5bPcFuLtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ll2JUtFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ll2JUtFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE50C4CEF7;
	Sun,  2 Nov 2025 18:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762109079;
	bh=e4m8CEMzlgICtz4uo5YFFBptmkLjtcTmBaFdat9xQZc=;
	h=Date:To:From:Subject:From;
	b=ll2JUtFJXCBVpfiQ9dyOxc2MEcBFy3JxLxOiEENK0RJa4nf5oaovdSs3OrDUdzYET
	 UP0xD4RA0awrpif2X0SC1q+QQVWd7YWUv9Mmrj99Q8twDifeIqjHCL0QGLKFVZYX5B
	 N820YbEkVZ4tQGVnr3uvtu7/FPZtPgnr6hjw+DBA=
Date: Sun, 02 Nov 2025 10:44:39 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,roman.gushchin@linux.dev,nphamcs@gmail.com,minchan@kernel.org,mhocko@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,baohua@kernel.org,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-chris-and-kairui-as-the-swap-maintainer.patch added to mm-hotfixes-unstable branch
Message-Id: <20251102184439.ABE50C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Chris and Kairui as the swap maintainer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-chris-and-kairui-as-the-swap-maintainer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-chris-and-kairui-as-the-swap-maintainer.patch

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
From: Chris Li <chrisl@kernel.org>
Subject: MAINTAINERS: add Chris and Kairui as the swap maintainer
Date: Sun, 02 Nov 2025 07:11:07 -0800

We have been collaborating on a systematic effort to clean up and improve
the Linux swap system, and might as well take responsibility for it.

Link: https://lkml.kernel.org/r/20251102-swap-m-v1-1-582f275d5bce@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-add-chris-and-kairui-as-the-swap-maintainer
+++ a/MAINTAINERS
@@ -16496,12 +16496,12 @@ F:	mm/secretmem.c
 
 MEMORY MANAGEMENT - SWAP
 M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Chris Li <chrisl@kernel.org>
+M:	Kairui Song <kasong@tencent.com>
 R:	Kemeng Shi <shikemeng@huaweicloud.com>
-R:	Kairui Song <kasong@tencent.com>
 R:	Nhat Pham <nphamcs@gmail.com>
 R:	Baoquan He <bhe@redhat.com>
 R:	Barry Song <baohua@kernel.org>
-R:	Chris Li <chrisl@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/swap-table.rst
_

Patches currently in -mm which might be from chrisl@kernel.org are

maintainers-add-chris-and-kairui-as-the-swap-maintainer.patch

