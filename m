Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900DE79F5
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 02:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757124871; cv=none; b=U5VHAsyoPRNdd9Mlm6N5YzVWR1xfkRwbAqQOuyz62WNCdPyB4hnGKAOvRwgk6M/IwhicR2ui1t7zaADxfggwZV1kbi5iVQUjcGPX7NsGpng2X9OFu2bH/4vJfxbC+WMZ5GgQW5TGWEnpC53MbQ8UOtNA+Pt6qBA0iGOiFOUGi/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757124871; c=relaxed/simple;
	bh=/DpL6pbMYl70nczsmLikE4Iz95p8+y76FHfQLNHeb+w=;
	h=Date:To:From:Subject:Message-Id; b=bcsuZrGyW0+iUkBReaBO7+7jiklLZvahVVezepIA8MqBCC5gSwZsfILGmWGrSVUbzfW1JFOjuvTNaef18GTncbrFR8yMg+AZo1I5Bp2TvbtuxRupj9c73caH1fpz0ErDeBCi5ZYvnCzB9i+zxWfk2cyL+sDuobpl9A3i00ooFek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EFyGQTs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EFyGQTs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F71C4CEF1;
	Sat,  6 Sep 2025 02:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757124871;
	bh=/DpL6pbMYl70nczsmLikE4Iz95p8+y76FHfQLNHeb+w=;
	h=Date:To:From:Subject:From;
	b=EFyGQTs3Nl5Zpq0t0QC+4LdJUN5rc+A74naNpGxIALVMlMoogU1TuThZHC/w4hMMw
	 dityVyp+bf+uoo7/qcyOAbeLbBc6J2y58a6uqe+SqtV6oFAolsacs7vRXByZOdGZXd
	 dGR2wQh+gbp8OmzScPBk2bUAV7ie2ev4Bui0hdHU=
Date: Fri, 05 Sep 2025 19:14:30 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,zhangjiao2@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-cgroup-rm-unused-memcg_events-macro.patch added to mm-new branch
Message-Id: <20250906021431.04F71C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/cgroup: rm unused MEMCG_EVENTS macro
has been added to the -mm mm-new branch.  Its filename is
     samples-cgroup-rm-unused-memcg_events-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-cgroup-rm-unused-memcg_events-macro.patch

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
From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: samples/cgroup: rm unused MEMCG_EVENTS macro
Date: Wed, 3 Sep 2025 15:30:59 +0800

MEMCG_EVENTS is never referenced in the code. Just remove it.

Link: https://lkml.kernel.org/r/20250903073100.2477-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/cgroup/memcg_event_listener.c |    2 --
 1 file changed, 2 deletions(-)

--- a/samples/cgroup/memcg_event_listener.c~samples-cgroup-rm-unused-memcg_events-macro
+++ a/samples/cgroup/memcg_event_listener.c
@@ -18,8 +18,6 @@
 #include <sys/inotify.h>
 #include <unistd.h>
 
-#define MEMCG_EVENTS "memory.events"
-
 /* Size of buffer to use when reading inotify events */
 #define INOTIFY_BUFFER_SIZE 8192
 
_

Patches currently in -mm which might be from zhangjiao2@cmss.chinamobile.com are

samples-cgroup-rm-unused-memcg_events-macro.patch
fs-proc-basec-fix-the-wrong-format-specifier.patch

