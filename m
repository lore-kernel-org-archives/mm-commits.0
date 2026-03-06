Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8983B189BB6
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 01:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772761125; cv=none; b=LF0N4LxHal2OVGqnnhsEalW1u+CWGuEpv5mFkDqFchg+sBb9kdhzhjzmN878a5Jh0f0nRxmEG4tmJKKTEyARWvwyl8EtLhZKU5TxbKpzimBVPaNoXhPzHluXvDJBl7WNWsZHmjtmyh+qpw/TgVoUh4RX4lnkkHUxuBzyPAK1wiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772761125; c=relaxed/simple;
	bh=6jT+7Ou5msKbIO1DVeFfVLoF6BhGIb//txweib8Igs0=;
	h=Date:To:From:Subject:Message-Id; b=tHlRgdDE0GLMe4ZqxRtgl0hylCDQXjShqsodLpBF8fzpuU6T5m1TCADmpP1xsXF8dIFQUCJPKXMjxNFBMkYYAhlYxjW60uXh1ZaCCbgyDeczO7xQt06OI3ktGBsjqL/t0za8quTjfOb3Rdbk/6UOypnf6itEd7VL3H+3ctJm0FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SFzrUF6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SFzrUF6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCA6C116C6;
	Fri,  6 Mar 2026 01:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772761125;
	bh=6jT+7Ou5msKbIO1DVeFfVLoF6BhGIb//txweib8Igs0=;
	h=Date:To:From:Subject:From;
	b=SFzrUF6qkZ+KJPYPwnkxeprRMvF1U54SLvTaCI+/MBVlKirrEZk1GZ7vdT4QRIA3n
	 1cCmRAdiPU/FveNvB0qjv+WFTqHc8rb2Fn+a6gARD4nbsp7HpyocHXeGv1cXE5ydQp
	 OOoqLvaLXYYsq0UWMQhgJMte6lwnJNSVEOnmRYEU=
Date: Thu, 05 Mar 2026 17:38:44 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,ljs@kernel.org,david@kernel.org,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-related-procfs-files-to-mm-sections.patch added to mm-new branch
Message-Id: <20260306013845.0FCA6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add mm-related procfs files to MM sections
has been added to the -mm mm-new branch.  Its filename is
     maintainers-add-mm-related-procfs-files-to-mm-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-related-procfs-files-to-mm-sections.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-related-procfs-files-to-mm-sections
+++ a/MAINTAINERS
@@ -16683,6 +16683,7 @@ F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
 F:	include/trace/events/zone_lock.h
+F:	fs/proc/meminfo.c
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
@@ -16998,6 +16999,8 @@ S:	Maintained
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

mm-page_alloc-effectively-disable-pcp-with-config_smp=n.patch
mm-page_alloc-remove-irq-saving-restoring-from-pcp-locking.patch
mm-page_alloc-remove-pcpu_spin_-wrappers.patch
maintainers-add-mm-related-procfs-files-to-mm-sections.patch

