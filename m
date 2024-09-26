Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885B9184544
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384659; cv=none; b=XINSzqgYb5Wbzi6hOmT2s1Iq1XG5Mnwm/ukBdMhYhDmWXYihAw8vgi9NV1MVYodUuY1mLCJQyLYyLzFsF9KA5dx6eOWDpf6Ya0em9uQifLfwASKaSryDfZdZlfWVNQwdRBw1muyeckZdhHrSht0zL8X0qIFIDF2A1M2BJsRo8YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384659; c=relaxed/simple;
	bh=tcPJKiWgvS2W/KlNzuMjbPB4ewkJDM4Fy4l2tjDxNJM=;
	h=Date:To:From:Subject:Message-Id; b=cOuJ0+eUl4v4fA+dCynqYKGvoSF08Gh/ZNOzvfjp0T4CuWGbypmA/UhP3UXlt/kyco5fne5GJfXm4xE/GljyT2ITqAr8RdNxcLXRRqvRxCnto2Nn5QXgipECWW0N6KhpKenX9e4EgxLEivQRTFYKjVSfGzAbizastSS6znAYDBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=17vkHDzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="17vkHDzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA55C4CEC7;
	Thu, 26 Sep 2024 21:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384659;
	bh=tcPJKiWgvS2W/KlNzuMjbPB4ewkJDM4Fy4l2tjDxNJM=;
	h=Date:To:From:Subject:From;
	b=17vkHDzBxs2KINzQBITXHulG4fzQV9H2lSpbXe0dwQrn/nNWI6erVdgaxmIi34CZ/
	 84AgShIE/Z70fuSjJdm9kG0KehL2zN2bDO34DanwWfmj91d6c2HBnZ612LlWo7u+Cc
	 bxVkGJnkxUX2LcNHRzAUbXG0xQ4fRSJtUnhfiGok=
Date: Thu, 26 Sep 2024 14:04:18 -0700
To: mm-commits@vger.kernel.org,qiwu.chen@transsion.com,glider@google.com,elver@google.com,dvyukov@google.com,qiwuchen55@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-fix-elapsed-time-for-allocated-freed-track.patch removed from -mm tree
Message-Id: <20240926210419.2CA55C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kfence: fix elapsed time for allocated/freed track
has been removed from the -mm tree.  Its filename was
     mm-kfence-fix-elapsed-time-for-allocated-freed-track.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "qiwu.chen" <qiwuchen55@gmail.com>
Subject: mm: kfence: fix elapsed time for allocated/freed track
Date: Tue, 24 Sep 2024 16:50:04 +0800

Fix elapsed time for the allocated/freed track introduced by commit
62e73fd85d7bf.

Link: https://lkml.kernel.org/r/20240924085004.75401-1-qiwu.chen@transsion.com
Fixes: 62e73fd85d7b ("mm: kfence: print the elapsed time for allocated/freed track")
Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/report.c~mm-kfence-fix-elapsed-time-for-allocated-freed-track
+++ a/mm/kfence/report.c
@@ -109,7 +109,7 @@ static void kfence_print_stack(struct se
 	const struct kfence_track *track = show_alloc ? &meta->alloc_track : &meta->free_track;
 	u64 ts_sec = track->ts_nsec;
 	unsigned long rem_nsec = do_div(ts_sec, NSEC_PER_SEC);
-	u64 interval_nsec = local_clock() - meta->alloc_track.ts_nsec;
+	u64 interval_nsec = local_clock() - track->ts_nsec;
 	unsigned long rem_interval_nsec = do_div(interval_nsec, NSEC_PER_SEC);
 
 	/* Timestamp matches printk timestamp format. */
_

Patches currently in -mm which might be from qiwuchen55@gmail.com are


