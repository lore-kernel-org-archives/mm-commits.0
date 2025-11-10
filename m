Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC208336EFD
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 19:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762804342; cv=none; b=HVORaYxTPFqy0NtP/cyP5xVEGnwRuikcJzRRuCoZFhYQpCsSUF+9QYJ82+J1bLb4xyNpm7M054wUUzoBgMa3HuIuHbrugIoGe5w+Qve6Q5+SXsBwxATGzyYn1yB7sJa85ndW5QoAMTwBn3U19rBt6X319mp4ZD5bQyQITMd3nJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762804342; c=relaxed/simple;
	bh=WX2cWxatGDiQvivqP8kgnvXtk8ZFF6lS20a8D7eqdcQ=;
	h=Date:To:From:Subject:Message-Id; b=SuS6LojLAe6mc/iPcCUYDbMuiNBme/nsH5gLHpzkgNtxhFz1NhKYQLPRc8mjG8n7DUP7WbaKK12N3lZpLEFjnVy0WclhYZ8dW0bCBWFM5X3B8SyVwLg1961RRzyol4ElvudbLjz3HmOzCehfffzB0pzGxoLF0GRCCU4hOu17Eqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=erdSkBFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="erdSkBFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C52C4CEF5;
	Mon, 10 Nov 2025 19:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762804342;
	bh=WX2cWxatGDiQvivqP8kgnvXtk8ZFF6lS20a8D7eqdcQ=;
	h=Date:To:From:Subject:From;
	b=erdSkBFwccNhnjAFjS3DzfRFJKpCy3bDOhrZAyR/hXjhTZ6i+9JMOKoIYPdQNprAf
	 Ath9DTlC+IP+MITBOjjTlRHPFjV8xRNq+I9CC629Mb2+wi8Y632+ScICCtOeolMsTQ
	 2g6JZMjGsYn0NrElFaAqYQLZsBqYnKohWBH5Rvww=
Date: Mon, 10 Nov 2025 11:52:21 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,harry.yoo@oracle.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-correct-the-comment-above-preempt_disable_nested.patch added to mm-new branch
Message-Id: <20251110195222.50C52C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmstat: correct the comment above preempt_disable_nested()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-correct-the-comment-above-preempt_disable_nested.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-correct-the-comment-above-preempt_disable_nested.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: vmstat: correct the comment above preempt_disable_nested()
Date: Mon, 10 Nov 2025 16:44:37 +0800

The comment explaining why these parts use preempt_disable_nested() is in
__mod_zone_page_state(), not in __mod_node_page_state(), so we should see
__mod_zone_page_state(). Just correct it.

Link: https://lkml.kernel.org/r/20251110084437.46701-1-qi.zheng@linux.dev
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-correct-the-comment-above-preempt_disable_nested
+++ a/mm/vmstat.c
@@ -392,7 +392,7 @@ void __mod_node_page_state(struct pglist
 		delta >>= PAGE_SHIFT;
 	}
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	x = delta + __this_cpu_read(*p);
@@ -438,7 +438,7 @@ void __inc_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_inc_return(*p);
@@ -461,7 +461,7 @@ void __inc_node_state(struct pglist_data
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_inc_return(*p);
@@ -494,7 +494,7 @@ void __dec_zone_state(struct zone *zone,
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_dec_return(*p);
@@ -517,7 +517,7 @@ void __dec_node_state(struct pglist_data
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_dec_return(*p);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmstat-correct-the-comment-above-preempt_disable_nested.patch

