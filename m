Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60EA2868B
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 22:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749509425; cv=none; b=Xh3+wJZesOjKWh4lAoIYAs2MbKpR/8JyeQQPd1uA9CFxGv69TZMLQ2HCxrdPmBIni3pBSWB34S4eQirrPN2fpeMN/PG9nSkJNjV5OY0FYXHI6CBf6ULAqaeKk3+wMKL3mmG1u4r6u/ZMa+ELFvJ3XjQUa5BwKIS+cYuxRW/3Hzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749509425; c=relaxed/simple;
	bh=Hezl/IMvu6wh701fucg1ortQVYKbmWKev9tJDV14jNQ=;
	h=Date:To:From:Subject:Message-Id; b=MjN1XgtLqtUs6Qs6WqEQaQyzbtj5sp7auueXOlQtbl7VeyuOnI+ZghEUSJZsODedwLaDZ3h4RGWv/tYHwmP5Y9EZaxKC91gnTqkA60QVeSWTjQANUD4oOVqZr1GaiAXSt7FtXrDhBiKkoN/h2hSEPX6Z/pGeny+dM1tcUitgRLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v5iwVx1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v5iwVx1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C880C4CEEB;
	Mon,  9 Jun 2025 22:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749509424;
	bh=Hezl/IMvu6wh701fucg1ortQVYKbmWKev9tJDV14jNQ=;
	h=Date:To:From:Subject:From;
	b=v5iwVx1WCbYVRUtFbDL/oyLDhezUJvy9HXMti2JfblDdGTg8K4KcQhB3baCuFpuwF
	 CLLwAQsK40/VI+jm5B6LYTaWk7VCKqzaeDYA6Vl3idXNvSO1KfubZIS4OhBaNgERVb
	 ryaJ5hBlVeGJR0g2M8MBAaULfuxWs8GQMukSoGnk=
Date: Mon, 09 Jun 2025 15:50:23 -0700
To: mm-commits@vger.kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time-fix.patch added to mm-new branch
Message-Id: <20250609225024.3C880C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/node: restore removed extra line
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time-fix.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: drivers/base/node: restore removed extra line
Date: Mon, 9 Jun 2025 09:03:54 -0500

Re-added the extra blank line at the end of the memory.h that was removed
by the commit 'commit d61861e3bb35 ("drivers/base/node: optimize memory
block registration to reduce boot time")'

Link: https://lkml.kernel.org/r/20250609140354.467908-1-donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/memory.h~drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time-fix
+++ a/include/linux/memory.h
@@ -216,4 +216,5 @@ unsigned long memory_block_advised_max_s
  * can sleep.
  */
 extern struct mutex text_mutex;
+
 #endif /* _LINUX_MEMORY_H_ */
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time.patch
drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time-fix.patch
drivers-base-node-remove-register_mem_block_under_node_early.patch
drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch
drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch
drivers-base-node-rename-__register_one_node-to-register_one_node.patch

