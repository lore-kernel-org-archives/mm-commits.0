Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D513A8F7
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939661; cv=none; b=iDpx0k/obshvTijs4vJptS9el9fOcfmbRfaPzx1/7pX1k8j3SxliGA46HvC1mayow5pQjVTEFwWq0zqmvy4nfl+E4F8bqth/UpqJ8UdvdCJqsQhLNc6ruorSKaBuQ8GMW7i9pgLUF3yXZlYCdPHa2BM9HldRAEBTvoqqiHiX+5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939661; c=relaxed/simple;
	bh=OGpOlNqOqlkNSwS7fwjVlDNlBaEFzAGAUjZ98KLjVt4=;
	h=Date:To:From:Subject:Message-Id; b=oeK4o1AdOVzKNW6TOiWG5zIqYaDP0Bjt69lFDrzyyCoGyMaeRRlXTJcWNGBVWey3D+d7zw9jIowRRjbCzAzDEkYITesqsOugjbX2dsu1gZtDvaQebzmmXA6kPyA/RPbw6i89PzIw/CK5qG6MIKyJlYydTWDR04j3FlbtN136wfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eI0N9CsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eI0N9CsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24C0C4CECC;
	Sat, 30 Nov 2024 04:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939660;
	bh=OGpOlNqOqlkNSwS7fwjVlDNlBaEFzAGAUjZ98KLjVt4=;
	h=Date:To:From:Subject:From;
	b=eI0N9CsU+CoPFeB38oqT+6oZucvgLYnGHmnOY54lgsKFXmMo2iiqukUj6ahpY1LiT
	 rUI5ZixUihYkeqejE/cdarsf0n20PX3xGk++CoNP4u/ko4vBGt+W7eN6YyMjyqJvNV
	 JZBEX1qwfFgJeSom+njGtzwZKaUxV7/hGr7e4NV8=
Date: Fri, 29 Nov 2024 20:07:40 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kerensun@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-non-useful-else-after-a-break-in-a-if-statement.patch added to mm-unstable branch
Message-Id: <20241130040740.C24C0C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove the non-useful else after a break in a if statement
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-non-useful-else-after-a-break-in-a-if-statement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-non-useful-else-after-a-break-in-a-if-statement.patch

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
Subject: mm: remove the non-useful else after a break in a if statement
Date: Fri, 15 Nov 2024 15:57:44 -0800

Remove the else block since there is already a break in the statement of
if (iter->oom_lock), just set iter->oom_lock true after the if block ends.

Link: https://lkml.kernel.org/r/20241115235744.1419580-4-kerensun@google.com
Signed-off-by: Keren Sun <kerensun@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol-v1.c~mm-remove-the-non-useful-else-after-a-break-in-a-if-statement
+++ a/mm/memcontrol-v1.c
@@ -1134,8 +1134,8 @@ static bool mem_cgroup_oom_trylock(struc
 			failed = iter;
 			mem_cgroup_iter_break(memcg, iter);
 			break;
-		} else
-			iter->oom_lock = true;
+		}
+		iter->oom_lock = true;
 	}
 
 	if (failed) {
_

Patches currently in -mm which might be from kerensun@google.com are

mm-prefer-unsigned-int-to-bare-use-of-unsigned.patch
mm-remove-unnecessary-whitespace-before-a-quoted-newline.patch
mm-remove-the-non-useful-else-after-a-break-in-a-if-statement.patch

