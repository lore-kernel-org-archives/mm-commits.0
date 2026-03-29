Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821A9234994
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744809; cv=none; b=fsFtfmEbwqnKx2YBNEuiDlBTcT3MOtGcFRT50WTYam9M6RInHV1aS7YJPgVvT9sjHWI/In1ReWokoW0s+KWMIvm3RLF49dnEvmAy4Yj2rSY9wDaQ7VhjDNnXkTCpY33Cf0c2Uoxjv2SkUkMbCWefiuboi5HRZ32NZzgU6ySTrf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744809; c=relaxed/simple;
	bh=pgMlUqfcmkSQISDny2USR4SxGw1svBYJjO17HVQWCoA=;
	h=Date:To:From:Subject:Message-Id; b=dFnsQLLwZdAD4l9K4X01EuO0X1aWzNH0EZsM76VUUmP7ALWz0pC1KvZZX1gatR560DhmuvDiCwfXgZiB2py+sVe/N3EpAJQupn95vQN8JbSv2GA9cr/lO2kKG/wrlPfDhcSaBcUYSXQhYZ2qK6HcQh54cUF8DxBQFMNZc12mlj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ysOjL1Iv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ysOjL1Iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536F6C4CEF7;
	Sun, 29 Mar 2026 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744809;
	bh=pgMlUqfcmkSQISDny2USR4SxGw1svBYJjO17HVQWCoA=;
	h=Date:To:From:Subject:From;
	b=ysOjL1IvyuBfNye4BNngL/mRMoQnIu6xyYSeyy/3BWWrHj1mOmXp/5YjeaHN/nnqY
	 dx2OrVC+EayrKuEXZSt0n7mUAox54z0e2JZSaFF+KGU0bC9dbAmIb1aFkl7J/ccN6D
	 9YlECX3nL0/mYZdjZOOhFf41u0ahh0KYAYHzzM3A=
Date: Sat, 28 Mar 2026 17:40:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,ljs@kernel.org,david@kernel.org,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-mm-related-procfs-files-to-mm-sections.patch removed from -mm tree
Message-Id: <20260329004009.536F6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add mm-related procfs files to MM sections
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-related-procfs-files-to-mm-sections.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: MAINTAINERS: add mm-related procfs files to MM sections
Date: Thu, 05 Mar 2026 09:26:29 +0100

Some procfs files are very much related to memory management so let's have
MAINTAINERS reflect that.

Add fs/proc/meminfo.c to MEMORY MANAGEMENT - CORE.

Add fs/proc/task_[no]mmu.c to MEMORY MAPPING.

Link: https://lkml.kernel.org/r/20260305-maintainers-proc-v1-1-d6d09b3db3b6@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-related-procfs-files-to-mm-sections
+++ a/MAINTAINERS
@@ -16670,6 +16670,7 @@ F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
+F:	fs/proc/meminfo.c
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
@@ -16985,6 +16986,8 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/trace/events/mmap.h
+F:	fs/proc/task_mmu.c
+F:	fs/proc/task_nommu.c
 F:	mm/interval_tree.c
 F:	mm/mincore.c
 F:	mm/mlock.c
_

Patches currently in -mm which might be from vbabka@kernel.org are


