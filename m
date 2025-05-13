Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE02F1AA791
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 23:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747179174; cv=none; b=K6qAmOOtuWD7VUY+rOWOqVqfD2LZjJWlQHFtnd+j8GKZ8atYxlZ2X+kCFl7d9mUJaHTHEIXiNDeaCCAtwn27VwUiqymlw/QZcTCZ9Z1u4apvdfDVkfAKLHoUnMKPY/VnuW3FmgKxDz9aNcyyjh9PicCneg60CaOZo6Gj0VRG1KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747179174; c=relaxed/simple;
	bh=tPH7OD1gPoW8gbL7urWHa/CHC02GWRtKEI0tfDr7GA0=;
	h=Date:To:From:Subject:Message-Id; b=HJirK2tJjvAJM0lwQ4mzPQ7MOV/Ep1HHMiRln1DTcIWRPv1NXbo3FVYblQHagv8v6iPZDENLAEmIGiOz80fUPkb+mhrdbTJo+voEY4pqLtEDPk+P6Eck7IgSwXJkJVc0bDfEVhLGVNi34pVj3rpbVWxF2fQHfcCayYVnTc6bPDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQcPbxe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQcPbxe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4C2C4CEE4;
	Tue, 13 May 2025 23:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747179174;
	bh=tPH7OD1gPoW8gbL7urWHa/CHC02GWRtKEI0tfDr7GA0=;
	h=Date:To:From:Subject:From;
	b=aQcPbxe7cGqZGLGRC7anmqaDkQQtGHxWN6NEeysPNhR3KLj4CBKtgshF23brj/Hqx
	 qkj2KHc5hX5i3CR37d0UEDwudg67+ZthPoZwzZgyRDJTNKYwmup3K/WBkXXopIpSvb
	 uSQCLNQTUSna+h4Kml8nM+L19u41zUMUesenEUi0=
Date: Tue, 13 May 2025 16:32:53 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,liam.howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@redhat.com,bsegall@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-kernel-forkc-to-relevant-sections.patch added to mm-hotfixes-unstable branch
Message-Id: <20250513233254.0A4C2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add kernel/fork.c to relevant sections
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-kernel-forkc-to-relevant-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-kernel-forkc-to-relevant-sections.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add kernel/fork.c to relevant sections
Date: Tue, 13 May 2025 15:57:06 +0100

Currently kernel/fork.c both contains absolutely key logic relating to a
number of kernel subsystems and also has absolutely no assignment in
MAINTAINERS.

Correct this by placing this file in relevant sections - mm core, exec and
the scheduler so people know who to contact when making changes here.

scripts/get_maintainers.pl can perfectly well handle a file being in
multiple sections, so this functions correctly.

Intent is that we keep putting changes to kernel/fork.c through Andrew's
tree.

Link: https://lkml.kernel.org/r/20250513145706.122101-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Kees Cook <kees@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-kernel-forkc-to-relevant-sections
+++ a/MAINTAINERS
@@ -8840,6 +8840,7 @@ F:	include/linux/elf.h
 F:	include/uapi/linux/auxvec.h
 F:	include/uapi/linux/binfmts.h
 F:	include/uapi/linux/elf.h
+F:	kernel/fork.c
 F:	tools/testing/selftests/exec/
 N:	asm/elf.h
 N:	binfmt
@@ -15527,6 +15528,7 @@ F:	include/linux/mm.h
 F:	include/linux/mm_*.h
 F:	include/linux/mmdebug.h
 F:	include/linux/pagewalk.h
+F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
 F:	mm/init-mm.c
@@ -21756,6 +21758,7 @@ F:	include/linux/preempt.h
 F:	include/linux/sched.h
 F:	include/linux/wait.h
 F:	include/uapi/linux/sched.h
+F:	kernel/fork.c
 F:	kernel/sched/
 
 SCHEDULER - SCHED_EXT
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch
maintainers-add-kernel-forkc-to-relevant-sections.patch

