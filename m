Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF662FB2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189483; cv=none; b=gtHx1eBrfuDZCCy+eIFs670pJyN2F0dhskEJ7KLmuB7S9Yh4NrAmFEdM4qHg8lw7ldGwQp0DyBFaom4noTNf2I8ZQyg6PlK8DmFGGPUUbqL9mnVVkWXFNX2FEfms9FzACxYTGtPYqLdee6x5t8KUKA09gymOJVtC40qIsJjXYHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189483; c=relaxed/simple;
	bh=8f+nvHRnTnm4aRaP7WKTkhnxQ8HeZUQpAHS5rQCB6L8=;
	h=Date:To:From:Subject:Message-Id; b=umSyYLSdD9h64gkKawlUykMFI1+Jn6Lt0nHPJFPfjUM+yy7fBbK1ignRIswuZHmTwYshfT5qTb/PE4vvyZ47T6zHATCs7YIg2qzNeZgLBrSa/mP7L2c0bkOojpEpIi8/O0SXxXzUvuhYzXuCpUZ0yNjJSN6qoHUsczYxWxgqygI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ixJswwjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ixJswwjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2786EC4CEEC;
	Mon, 17 Mar 2025 05:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189483;
	bh=8f+nvHRnTnm4aRaP7WKTkhnxQ8HeZUQpAHS5rQCB6L8=;
	h=Date:To:From:Subject:From;
	b=ixJswwjcxwXe7X/misnlr8ar065Zk3D+hNLdXtL/zTq+62NLmve2E4PKe+cWYC7NH
	 k81vTu3hW+HcG+W6K4xmAqDIVEfE1ePJgMNXnoUU+WhLcDZN+QG7h1xomkXfaXqk/y
	 s4GS9L9W3GUOv9GpycozFu90CffNrBV9yTUHPs1g=
Date: Sun, 16 Mar 2025 22:31:22 -0700
To: mm-commits@vger.kernel.org,bsingharora@gmail.com,yang.yang29@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-yang-yang-as-a-co-maintainer-of-per-task-delay-accounting.patch removed from -mm tree
Message-Id: <20250317053123.2786EC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Yang Yang as a co-maintainer of PER-TASK DELAY ACCOUNTING
has been removed from the -mm tree.  Its filename was
     maintainers-add-yang-yang-as-a-co-maintainer-of-per-task-delay-accounting.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: MAINTAINERS: add Yang Yang as a co-maintainer of PER-TASK DELAY ACCOUNTING
Date: Fri, 17 Jan 2025 22:20:13 +0800 (CST)

Balbir Singh is the unique maintainer of PER-TASK DELAY ACCOUNTING, and he
had started work on cgroupstats a long time back, this subsystem then is
not growing at a very rapid pace.  With their excellent work delay
accounting is still very useful for observing and optimizing system delay,
but still needs continuous improvement.  Yang Yang with his team had
worked for most of the recent patches of the subsystem, and he has a
strong willing to help, Balbir Singh is glad to see that, so add him as a
co-maintainer.

Link: https://lkml.kernel.org/r/20250117222013817zWHgBaSigRI_eRJt1hqnu@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-yang-yang-as-a-co-maintainer-of-per-task-delay-accounting
+++ a/MAINTAINERS
@@ -18513,6 +18513,7 @@ F:	mm/percpu*.c
 
 PER-TASK DELAY ACCOUNTING
 M:	Balbir Singh <bsingharora@gmail.com>
+M:	Yang Yang <yang.yang29@zte.com.cn>
 S:	Maintained
 F:	include/linux/delayacct.h
 F:	kernel/delayacct.c
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are


