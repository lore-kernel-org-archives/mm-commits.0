Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04D5246335
	for <mm-commits@vger.kernel.org>; Tue,  5 Aug 2025 20:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754425775; cv=none; b=QM2GswWyAoC42Ymqfm/047kcC+bjpg7odW48Xjq9TfksR+ah3S0aoY2r+3lD1XQGruJsnuQ+tEPmCT6hBhUu4fgC9rjOpsmMtOdXOVE0VztrNWlBQWzaFfjqmot6Jhe23M3Aw9BokDK5qvUL0CiBdqihUYLy/zUfVJHflMSifQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754425775; c=relaxed/simple;
	bh=aqr4OZOnY+dIuVlPzU13O5wZoDPCtJzw2nRzUAni4oI=;
	h=Date:To:From:Subject:Message-Id; b=Z4ph/Kx2d21WC4yAVYEqwY4Noc4nnSSfXlGnwqFzDrk+uXARpVan5F3wEntE80f5M/KSTYXdWZZbqARjAAmBTrGNYNQJjXdGM0ykTrsFlCQtLosWVbHesCKxmO5uAaTxy8g0+qNySW5T4NYhqdub+wNKISYUk5v6WNAm2hfM+A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X7USIU/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X7USIU/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84872C4CEF0;
	Tue,  5 Aug 2025 20:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754425775;
	bh=aqr4OZOnY+dIuVlPzU13O5wZoDPCtJzw2nRzUAni4oI=;
	h=Date:To:From:Subject:From;
	b=X7USIU/aJUi0pqjEUGBQHIu16j+kvfHx7MV/gebQqLG68xbOOpidKwiJKy/x12zqO
	 g8Ba3qsyR7WON1ElVWijtMj1uL7SGFRGvTkKI//F+ZJkzAzLYMx6lvDdwRIfwXkNks
	 pePxi4Ascr1ZNtdRl1BFJG+eFfC1xBQgOxJmFygQ=
Date: Tue, 05 Aug 2025 13:29:34 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-masami-as-a-reviewer-of-hung-task-detector.patch removed from -mm tree
Message-Id: <20250805202935.84872C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Masami as a reviewer of hung task detector
has been removed from the -mm tree.  Its filename was
     maintainers-add-masami-as-a-reviewer-of-hung-task-detector.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: MAINTAINERS: add Masami as a reviewer of hung task detector
Date: Wed, 30 Jul 2025 23:25:08 +0900

Since I'm actively working on hung task blocker detector, add myself to a
reviewer of the HUNG TASK DETECTOR feature.

Link: https://lkml.kernel.org/r/175388550841.627474.3260499035226455392.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-masami-as-a-reviewer-of-hung-task-detector
+++ a/MAINTAINERS
@@ -11438,6 +11438,7 @@ F:	drivers/tty/hvc/
 HUNG TASK DETECTOR
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Lance Yang <lance.yang@linux.dev>
+R:	Masami Hiramatsu <mhiramat@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/hung_task.h
_

Patches currently in -mm which might be from mhiramat@kernel.org are

hung_task-dump-blocker-task-if-it-is-not-hung.patch

