Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411B5186E20
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855674; cv=none; b=Urv/xybhWllgM9ddbr5q5VC+qZN06brO4CLYjpsUH7OkdT5lYoaMHagUO+iwW2V6UeapXfBCZDhYrPVo2Ym5QUdMIdwujYTvsEZbQEXdzO/0UPbOe6pHzwQG1ykk6+7fJYPzJMAYNqN3AzdWeh9NPoE9gL7KswEudCwLkFjK2wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855674; c=relaxed/simple;
	bh=+K5tc2VF1aDhoJlV0OhwXHt48i93yCvGFP8r9hz0OXQ=;
	h=Date:To:From:Subject:Message-Id; b=Yw81USwtqi/BBL0EiIVs6jW5EuUY6nHYOFkW4KIYZMVpiILKN1A5B6jhXS09bjb9T3m5YE4/la1P1Icp/CeF+6uzuIHKMqND3xBzzwpqiZyjTvn5iozmr6bfSC0UwmjD0bHr0JvAsZZpDLXcKUdedTgkWHkA3JPH64v6zG31SiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EdF1u/Zi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EdF1u/Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15201C4CECF;
	Wed,  6 Nov 2024 01:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855674;
	bh=+K5tc2VF1aDhoJlV0OhwXHt48i93yCvGFP8r9hz0OXQ=;
	h=Date:To:From:Subject:From;
	b=EdF1u/ZirDQzUooDMYRs1nR18jQZQCAo9DkIX9PI3oKgPfgSxTeQ8ijpD6RQbmuUy
	 HJ1NRnwdfd+NZTp66BN14YgfyK4v3wEgN7jnA/hdur9nS5ufgwlNVsFMRNV495M9HU
	 z3D3aUUgoLX0ZMNieQqhU/lMU36RalSKAYOOfvn8=
Date: Tue, 05 Nov 2024 17:14:33 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,linux@weissschuh.net,libang.li@antgroup.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jsiddle@redhat.com,joel.granados@kernel.org,j.granados@samsung.com,david@redhat.com,cunhuang@tencent.com,baolin.wang@linux.alibaba.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-add-docs-for-hung_task_detect_count.patch removed from -mm tree
Message-Id: <20241106011434.15201C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: add docs for hung_task_detect_count
has been removed from the -mm tree.  Its filename was
     hung_task-add-docs-for-hung_task_detect_count.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: hung_task: add docs for hung_task_detect_count
Date: Sun, 27 Oct 2024 20:07:47 +0800

This commit introduces documentation for hung_task_detect_count in
kernel.rst.

Link: https://lkml.kernel.org/r/20241027120747.42833-3-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Cun <cunhuang@tencent.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Siddle <jsiddle@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Yongliang Gao <leonylgao@tencent.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-add-docs-for-hung_task_detect_count
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -401,6 +401,15 @@ The upper bound on the number of tasks t
 This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
 
 
+hung_task_detect_count
+======================
+
+Indicates the total number of tasks that have been detected as hung since
+the system boot.
+
+This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
+
+
 hung_task_timeout_secs
 ======================
 
_

Patches currently in -mm which might be from ioworker0@gmail.com are


