Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C109A17741
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374255; cv=none; b=mtnZN3EGGVrsLkMAxTDrRYJE86hRz5i4w52qSRF0nDW3UnSDkXgeyPXwV9s5QYVMyLOknbeKlzBxxQEeF1yP4OzSS7l2Cgk76LqBUs2QxNqvygWme+j4qQqvNCh7/eslSwEYHKhZT5bb310kUw4uw8We+0zd09ec54AGSxqcSpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374255; c=relaxed/simple;
	bh=+K5tc2VF1aDhoJlV0OhwXHt48i93yCvGFP8r9hz0OXQ=;
	h=Date:To:From:Subject:Message-Id; b=cnfm9f4xiWp+2onJt00TMuhTkLmWS6Dc+8fjUJTpLxynBNgQlv1hXdTkF4kvVYy66mEUFjJESGrzQLZstpjwFN2crnTsZTPixP886Yl5sRRNvHmnEVRMSNoK34D55A2BavLmZbM7Fas4zRlk+mhhdAHtugA9eTEzNtFDtPJV+qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R7lXE0du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R7lXE0du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50242C4CED5;
	Tue, 12 Nov 2024 01:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374255;
	bh=+K5tc2VF1aDhoJlV0OhwXHt48i93yCvGFP8r9hz0OXQ=;
	h=Date:To:From:Subject:From;
	b=R7lXE0duv7Ni5d45d9iv0/KqdAKVHH0ZfF+Yh68Pcqiu4ZfVEsUtYYExMzsdsOJYn
	 dja/1R96h6P+a5mjClnShEobuN0OpIJvae0XkOcx8Jj/sICy4qwTeGm3UiQCQZSGR/
	 QKntn14Pz6tzGf5/9vDXw0d1lmDjZ77Vf1+iLeIk=
Date: Mon, 11 Nov 2024 17:17:34 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,linux@weissschuh.net,libang.li@antgroup.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jsiddle@redhat.com,joel.granados@kernel.org,j.granados@samsung.com,david@redhat.com,cunhuang@tencent.com,baolin.wang@linux.alibaba.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-add-docs-for-hung_task_detect_count.patch removed from -mm tree
Message-Id: <20241112011735.50242C4CED5@smtp.kernel.org>
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


