Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDFF3D76;
	Fri, 17 Jul 2026 00:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784248796; cv=none; b=s090vTKx0cSqNd97YbZVGu3TP75HhSKhCPIM9PiPZUkouRWIdzvnTUfOAVqLnP2r8c6foCfkV7+mplLLmj8l8+uaneChQ1f+HlleJi22uDmTBcwS3Y+iEZ9XNJM+ezEJAF1TpHJRugnIXKg72EJEclenQXUAQVtBQ4wz791u9M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784248796; c=relaxed/simple;
	bh=piQPCIZg+oYgOtMS7pYr7BUfNTBOKCdRN6940xCAsZo=;
	h=Date:To:From:Subject:Message-Id; b=RkRhNj4ZpgSTzXXJu07xXOgqkbhb5K7jBhaKde8c6D8RwdnAYjISi/Nn1puw0eC5h+4upAc+R1Lu2B+YFGco8AaQ8aoetjJC+R/xVJdhyET71Ao9L3DKPtleB30uDcUR0OF3t/dRarrJ1gxnFFDdrEfJYd0e31ld8gFjaDuMlL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dySyoTJG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dySyoTJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47A81F000E9;
	Fri, 17 Jul 2026 00:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784248794;
	bh=oj1uQPt9L2LKNg8rTUMwhrlrisTo+ulNf/vzLM/iU9c=;
	h=Date:To:From:Subject;
	b=dySyoTJGOouKtuPUt8BG4ko4dPfYtpA4LI2reDlhJ97//KW82lJt2t+piNl5Dlybn
	 MU0gqVgF5KxVj55msTjqKQW86jy5S8v6Te47ajOrCGI+0pQFfJ6LPPSpe+oAENkWTQ
	 k6+S4I6Wo1r3Ll5zcELffbuhCU4hwozK5RxTV61o=
Date: Thu, 16 Jul 2026 17:39:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-initialize-locked-in-memcg1_oom_prepare-stub.patch added to mm-hotfixes-unstable branch
Message-Id: <20260717003954.B47A81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: initialize *locked in memcg1_oom_prepare() stub
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-initialize-locked-in-memcg1_oom_prepare-stub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-initialize-locked-in-memcg1_oom_prepare-stub.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: memcg: initialize *locked in memcg1_oom_prepare() stub
Date: Thu, 16 Jul 2026 06:42:18 -0700

mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
and reads it back in memcg1_oom_finish():

	bool locked, ret;
	...
	if (!memcg1_oom_prepare(memcg, &locked))
		return false;
	ret = mem_cgroup_out_of_memory(memcg, mask, order);
	memcg1_oom_finish(memcg, locked);

This relies on memcg1_oom_prepare() setting *locked whenever it returns
true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
CONFIG_MEMCG_V1=n returns true without touching *locked, so
memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
is reported by UBSAN:

  UBSAN: invalid-load in mm/memcontrol.c:1932:27
  load of value 0 is not a valid value for type 'bool' (aka '_Bool')

Initialize *locked to false in the stub; with cgroup v1 compiled out there
is no OOM lock to take.

Link: https://lore.kernel.org/20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org
Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol-v1.h~mm-memcg-initialize-locked-in-memcg1_oom_prepare-stub
+++ a/mm/memcontrol-v1.h
@@ -107,7 +107,11 @@ static inline void memcg1_remove_from_tr
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
-static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked) { return true; }
+static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
+{
+	*locked = false;
+	return true;
+}
 static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
 static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-memcg-initialize-locked-in-memcg1_oom_prepare-stub.patch
mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch

