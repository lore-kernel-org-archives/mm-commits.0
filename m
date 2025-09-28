Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24AA25A350
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085550; cv=none; b=DKXKdT/EHyu8sUrmX46ZVuNw2kDEIQnkrdUVjTZntf/ApsIYN0D06kQ5GwdYlStLjBWZE3bhBlxe27kuzbekzmLilyfxmsGdOEGfhQvHNC13ly1A5L0pZx+c1JLnRKm4x24KsBDaLecjO51RFBv0VZrx6LkemkC1jPdKg3wDHVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085550; c=relaxed/simple;
	bh=Zv2JraAwPoi7gxyIKnIOL2kuYgkSzvYOwmGjKuDGV1E=;
	h=Date:To:From:Subject:Message-Id; b=evVrVP2g2GGGysMhB4wf2fguocHATJGOme1JbXn4rUNPYYtWsOEIBuGApGvwQA06f1fjI7lBuXV7oY3b1gWXzkBlrwcykT7Ok0L8ElBLY2x4ExV7i49Hg29syvfQUoMPstPnovr14BRLECr2bkoU2UpkQk87v7Q0vQjWSyL7XnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MU5SMhNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MU5SMhNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46195C4CEF0;
	Sun, 28 Sep 2025 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085550;
	bh=Zv2JraAwPoi7gxyIKnIOL2kuYgkSzvYOwmGjKuDGV1E=;
	h=Date:To:From:Subject:From;
	b=MU5SMhNR2E9POCjway5qpBqGVM9x9iAqEoh5DqlQSVAmOwvAEXyqnU/ouuM7/szlL
	 x7y2Pt5jrKeDa/x7sTI5FRY65oXUAgxSIQqgc6xSEeeZxXINoquyYATMp9fQkPzlJl
	 c/p2vwfnoJOhOj8CiG26Cj0paESl8eqqIng/AFC0=
Date: Sun, 28 Sep 2025 11:52:29 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,elver@google.com,david@redhat.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-silence-data-race-in-update_hiwater_rss.patch removed from -mm tree
Message-Id: <20250928185230.46195C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: silence data-race in update_hiwater_rss
has been removed from the -mm tree.  Its filename was
     mm-silence-data-race-in-update_hiwater_rss.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm: silence data-race in update_hiwater_rss
Date: Fri, 26 Sep 2025 17:24:26 +0800

KCSAN reports a data race on mm_cluster.hiwater_rss, which can be accessed
concurrently from various paths like page migration and memory unmapping
without synchronization.

Since hiwater_rss is a statistical field for accounting purposes, this
data race is benign.  Annotate both the read and write accesses with
data_race() to make KCSAN happy.

Link: https://lkml.kernel.org/r/20250926092426.43312-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reported-by: syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/68d6364e.050a0220.3390a8.000d.GAE@google.com
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marco Elver <elver@google.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-silence-data-race-in-update_hiwater_rss
+++ a/include/linux/mm.h
@@ -2742,7 +2742,7 @@ static inline void update_hiwater_rss(st
 	unsigned long _rss = get_mm_rss(mm);
 
 	if (data_race(mm->hiwater_rss) < _rss)
-		(mm)->hiwater_rss = _rss;
+		data_race(mm->hiwater_rss = _rss);
 }
 
 static inline void update_hiwater_vm(struct mm_struct *mm)
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch
mm-clean-up-is_guard_pte_marker.patch

