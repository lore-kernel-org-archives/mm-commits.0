Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA61F79C5
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739409; cv=none; b=ik+JbJpsF3kCXhiCl9wiOm6SB/33TIk3jPGa3Uv5Jr0+tIRzGY5sNivsAn0fzNVDJKz789erdAj1O47KeXANKaP1tgmppeBe1tT7dLf7NpaJ8q4wYcHM6DXkI4ATIvfvpVjRcnuKR2rjOXK/u1BP44NCZkD9lekDsd+fYjpoxxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739409; c=relaxed/simple;
	bh=49xNq30qA50g+0RyOdsTTJjPpMAq/b+96l1bPqfpfmY=;
	h=Date:To:From:Subject:Message-Id; b=kPdJl6dzrktm430O7hQ7B7fhrCYN/8Zn5R5ioHptvU2kB2iNNHiiP1RvWACZwWd+aBr0DnKPXNWu2rpveAwvz8Tx8jwApcXF9TXKpeLbBwiY4NEUgRQu+9ZPgWEO5aWDX8kfLqIHJUfUkBUpuZf+PTVZoyNlu6cpuh6IxRFYEaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mZead060; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mZead060"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A3EC433F1;
	Sat, 24 Feb 2024 01:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739409;
	bh=49xNq30qA50g+0RyOdsTTJjPpMAq/b+96l1bPqfpfmY=;
	h=Date:To:From:Subject:From;
	b=mZead060+kM5iyxbIbSP4dWjlz+lEDpTTc7gYKuzU3lSaoAg9lOQ+tfFTPZ9/CkV0
	 lahQCtLNBy8ZwYpg3bAjyHx9BCldrCnYt3vb2zE8mKBQrznek2X8mk35Kemy2Y+F1d
	 0YbtDrPQRnGEBl8wwLKIrABkyEWjruq2Kud+IFT8=
Date: Fri, 23 Feb 2024 17:50:09 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-update-mm-and-memcg-entries.patch removed from -mm tree
Message-Id: <20240224015009.B0A3EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update mm and memcg entries
has been removed from the -mm tree.  Its filename was
     maintainers-update-mm-and-memcg-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: MAINTAINERS: update mm and memcg entries
Date: Thu, 8 Feb 2024 07:57:27 +0200

Add F: lines for memory management and memory cgroup include files.

Link: https://lkml.kernel.org/r/20240208055727.142387-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/MAINTAINERS~maintainers-update-mm-and-memcg-entries
+++ a/MAINTAINERS
@@ -5383,6 +5383,7 @@ R:	Muchun Song <muchun.song@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/memcontrol.h
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
@@ -14101,15 +14102,24 @@ T:	git git://git.kernel.org/pub/scm/linu
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
+F:	include/linux/memfd.h
+F:	include/linux/memory.h
 F:	include/linux/memory_hotplug.h
+F:	include/linux/memory-tiers.h
+F:	include/linux/mempolicy.h
+F:	include/linux/mempool.h
+F:	include/linux/memremap.h
 F:	include/linux/mm.h
+F:	include/linux/mm_*.h
 F:	include/linux/mmzone.h
+F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
 F:	include/linux/rmap.h
 F:	include/trace/events/ksm.h
 F:	mm/
 F:	tools/mm/
 F:	tools/testing/selftests/mm/
+N:	include/linux/page[-_]*
 
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from rppt@kernel.org are


