Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DC548CD67
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786570030; cv=none; b=FTxyDEApJD1+eAiIRFDFn4GSYMoK8FCEtBzEeQ9igvLI6hE70zu5Yd+FEDKI6kW2Wn/uD3x1b4IOO+BYhz54TzAly/Xly78UwBIxaPJ/+4/qhM0AgCHnYGMlV9D8fQC6yDHPQ1WeD5E6qCYXdHSkZ5KVaaQ2WCBiF3jW2BJZmhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786570030; c=relaxed/simple;
	bh=Z0UjdgNbI2lBlnD/u6RMtyRsEoMM5Z1HIpnLmh951/Q=;
	h=Date:To:From:Subject:Message-Id; b=GAc6Hy99ItXmPpM3yRng/pI0vthA7KRqW5UM9IgSd5s5JnfM2XREWWIZJyPsEvn2bw+eTxOmOum+mDhFj1PTYa0ThfUnwLQa/D6ivBCm4F1TFz/LbIUVJtWMN36FgCgcHst9sLvFVqENwgRPNUvzfnM+PZoOaBlmFZ9HxOH4Q50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oCFMnXrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oCFMnXrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C0D1F000E9;
	Wed, 12 Aug 2026 21:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786570016;
	bh=xsrzG/+4ejT76aKLfJG/2u01WLDXYCFRy5c8Xq8UQXY=;
	h=Date:To:From:Subject;
	b=oCFMnXrqIz6371MWViEboLZ7UfpSt9SacTDKZwJjY0NXDxCUML5uuy0vJuR+UDSOc
	 lgI7VFc6k1fCOrW0bS3XPvnSKjJGttUl6E5IezZRThJX67uFRS5dNHsFwLGq3/KJ1E
	 BpqoG6/tw+0+3su6SSP0ADKfEJKQdxMabpbb37+U=
Date: Wed, 12 Aug 2026 14:26:55 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,surenb@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch removed from -mm tree
Message-Id: <20260812212656.37C0D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/Kconfig.debug: make DEBUG_FORCE_WEAK_PER_CPU depend on S390||ALPHA
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/Kconfig.debug: make DEBUG_FORCE_WEAK_PER_CPU depend on S390||ALPHA
Date: Mon Aug 10 08:50:56 PM PDT 2026

CONFIG_DEBUG_FORCE_WEAK_PER_CPU appears to be alpha-specific.  The Kconfig
help text says s390 can need it also, but the comment in percpu-defs.h
only mentions alpha.  The original commit 7c756e6e19e7 ("percpu: implement
optional weak percpu definitions") mentions both alpha and s390.

All quite mysterious and perhaps this feature is no longer needed.

However x86_64 allmodconfig enables it, and because mm/alloc_tag.c
requires !DEBUG_FORCE_WEAK_PER_CPU (another mystery), alloc_tag isn't
getting allmodconfig build coverage.

Adding `depends on S390||ALPHA' fixes this.

Cc: Tejun Heo <tj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha
+++ a/lib/Kconfig.debug
@@ -616,6 +616,7 @@ config BUILTIN_MODULE_RANGES
 config DEBUG_FORCE_WEAK_PER_CPU
 	bool "Force weak per-cpu definitions"
 	depends on DEBUG_KERNEL
+	depends on S390 || ALPHA
 	help
 	  s390 and alpha require percpu variables in modules to be
 	  defined weak to work around addressing range issue which
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

