Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBCA218AAF
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188564; cv=none; b=ZkGcZO1k21ACzUKc+eNZZ+L7d0N+b3kPqucPTLg0ZjDPyBVQ/rF/In8TlAujgOGdtQUKGjv5DnXLBslkUz5/e1lBrikjge0lHQoKOGdJlxryHf9FnwMX1pUeTRGrcLANZMACIHutAA/D1q8CxJ9Qk/svasp+y8V3sBxeslp/qv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188564; c=relaxed/simple;
	bh=ka5l+696XDnXWebZMG6GtyxzxqqbeHA6pJgKbx/s7Q0=;
	h=Date:To:From:Subject:Message-Id; b=NUkEfCqj6RQSQ+m6EbwwFdLe1eKWV0IFGEF8/aQP4y8X4o+d0kFe4SRtVH4bjnXnsL3sItcqbtzUcZfA5gNPn3gpz/vH55jGmY6k3vshljSwm171cHnxsfIyTrkGb54JR0Ow09hib7swUUDpZAlJ1N/FtBGNhKBpHRgZNcPWyTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jIxEVoFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jIxEVoFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093B2C4CEEC;
	Mon, 17 Mar 2025 05:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188564;
	bh=ka5l+696XDnXWebZMG6GtyxzxqqbeHA6pJgKbx/s7Q0=;
	h=Date:To:From:Subject:From;
	b=jIxEVoFTGQBMO60Sj6BqQ3523ZIrZFx9tj2MDGjOhZjdt7r7ml5Ks7qQmB69W6Izn
	 jELJ2nX09avhb/UIoVPAsYVkPK22zsX6eF+TkSG6z5uirmaqO0KJrEXhHTVBwU2nFc
	 Iokzwp+W4sJJF3ZpA8If2IFk7/DkS33ggeooM/GM=
Date: Sun, 16 Mar 2025 22:16:03 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-myself-as-shmem-reviewer.patch removed from -mm tree
Message-Id: <20250317051604.093B2C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Baolin as shmem reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-shmem-reviewer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: MAINTAINERS: add Baolin as shmem reviewer
Date: Fri, 7 Feb 2025 17:44:22 +0800

In the past year, I've primarily focused on shmem and added several
features to it, such as support for mTHP, large folio swap-out and swap-in
support, mTHP collapse support, skipping swapcache, and tmpfs support for
large folios, and so on.  Meanwhile I've also been helping with testing
and reviewing shmem related patches.

So I am willing to continue assisting with testing and reviewing shmem
related patches.  Let me be Cc'd on patches related to shmem.

Link: https://lkml.kernel.org/r/bcefbba9b2b44d4e661e6cc2c4187292a5beb467.1738918357.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-shmem-reviewer
+++ a/MAINTAINERS
@@ -23952,6 +23952,7 @@ F:	drivers/hwmon/tmp513.c
 
 TMPFS (SHMEM FILESYSTEM)
 M:	Hugh Dickins <hughd@google.com>
+R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/shmem_fs.h
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


