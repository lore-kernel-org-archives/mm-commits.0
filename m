Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1568372673
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028766; cv=none; b=KnujXEKnYxUqlZQUqpl9KIFJbiKtw23bjQxzilqbLh6mrJBBmg/+oN5O6PMCPwefHVl88h6JyQMt9sgctsLcqW0ZyhK/cB7O9ZXRorC/Ar895bXzq/7WouXk4WKf4Q68m6HlnzPVMGDHOaZvLRM+L3ntBOphcPGv2o4xGeasIdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028766; c=relaxed/simple;
	bh=LQD/uE4NlbCwZamyQlwToS+5mu5dtX+lIRQyjqwZQm8=;
	h=Date:To:From:Subject:Message-Id; b=hHrzaRt33Q7IA6rPO5z0jD1GQ6wWeLVsFwiyaGjXmmp/NIU+aWfkEU1vGKiDu9TiQVawY3uZcGAo+L2dkP0fMVQ/EPs/F+t3beOcY4ho4/e1o1LwJcmACaIPjdhYKc59enmZddlAcxSSfNbfgwqN6tbu1kK4NZqsKloVCMjk5d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=egsKTBvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="egsKTBvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88001F00893;
	Fri, 29 May 2026 04:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028764;
	bh=726A6jik/NE8Qc5dCA7DxLS/wtj7ZtcOQ5BMXTG8wnM=;
	h=Date:To:From:Subject;
	b=egsKTBvyYrGywObRJ92eC5SCk0KnfvaKbSJUJXTUgs/DZsG7KAO5pWbve51QOR1Nt
	 m7FGtuAmi7c1hmuDc5IKumGXqyzK6whu4a+OnqFMmB4whaIq3gGBXTs3+8Bxweq4df
	 7WQulMuDrsDkQxeKzGnwM4Y+Muk/K29y+NAubgoA=
Date: Thu, 28 May 2026 21:26:04 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,paulmck@kernel.org,axboe@kernel.dk,phasta@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] llist-make-locking-comments-consistent.patch removed from -mm tree
Message-Id: <20260529042604.B88001F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: llist: make locking comments consistent
has been removed from the -mm tree.  Its filename was
     llist-make-locking-comments-consistent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Philipp Stanner <phasta@kernel.org>
Subject: llist: make locking comments consistent
Date: Thu, 7 May 2026 11:49:19 +0200

llist's locking requirement table has a legend which claims that all
operations not needing a lock a marked with '-', whereas in truth for some
table entries just a whitespace is used.

Add the '-' to all appropriate places.

Link: https://lore.kernel.org/20260507094918.23910-2-phasta@kernel.org
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/llist.h~llist-make-locking-comments-consistent
+++ a/include/linux/llist.h
@@ -26,8 +26,8 @@
  *
  *           |   add    | del_first |  del_all
  * add       |    -     |     -     |     -
- * del_first |          |     L     |     L
- * del_all   |          |           |     -
+ * del_first |    -     |     L     |     L
+ * del_all   |    -     |     -     |     -
  *
  * Where, a particular row's operation can happen concurrently with a column's
  * operation, with "-" being no lock needed, while "L" being lock is needed.
_

Patches currently in -mm which might be from phasta@kernel.org are


