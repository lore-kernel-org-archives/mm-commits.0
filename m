Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833A4284663
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 23:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750290266; cv=none; b=udw/U6ZXME6eCViEtPA0x/VUzzbwDCxtgYkCpQn1PdU4az+Sgb/sh/I5JPMoIzeVfKq5fUTDEP18Mi+pck9DfCX54cF68lwvYyX2cmx2umDSH0SuDiJphWkLjbPgnbijDvQmlpNm2d/7pD3nLm94FtzJ5kmjk/mU0OBnGWkppzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750290266; c=relaxed/simple;
	bh=AzwMCf0ECM1nD4cZjLHWHD1g4jLLixtgHemRF6ZegFs=;
	h=Date:To:From:Subject:Message-Id; b=WvH36sTBOkz91KCUEpn95TzvNe2BKlXsd1k1qDIOUTq4R4fNnfrXQWVk1P1Fgi5/PVIlxKFKLRykmSMN4l/P67UOt0vOKvtuNCdLHWqiBAEqwrPj1noGbU0X2rgrkWPMO78gng3bqEucGPWo6XXJ3VvOecoQo72j9WHb2+3OLoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sNCoBv6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sNCoBv6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE748C4CEE7;
	Wed, 18 Jun 2025 23:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750290266;
	bh=AzwMCf0ECM1nD4cZjLHWHD1g4jLLixtgHemRF6ZegFs=;
	h=Date:To:From:Subject:From;
	b=sNCoBv6zMMuf2NQm46AIu3cD4QVXjCF50ruCgHlGSFwqZDz6nO2vZgvYAQ8vhVjlQ
	 u01naNYZD9Nfcr4HWzJZ+NLlKg8R7uP4wHrZVbYs4R1mdk/whKHlZyZHWfe/VnZ5BH
	 M8QiZSbYGZf0NPVYO5dk3Nh9RKSSbXMLr2piwZ1o=
Date: Wed, 18 Jun 2025 16:44:25 -0700
To: mm-commits@vger.kernel.org,mhocko@suse.com,kent.overstreet@linux.dev,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-the-oldflags-and-parameter-in-memalloc_flags_.patch added to mm-new branch
Message-Id: <20250618234425.DE748C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename the oldflags and parameter in memalloc_flags_*()
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-the-oldflags-and-parameter-in-memalloc_flags_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-the-oldflags-and-parameter-in-memalloc_flags_.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: rename the oldflags and parameter in memalloc_flags_*()
Date: Wed, 18 Jun 2025 15:03:28 +0800

The variable name oldflags can indeed be misleading, because it does not
store the complete original value of flags.  Instead, it records which
flags from the given set are not currently set.  So rename it.

Link: https://lkml.kernel.org/r/20250618070328.2192849-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/sched/mm.h~mm-rename-the-oldflags-and-parameter-in-memalloc_flags_
+++ a/include/linux/sched/mm.h
@@ -322,21 +322,22 @@ static inline void might_alloc(gfp_t gfp
 }
 
 /**
- * memalloc_flags_save - Add a PF_* flag to current->flags, save old value
+ * memalloc_flags_save - Add a PF_* flag to current->flags, return saved flags mask
  *
  * This allows PF_* flags to be conveniently added, irrespective of current
  * value, and then the old version restored with memalloc_flags_restore().
  */
-static inline unsigned memalloc_flags_save(unsigned flags)
+static inline unsigned int memalloc_flags_save(unsigned int flags_mask)
 {
-	unsigned oldflags = ~current->flags & flags;
-	current->flags |= flags;
-	return oldflags;
+	unsigned int saved_flags_mask = ~current->flags & flags_mask;
+
+	current->flags |= flags_mask;
+	return saved_flags_mask;
 }
 
-static inline void memalloc_flags_restore(unsigned flags)
+static inline void memalloc_flags_restore(unsigned int flags_mask)
 {
-	current->flags &= ~flags;
+	current->flags &= ~flags_mask;
 }
 
 /**
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-rename-the-oldflags-and-parameter-in-memalloc_flags_.patch

