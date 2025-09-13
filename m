Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D6823D7DB
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 20:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794175; cv=none; b=fnt9zhOCwJkG0Uab7k5BGAB1gJ6AMB0jHjQxqTAt1tRg5YP7AF277L/Beq4a70M4Y1dPtFp5gOSWCcIdL7pAeWFbejILlkpiri4RLadCg4PDTwLGy0pSn5Tz6OE4sPO+WONIdVds/yjX8VpOz5yZd3oEs4s0O9+O/E8ArUP4RCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794175; c=relaxed/simple;
	bh=8LkYtPZIkvpKam0xZdGSleV6VSB+bLLA4S3vpBol614=;
	h=Date:To:From:Subject:Message-Id; b=GqAm7Ox+orDYTg1l3z3OV9fVDhVb7BjEdeTKS09hauQohEoxtkF2OtpuOvk/VZu4rBhF6SqFnjU/O7GvR/g4o6uoK9pbGLp1iNXCW7FtWNmWUd+FUW8bTP/Zar7/hz/pQg2bR6F8DuE12wAz/ZBW+fY7i1Gk/g4o1TZsW0NC60U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QTe7D1j0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QTe7D1j0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC87AC4CEEB;
	Sat, 13 Sep 2025 20:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794174;
	bh=8LkYtPZIkvpKam0xZdGSleV6VSB+bLLA4S3vpBol614=;
	h=Date:To:From:Subject:From;
	b=QTe7D1j09mfu0Qlcagjvchmf6NIW8atIgh8UJXCWhvKdQMcOLMV/38EM8uOcbrpCQ
	 7H8A76BitNSlYHMfoCiOasUoHNvO039mFpj0xY+QvuaA27JLDlUa/GfQYeG9HYuG5G
	 zgnY3Sk201lBpE5my/INSALM3O4VexWhphXYAzoY=
Date: Sat, 13 Sep 2025 13:09:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-lance-yang-as-a-thp-reviewer.patch removed from -mm tree
Message-Id: <20250913200934.DC87AC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Lance Yang as a THP reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-lance-yang-as-a-thp-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: MAINTAINERS: add Lance Yang as a THP reviewer
Date: Mon, 8 Sep 2025 18:48:57 +0800

I've been actively digging into the MM/THP subsystem for over a year now,
and there's a real interest in contributing more and getting further
involved.

Well, missing out on any more cool THP things is really a pain ;)

Link: https://lkml.kernel.org/r/20250908104857.35397-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-lance-yang-as-a-thp-reviewer
+++ a/MAINTAINERS
@@ -16240,6 +16240,7 @@ R:	Nico Pache <npache@redhat.com>
 R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
 R:	Barry Song <baohua@kernel.org>
+R:	Lance Yang <lance.yang@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-skip-mlocked-thps-that-are-underused-early-in-deferred_split_scan.patch

