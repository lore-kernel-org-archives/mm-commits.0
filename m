Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229AA208CA;
	Sun, 20 Jul 2025 02:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976892; cv=none; b=Uu6SHo8CF58CFz7Vv2bRF5euAvDWiAWvsYFeJj56c/2BPL0mAudfS6nazy8VPMZeHiBhC4VXYXwlNZjWa3U/4xgQkMbUzYoK3EszbzUg4RlFvGp1VE25TdZTJLOaafHNVzQJI9paqEt4JHvZgoI3ufTg/+Q3TIucYmIV+GAteW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976892; c=relaxed/simple;
	bh=R6Q65nkhf9SMmJHRgUq22aqQR5FnPcJTj7ZXdz8VVJM=;
	h=Date:To:From:Subject:Message-Id; b=rgTTb2PYmBBU9jELGUE3PqYQsobVA0NJDoL1NJEG0h70WTvZHADe5q5jhDuIzYf0DIoLwMYLezmDAK6QiWy0pJELg4Ccc2Vvk83ZxWN21F83zccKCgoJvR6w29pkNXRroK2ue/fQJGXaDxJ9KktcjD8AffoxsuYg7CCHHbYknbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iAw9G0zg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iAw9G0zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8FBC4CEE3;
	Sun, 20 Jul 2025 02:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976892;
	bh=R6Q65nkhf9SMmJHRgUq22aqQR5FnPcJTj7ZXdz8VVJM=;
	h=Date:To:From:Subject:From;
	b=iAw9G0zgSoKqcKQyizpjGV0uzYhlIR3cmyyIVRo8CIU/aXPODhsNigYhJLOc8E1vq
	 L34PcvIV8R5KrZFUS9NTnohCr7i2nihtCAkdsuLNMVX65s+LqMRJhpKZUEpSiTr3E0
	 OzdjwfcMu5Fz66f7sTYFr6cnP9ZOnJ2ptKBfUfx0=
Date: Sat, 19 Jul 2025 19:01:31 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-commit-damos-target_nid.patch removed from -mm tree
Message-Id: <20250720020131.EA8FBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: commit damos->target_nid
has been removed from the -mm tree.  Its filename was
     mm-damon-core-commit-damos-target_nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon/core: commit damos->target_nid
Date: Tue, 8 Jul 2025 19:47:29 -0500

When committing new scheme parameters from the sysfs, the target_nid field
of the damos struct would not be copied.  This would result in the
target_nid field to retain its original value, despite being updated in
the sysfs interface.

This patch fixes this issue by copying target_nid in damos_commit().

Link: https://lkml.kernel.org/r/20250709004729.17252-1-bijan311@gmail.com
Fixes: 83dc7bbaecae ("mm/damon/sysfs: use damon_commit_ctx()")
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-commit-damos-target_nid
+++ a/mm/damon/core.c
@@ -978,6 +978,7 @@ static int damos_commit(struct damos *ds
 		return err;
 
 	dst->wmarks = src->wmarks;
+	dst->target_nid = src->target_nid;
 
 	err = damos_commit_filters(dst, src);
 	return err;
_

Patches currently in -mm which might be from bijantabatab@micron.com are


