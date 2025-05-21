Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE9A32C85
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 05:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806614; cv=none; b=RPvjLMzy4CVIkxsnljhlRmYJmU24i8tDs0RwXffg4uq7RQi1xsSjqZV6xCwsqTR9YgrbBZnAAFV99nwh5WfTFN8aDxTIcOTx0BWPKQ1HMZKMmPioHBgXSBwkFMZcRTmdJOfgO1IljPIg6UatFh7+OYeaOQn+x16K31UC6cWFrFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806614; c=relaxed/simple;
	bh=rPA8piKcZYEoJfNn/SwBvSgkc46dMSI41sX0AlopIqQ=;
	h=Date:To:From:Subject:Message-Id; b=jLiI/fUSZrkWGKBgc0emIQmT7+OquzynJ0qQ2RairC9E6oYM2OTcSTdmZqKjnuZGYLKykU1v1vUL0FzNxS+cs/L4IWC1i2lxdh3vEorCAULZi90yn/KbpIZIy+FPiVHpHNN4wHXOPf9ZMB/wy76uJnajiz/kU8qz638ONrPvV/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o1Kbk7gW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o1Kbk7gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D5CC4CEE4;
	Wed, 21 May 2025 05:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806613;
	bh=rPA8piKcZYEoJfNn/SwBvSgkc46dMSI41sX0AlopIqQ=;
	h=Date:To:From:Subject:From;
	b=o1Kbk7gWuPwG3ftgZKyOwPJVagsB9A+wbwIwKMO10Qh7jgbzoP9mvMtRcOZtT0Eig
	 v3llhJqrJP+j2V2wq4qFi0H7rlrcdMw/Z9GHktl7zOSLqVBV9fyPqxsb+N0lM5xcDd
	 GG0YyW8hvYsAw4tQvGuK3RW8HBwb8v0ktLlfzT0s=
Date: Tue, 20 May 2025 22:50:13 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-hung-task-detector-section.patch removed from -mm tree
Message-Id: <20250521055013.97D5CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add hung-task detector section
has been removed from the -mm tree.  Its filename was
     maintainers-add-hung-task-detector-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: MAINTAINERS: add hung-task detector section
Date: Tue, 13 May 2025 13:22:34 +0800

The hung-task detector is missing in MAINTAINERS.  While it's been quiet
recently, I'm actively working on it and volunteering to review patches. 
Adding this section will make it easier for contributors to know who to
contact.

Link: https://lkml.kernel.org/r/20250513052234.46463-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/MAINTAINERS~maintainers-add-hung-task-detector-section
+++ a/MAINTAINERS
@@ -11099,6 +11099,14 @@ L:	linuxppc-dev@lists.ozlabs.org
 S:	Odd Fixes
 F:	drivers/tty/hvc/
 
+HUNG TASK DETECTOR
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Lance Yang <lance.yang@linux.dev>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	include/linux/hung_task.h
+F:	kernel/hung_task.c
+
 I2C ACPI SUPPORT
 M:	Mika Westerberg <westeri@kernel.org>
 L:	linux-i2c@vger.kernel.org
_

Patches currently in -mm which might be from lance.yang@linux.dev are


