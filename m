Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1267B280335
	for <mm-commits@vger.kernel.org>; Sun, 22 Mar 2026 00:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774138885; cv=none; b=b3INzrxH0TMBuHwsbZFf8HM/jA/UFcrbXl8uNtvSbF2zLHJqwysCKWEZko1q4c2HD2kT1zSsK/+wkQPoFF9pe3G3MjZlYQVEsw/gFGB39vPPabvXmaCXF2PhYzceCZZ5df0x1BvMDj0wJVvAXuX8t6lu9ccSbIq5A7aOVI6CXQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774138885; c=relaxed/simple;
	bh=YhISAJ4SoTWMwH/lxR6SC/oSPVnP6Wcjr+bzeRNZQ/g=;
	h=Date:To:From:Subject:Message-Id; b=fkTumrqWBQ44B38yXjL7Tb3Vmad5nmYtiUnUXg9gbEr8p5SNPLN1Rfc2SXsEGwqexOy7jN2GHJl4tKOaMh4bY320OgA3Xpso6syi+32+QqG08+F+S2ubmboIp09XoTZreAqlDT6cLV4cVH4FfvI2xEVkhAMZrvx0iOnUTcUU4SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z3DKZo/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z3DKZo/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6DCC19421;
	Sun, 22 Mar 2026 00:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774138884;
	bh=YhISAJ4SoTWMwH/lxR6SC/oSPVnP6Wcjr+bzeRNZQ/g=;
	h=Date:To:From:Subject:From;
	b=Z3DKZo/RZDROT1EotPhw/PQDkrxnyu2Re/RL4DVBCnRFt/kLueuX3LpOs2jK4mMfF
	 qelRjFzgTHoidS2dAPxyHIt5454R7TAMpxGFO3/saeSMTMU6NgwAj1OQ30iGP5RDRZ
	 69JOC9EJRg2Kdd03qfMXAt+4w2SD0LknwLa8ClLg=
Date: Sat, 21 Mar 2026 17:21:23 -0700
To: mm-commits@vger.kernel.org,kexinsun@smail.nju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-fix-stale-reference-to-memory_block_add_nid.patch added to mm-new branch
Message-Id: <20260322002124.5A6DCC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/memory: fix stale reference to memory_block_add_nid()
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-memory-fix-stale-reference-to-memory_block_add_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-memory-fix-stale-reference-to-memory_block_add_nid.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
Subject: drivers/base/memory: fix stale reference to memory_block_add_nid()
Date: Sat, 21 Mar 2026 18:57:04 +0800

The function memory_block_add_nid() was renamed to
memory_block_add_nid_early() by commit 0a947c14e48c ("drivers/base: move
memory_block_add_nid() into the caller").  Update the stale reference in
add_memory_block().

Assisted-by: unnamed:deepseek-v3.2 coccinelle
Link: https://lkml.kernel.org/r/20260321105704.6093-1-kexinsun@smail.nju.edu.cn
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/memory.c~drivers-base-memory-fix-stale-reference-to-memory_block_add_nid
+++ a/drivers/base/memory.c
@@ -815,7 +815,7 @@ static int add_memory_block(unsigned lon
 		/*
 		 * MEM_ONLINE at this point implies early memory. With NUMA,
 		 * we'll determine the zone when setting the node id via
-		 * memory_block_add_nid(). Memory hotplug updated the zone
+		 * memory_block_add_nid_early(). Memory hotplug updated the zone
 		 * manually when memory onlining/offlining succeeds.
 		 */
 		mem->zone = early_node_zone_for_memory_block(mem, NUMA_NO_NODE);
_

Patches currently in -mm which might be from kexinsun@smail.nju.edu.cn are

kasan-update-outdated-comment.patch
mm-vmalloc-update-outdated-comment-for-renamed-vread.patch
mm-update-outdated-comments-for-removed-scan_swap_map_slots.patch
drivers-base-memory-fix-stale-reference-to-memory_block_add_nid.patch

