Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C396C8F6A
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 20:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720815545; cv=none; b=Po+dau2Tyabu8SSxhJ2VncoVQswORbWTiMAt9lMtNgA8HERBAFDaSPziTMX4lR/YAuPKVquPybY+S64ZR606+1VM1dIf9tZbavDAyWnzB4WHc3v65pMXOKg4orYFpmLTf7r684y8Cd5fvr4v0ygO418z5g2EWylnpKPTsm9BNJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720815545; c=relaxed/simple;
	bh=j75+A2CPDkTXzVH0p2jm2anD/1NzuwTKh+LdMDfVKIE=;
	h=Date:To:From:Subject:Message-Id; b=DeyBUTQT1L1yjtxNmlSmJyCd6vGiBLoMjtC9v5VM4fjUMI6FZYMuStkwiFJfBNoQOSH00dThUhB4J8ccjAxyKTZqoIyoEEGYm8Qewpk56KMtWUgPksAHRwNiT0to6OumXI3J4DmUTzlzEaSkqVxHknoLsBYFxK8zKm2fmZGy3Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rkqKi482; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rkqKi482"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9CFC32782;
	Fri, 12 Jul 2024 20:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720815545;
	bh=j75+A2CPDkTXzVH0p2jm2anD/1NzuwTKh+LdMDfVKIE=;
	h=Date:To:From:Subject:From;
	b=rkqKi482jvPzgfWjrIFqFPLNNeGpc2OOBrJEG8wvpx32SMHiPJO6Z1IfZNBhOAxUH
	 LUbBp5YGljT2ctxhGkKJdgEQIAIVKAiAiw2Xu+L7CAS5gbCxQAZ/21VWs6odNpo9FH
	 DvIIf5nP8WU+a2pxW3Ro7Ab6+u5uct90CH48CMKE=
Date: Fri, 12 Jul 2024 13:19:04 -0700
To: mm-commits@vger.kernel.org,dan.carpenter@linaro.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-move-charge-migration-code-to-memcontrol-v1c-fix.patch added to mm-unstable branch
Message-Id: <20240712201905.5A9CFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg1: convert charge move flags to unsigned long long
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-move-charge-migration-code-to-memcontrol-v1c-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-move-charge-migration-code-to-memcontrol-v1c-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg1: convert charge move flags to unsigned long long
Date: Fri, 12 Jul 2024 18:35:14 +0000

Currently MOVE_ANON and MOVE_FILE flags are defined as integers
and it leads to the following Smatch static checker warning:
    mm/memcontrol-v1.c:609 mem_cgroup_move_charge_write()
    warn: was expecting a 64 bit value instead of '~(1 | 2)'

Fix this be redefining them as unsigned long long.

Even though the issue allows to set high 32 bits of mc.flags
to an arbitrary number, these bits are never used, so it doesn't
have any significant consequences.

Link: https://lkml.kernel.org/r/ZpF8Q9zBsIY7d2P9@google.com
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcg-move-charge-migration-code-to-memcontrol-v1c-fix
+++ a/mm/memcontrol-v1.c
@@ -44,8 +44,8 @@ static struct mem_cgroup_tree soft_limit
 /*
  * Types of charges to be moved.
  */
-#define MOVE_ANON	0x1U
-#define MOVE_FILE	0x2U
+#define MOVE_ANON	0x1ULL
+#define MOVE_FILE	0x2ULL
 #define MOVE_MASK	(MOVE_ANON | MOVE_FILE)
 
 /* "mc" and its members are protected by cgroup_mutex */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-move-charge-migration-code-to-memcontrol-v1c-fix.patch

