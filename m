Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABFA18B47E
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 03:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738121411; cv=none; b=oN4ODredSt2fNkm5m8foNkZ0NfeP32ItK7oWCioTT1xE4Mko8CoDj5IbvLXddBGJaops9j8SGWQkSXMP2IgJM3S2mipydtStPEyr+J0SjzAMrQdydHhb48kP1sv4ZNBmtRXkGWEE2IdIyMOj6fRCkTcJVY9fQElIcIx8VKyTfDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738121411; c=relaxed/simple;
	bh=TWBdx33KMh1o2AUEDOYIbhupTBUekHfvLa651dkEn6M=;
	h=Date:To:From:Subject:Message-Id; b=FFbETCV47tiLM11fJDJq3fGLevAMG2nD8blvrsKnRsXsAD+I209OFANgZRxwV1XAPNPmZBU+clvzk+UEefGPRHPwXDyYqQwbzvl0JVLTS/VJM2nKgXX2Sv6csgZOdJfzJqBK/+/A/i77LYwmvGqV3tZ2sb1Wf8jXM3IK0Bglrec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0G5nv+4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0G5nv+4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73517C4CED3;
	Wed, 29 Jan 2025 03:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738121410;
	bh=TWBdx33KMh1o2AUEDOYIbhupTBUekHfvLa651dkEn6M=;
	h=Date:To:From:Subject:From;
	b=0G5nv+4fit4qZj9RfAQp+3sAYlTaBgBzbjpsBqOnFHqfi/6s9YjWCLTqRFa0SURvs
	 fr+OG3+iG2T62ghicluPC+kshcJbssasKwJ++biS7qSI/BdEYmM1cd/VXhL27+jA36
	 YtujjUzcnC7eTtNJWqtCKifiTCNjKZOuASuGFXwk=
Date: Tue, 28 Jan 2025 19:30:09 -0800
To: mm-commits@vger.kernel.org,richard120310@gmail.com,jserv@ccns.ncku.edu.tw,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-plistc-add-shortcut-for-plist_requeue-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250129033010.73517C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-plistc-add-shortcut-for-plist_requeue-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-plistc-add-shortcut-for-plist_requeue-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-plistc-add-shortcut-for-plist_requeue-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-plistc-add-shortcut-for-plist_requeue-fix
Date: Tue Jan 28 07:27:41 PM PST 2025

tweak comment and code layout

Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: I Hsin Cheng <richard120310@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/lib/plist.c~lib-plistc-add-shortcut-for-plist_requeue-fix
+++ a/lib/plist.c
@@ -171,12 +171,13 @@ void plist_requeue(struct plist_node *no
 
 	plist_del(node, head);
 
-	/* After plist_del(), iter is the replacement of node
-	 * , if node was on prio_list, then take shortcut to
-	 * find node_next instead of looping.
+	/*
+	 * After plist_del(), iter is the replacement of the node.  If the node
+	 * was on prio_list, take shortcut to find node_next instead of looping.
 	 */
 	if (!list_empty(&iter->prio_list)) {
-		iter = list_entry(iter->prio_list.next, struct plist_node, prio_list);
+		iter = list_entry(iter->prio_list.next, struct plist_node,
+				  prio_list);
 		node_next = &iter->node_list;
 		goto queue;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-plistc-add-shortcut-for-plist_requeue-fix.patch

