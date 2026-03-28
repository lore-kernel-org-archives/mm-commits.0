Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075F72D1913
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671877; cv=none; b=Vj9iUhLRTDMtekDJ4W6N8PIvh10v5K4XTaA8g64fRjRmrXw8neDA4IDNb4kHdI+49PUrRQA+cHH4Lt/udAA+uy7PRi2bXYWNuZ79SN5cpJkA6iV9872Sq+yZkTUOOc+Kq1dzrJ+3pbr/bV4XhOACcHs5zQdhH6VpyW9PzEFxGss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671877; c=relaxed/simple;
	bh=3WpcAIoX0ZwBWRgDinPCHHRKX21+Bze8YKm+hcaEZWI=;
	h=Date:To:From:Subject:Message-Id; b=d+iplL7CfbDet/xZd9gkZ1ZE0dOAA76H8sjmmHUOpjtrGzo196DcLNhZtZ3xWrLSeHsDtShEXmwJYXzt0ZLjELeKSYha4h+TDP2BaXY9dKZMrNSUDIQ8RDbn+wH1Qm4W7SVICG/rk+B4y13bXMNfEJzzvzAC2vi3D30c9tvQxVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RGDT6TYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RGDT6TYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C25C4CEF7;
	Sat, 28 Mar 2026 04:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671876;
	bh=3WpcAIoX0ZwBWRgDinPCHHRKX21+Bze8YKm+hcaEZWI=;
	h=Date:To:From:Subject:From;
	b=RGDT6TYEfQ5f15an+WvnADyUzP/2S6uhK5eFUAljoDHgcf2QML7hQzHKWkRioS0yS
	 0ALk+oDELEsU6M4VaCPZN0kL7+Wf9ItuSHY4vRxf7bQNkkNczvxrDXazAFXqvBFiPR
	 o5P8M7t7hjynAlP9C2qtV0wELSPsxfTGyDxD7Uns=
Date: Fri, 27 Mar 2026 21:24:35 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,brauner@kernel.org,jaime.saguillo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-array-drop-stale-fixme-about-rcu-in-task_sig.patch removed from -mm tree
Message-Id: <20260328042436.75C25C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: array: drop stale FIXME about RCU in task_sig()
has been removed from the -mm tree.  Its filename was
     proc-array-drop-stale-fixme-about-rcu-in-task_sig.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jaime Saguillo Revilla <jaime.saguillo@gmail.com>
Subject: proc: array: drop stale FIXME about RCU in task_sig()
Date: Sun, 15 Feb 2026 12:45:11 +0000

task_sig() already wraps the SigQ rlimit read in an explicit RCU read-side
critical section.  Drop the stale FIXME comment and keep using
task_ucounts() for the ucounts access.

No functional change.

Link: https://lkml.kernel.org/r/20260215124511.14227-1-jaime.saguillo@gmail.com
Signed-off-by: Jaime Saguillo Revilla <jaime.saguillo@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/array.c~proc-array-drop-stale-fixme-about-rcu-in-task_sig
+++ a/fs/proc/array.c
@@ -280,7 +280,7 @@ static inline void task_sig(struct seq_f
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = get_nr_threads(p);
-		rcu_read_lock();  /* FIXME: is this correct? */
+		rcu_read_lock();
 		qsize = get_rlimit_value(task_ucounts(p), UCOUNT_RLIMIT_SIGPENDING);
 		rcu_read_unlock();
 		qlim = task_rlimit(p, RLIMIT_SIGPENDING);
_

Patches currently in -mm which might be from jaime.saguillo@gmail.com are


