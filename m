Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAAC469831
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 05:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710242; cv=none; b=kXDtjc3Zk5Bo7YxHcIEcrDMovScikYwsxerub19p08CC7G+Yzt4uq267ZvwyVuRP4Mora40nmBc6YzWdyElC7cZVZaIGC2swO+oEmUZv605fbQS5NWQx6DSyYmzJjDoYGxadDs6YvZ62vRAmEyde47jTxlAL1QGIAEbJqZNRBt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710242; c=relaxed/simple;
	bh=GwkoPeys1IeG9OoN36uk+Bc151Xh2iaCNdicAAUUsgQ=;
	h=Date:To:From:Subject:Message-Id; b=DClU3Mj2jxrDHY979PSf+6R6ZA4otia0s+kn6aH98/j57EDWqrxPVZBIU90SY9cqGQDrqglAqcR3EbBlFRHmetW0AMV0SJ8+YgOubs8qKGUaLV1lWUaMBHAZFhf0//yFewE/GQh4f5CtEuFQ8lqQwZk9VmI+3MoQZOBr5B7tEGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F6fKPYJI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F6fKPYJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC89F1F00893;
	Fri, 18 Sep 2026 05:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789710241;
	bh=gK3QHf04XNSe5IobjIFRB/VuAi0eRUe95GbgBU6r23I=;
	h=Date:To:From:Subject;
	b=F6fKPYJI4wW+TsarrvhiT1lVHh7dfIu0CGgGIYU+ILWFp8SD7Uj6d9swGxsgfK5BR
	 UpjeKbSwFL0HER1nGxS+pxeyoRW7oS9TI8VDrXKGCDTJ+8ai44FMpJiyQ6IuKw6Pov
	 9fpLQw4C8n6J2Ozr8E28X01PRyts9vCw7315Fk9s=
Date: Thu, 17 Sep 2026 22:44:00 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,qi.zheng@linux.dev,kasong@tencent.com,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-baoquan-and-me-as-mglru-reviewers.patch removed from -mm tree
Message-Id: <20260918054400.EC89F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Baoquan and Baolin as MGLRU reviewers
has been removed from the -mm tree.  Its filename was
     maintainers-add-baoquan-and-me-as-mglru-reviewers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: MAINTAINERS: add Baoquan and Baolin as MGLRU reviewers
Date: Tue, 8 Sep 2026 09:42:12 +0800

Baoquan and I have been contributing MGLRU patches and helping review
MGLRU related patches for some time.  We will continue to follow MGLRU
changes, so we'd like to be CC'd on MGLRU related patches.

Link: https://lore.kernel.org/06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-baoquan-and-me-as-mglru-reviewers
+++ a/MAINTAINERS
@@ -17240,6 +17240,8 @@ R:	Barry Song <baohua@kernel.org>
 R:	Axel Rasmussen <axelrasmussen@google.com>
 R:	Yuanchu Xie <yuanchu@google.com>
 R:	Wei Xu <weixugc@google.com>
+R:	Baoquan He <baoquan.he@linux.dev>
+R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse.patch
mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

