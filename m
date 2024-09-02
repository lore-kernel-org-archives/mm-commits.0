Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506CC2D057
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247825; cv=none; b=jlPTPNawIJiEVa1CIjCApPmU0oPALIitW7k02C9pDwx3VRilK3liZQz/ucAMWNehMkxaaKMwwscb514OK+tBfitvrZg2M6bVjYvIP/VDsa67/zmcP2yYAupeEwDBEh0pI8hKqO3egiYJAm9wWCNgw4ZGxbi9oh84hYo1A7q5jPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247825; c=relaxed/simple;
	bh=xNnYUHMiThM9aD8j/IQQfPWaIihRLOGqqeUwB19xs2I=;
	h=Date:To:From:Subject:Message-Id; b=Z0yhjgW6B0lgqnd34ML9sF59uzOWikT14Joqh7RD6XNG+uPwoJGQDn5o9/crrVJ51xjBWHERMOQOsB0QHnNz1cX0aAGNaay5pwCITX6I31lpglQADdkmvze2Jn0VvQo6HPDCVq9W7V3yztW5OhnCrIcALiMmASMqk7eOf9ipVG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L8MhVeuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L8MhVeuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274B0C4CEC2;
	Mon,  2 Sep 2024 03:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247825;
	bh=xNnYUHMiThM9aD8j/IQQfPWaIihRLOGqqeUwB19xs2I=;
	h=Date:To:From:Subject:From;
	b=L8MhVeuVFbiLe8l90lBDWd237+cIewxlQxqO2sGh2nd8SfbyUGDzt0kpP1HaSc7Pq
	 XkXUKYRGhbWlErzVoCIZFqT8cXPkQivQTmiuiHO0z2BOxaQrIbfFNPkY8Ere281fLy
	 fCDSLkPi1ZYYuZ/nxB/tksJge9iSutlSTo7OjSx8=
Date: Sun, 01 Sep 2024 20:30:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-introduce-mas_wr_prealloc_setup.patch removed from -mm tree
Message-Id: <20240902033025.274B0C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: introduce mas_wr_prealloc_setup()
has been removed from the -mm tree.  Its filename was
     maple_tree-introduce-mas_wr_prealloc_setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: introduce mas_wr_prealloc_setup()
Date: Wed, 14 Aug 2024 12:19:29 -0400

Introduce a helper function, mas_wr_prealoc_setup(), that will set up a
maple write state in order to start a walk of a maple tree.

Link: https://lkml.kernel.org/r/20240814161944.55347-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-introduce-mas_wr_prealloc_setup
+++ a/lib/maple_tree.c
@@ -5399,6 +5399,13 @@ reset:
 	mas_reset(wr_mas->mas);
 }
 
+static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
+{
+	struct ma_state *mas = wr_mas->mas;
+
+	mas_wr_store_setup(wr_mas);
+	wr_mas->content = mas_start(mas);
+}
 /* Interface */
 
 /**
@@ -5509,8 +5516,7 @@ int mas_preallocate(struct ma_state *mas
 	if (unlikely(!mas->index && mas->last == ULONG_MAX))
 		goto ask_now;
 
-	mas_wr_store_setup(&wr_mas);
-	wr_mas.content = mas_start(mas);
+	mas_wr_prealloc_setup(&wr_mas);
 	/* Root expand */
 	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
 		goto ask_now;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


