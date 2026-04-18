Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D5D32E6B4
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498776; cv=none; b=py4iIY0P0B6GjsDZdO+acYDUP55Chnf/rBJn2gbE78OtFGgaULp3oeltQX2FXtvieVI/FRghmbEx1luzwOQdWI5vq17/fqjQ+yzf41CzoKXQ4fEQKBjAbgE00zztMeKOvFXZdzqOZbL7MhkBZU06zdrjpgGn8sKCafTaYnS99ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498776; c=relaxed/simple;
	bh=zDaeZjIU58NBfruXsGA+tZZKm5vwYw+31mHqY690zfs=;
	h=Date:To:From:Subject:Message-Id; b=e+MeSz0gFEdDSpMIqtZEq4Um1yfDCHNJdBq+YlNkjabeopdLNL4/ekAjTMBHzWhdr+Yp6StnOQuznApRhMmr7zx1+EOgoYjuDBmqo4VqbsrZtSlA6Z6KRWC27BEDWcsBqMWQMLJZgrX8jOuT0xhEqAZXVSgkz40exnz6xpzhffM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rxY98y/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rxY98y/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1255C19424;
	Sat, 18 Apr 2026 07:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498776;
	bh=zDaeZjIU58NBfruXsGA+tZZKm5vwYw+31mHqY690zfs=;
	h=Date:To:From:Subject:From;
	b=rxY98y/2bTrBP94xN8re7Ehbrwz5Y7okUA9KWZ+fpwMTkkP4pU9AslejaaEfGv9Vb
	 aD7Thp8DhTng8YhclN8QjehB3SwcrXO3QzIX+5SkLpFFD+VUTf91+56Ovo3UbJqPdp
	 g7k/BgXZooX87sh32Ou55sPf2rL0M/t8b/lBZZ3c=
Date: Sat, 18 Apr 2026 00:52:50 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-synchronize-lazy-initialization-of-flb-private-state.patch removed from -mm tree
Message-Id: <20260418075255.B1255C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: synchronize lazy initialization of FLB private state
has been removed from the -mm tree.  Its filename was
     liveupdate-synchronize-lazy-initialization-of-flb-private-state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: synchronize lazy initialization of FLB private state
Date: Fri, 27 Mar 2026 03:33:26 +0000

The luo_flb_get_private() function, which is responsible for lazily
initializing the private state of FLB objects, can be called concurrently
from multiple threads.  This creates a data race on the 'initialized' flag
and can lead to multiple executions of mutex_init() and INIT_LIST_HEAD()
on the same memory.

Introduce a static spinlock (luo_flb_init_lock) local to the function to
synchronize the initialization path.  Use smp_load_acquire() and
smp_store_release() for memory ordering between the fast path and the slow
path.

Link: https://lore.kernel.org/20260327033335.696621-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_flb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/luo_flb.c~liveupdate-synchronize-lazy-initialization-of-flb-private-state
+++ a/kernel/liveupdate/luo_flb.c
@@ -89,13 +89,18 @@ struct luo_flb_link {
 static struct luo_flb_private *luo_flb_get_private(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = &ACCESS_PRIVATE(flb, private);
+	static DEFINE_SPINLOCK(luo_flb_init_lock);
 
+	if (smp_load_acquire(&private->initialized))
+		return private;
+
+	guard(spinlock)(&luo_flb_init_lock);
 	if (!private->initialized) {
 		mutex_init(&private->incoming.lock);
 		mutex_init(&private->outgoing.lock);
 		INIT_LIST_HEAD(&private->list);
 		private->users = 0;
-		private->initialized = true;
+		smp_store_release(&private->initialized, true);
 	}
 
 	return private;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-fix-return-value-on-session-allocation-failure.patch

