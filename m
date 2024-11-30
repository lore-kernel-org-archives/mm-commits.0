Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717083A8F7
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939659; cv=none; b=l45h219EAmBWsy6s2zTLtee19bbK4e+tgbzB8fqSsC+BFgnfIuISdsA+RZU7wb/a73ZWd2zoqII86RkHVYVGv+rsmJYl4QYyIyZ07avMG33bYZ3i3GIAEj8q0rPCle+4I2U7bREizjetIBWO8jfBPlHeHo9TLnC860/rjSGZFYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939659; c=relaxed/simple;
	bh=RVDoSIvK/XTLwkyITELmSzmkfMtiwEHdN0Bl024MmOc=;
	h=Date:To:From:Subject:Message-Id; b=DeV3gYJug2r41d7I9TYQuJkTLshr/XZtvxmLk+5Ad1yVh2YnFWJs0zVo7ZbicEFMdhxDb6+u4cOckO+ohZhRcMZYdBA3O8WvWTd5x4oQq7y5Cd2AhGg3CihmWAIf5VH13+BxfsfubVQddLFcHlvlmB230NVcTh7rtS92Kr9dvb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f3ReGltf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f3ReGltf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA715C4CECC;
	Sat, 30 Nov 2024 04:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939658;
	bh=RVDoSIvK/XTLwkyITELmSzmkfMtiwEHdN0Bl024MmOc=;
	h=Date:To:From:Subject:From;
	b=f3ReGltfBFp46H1Vmz5GfxjVT6ePzPddXZAxoV87fTaqT9sqrgTaVPGLSsqeimjS4
	 yV68heWvw0RG/XQFreJx99uuJEJhUm9CGddq2d7KpvdP2+m1gPq19areZCnKPGM4z6
	 acNz0kdu3hMpH8HI3024dYpaE5iTOks+HYq56j68=
Date: Fri, 29 Nov 2024 20:07:38 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kerensun@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unnecessary-whitespace-before-a-quoted-newline.patch added to mm-unstable branch
Message-Id: <20241130040738.DA715C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unnecessary whitespace before a quoted newline
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unnecessary-whitespace-before-a-quoted-newline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unnecessary-whitespace-before-a-quoted-newline.patch

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
From: Keren Sun <kerensun@google.com>
Subject: mm: remove unnecessary whitespace before a quoted newline
Date: Fri, 15 Nov 2024 15:57:43 -0800

Remove whitespaces before newlines for strings in pr_warn_once()

Link: https://lkml.kernel.org/r/20241115235744.1419580-3-kerensun@google.com
Signed-off-by: Keren Sun <kerensun@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol-v1.c~mm-remove-unnecessary-whitespace-before-a-quoted-newline
+++ a/mm/memcontrol-v1.c
@@ -1040,13 +1040,13 @@ static ssize_t memcg_write_event_control
 	} else if (!strcmp(name, "memory.oom_control")) {
 		pr_warn_once("oom_control is deprecated and will be removed. "
 			     "Please report your usecase to linux-mm-@kvack.org"
-			     " if you depend on this functionality. \n");
+			     " if you depend on this functionality.\n");
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
 		pr_warn_once("pressure_level is deprecated and will be removed. "
 			     "Please report your usecase to linux-mm-@kvack.org "
-			     "if you depend on this functionality. \n");
+			     "if you depend on this functionality.\n");
 		event->register_event = vmpressure_register_event;
 		event->unregister_event = vmpressure_unregister_event;
 	} else if (!strcmp(name, "memory.memsw.usage_in_bytes")) {
@@ -1881,7 +1881,7 @@ static int mem_cgroup_oom_control_write(
 
 	pr_warn_once("oom_control is deprecated and will be removed. "
 		     "Please report your usecase to linux-mm-@kvack.org if you "
-		     "depend on this functionality. \n");
+		     "depend on this functionality.\n");
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
 	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
_

Patches currently in -mm which might be from kerensun@google.com are

mm-prefer-unsigned-int-to-bare-use-of-unsigned.patch
mm-remove-unnecessary-whitespace-before-a-quoted-newline.patch
mm-remove-the-non-useful-else-after-a-break-in-a-if-statement.patch

