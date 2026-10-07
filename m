Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21166547058
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334179; cv=none; b=bfyedWsybAYZ6dTEWOWE6q3EC55y+jTSlgjA0sXC/ROSUGuPfVpmg1tuGMXMYeuCZe5sA7wos6UxDMTNToj3X0kIjmKiN2pltKUe857bSexst6g7Xf17sPLkp4g6TZxFbHkxthbmEeT5go8OWc3S8IYUtRT9HTZLhnIxB3DkpKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334179; c=relaxed/simple;
	bh=1ZtDf6kvoIYge+7xPJzlSLvcsZmgDeTwYn6zT7/SMu0=;
	h=Date:To:From:Subject:Message-Id; b=cFy2dwF3acbjpQJJsTKemaHB6DCqQ7m1PoV36UHKgmiZ2BOTgTIqafelKXVnAZEsRkamXTlIwOikvmYZEQjwqG0mfEqWfB/V0ZlguCEFMafvbAVGJNP1OEHTUa2dgJ+pyIFyxRtml3XVn+coS0bMDNWs2DXd71/UQ4PxaGaP60c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AmKcBtKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AmKcBtKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E9E1F0089C;
	Wed,  7 Oct 2026 00:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334178;
	bh=1pDYBE8XtMaM4rnIYcoKlCrEoBKq5CWH+KDTOqPUuPg=;
	h=Date:To:From:Subject;
	b=AmKcBtKKWmxJhVg4VsmXlnKvjpYvpjyutjoC1mWSkwqGaqRLhspGpSh9dCYD+sP6n
	 EldtAKSEAYr0nroYOkgAdXM/Cm2ItBWt6Yd8qUbhBDLxkDYEA1YWAx1jCY1TX2cJrK
	 L82Vyr5OchRtaKk1Q6Gm7GUsZafxBXfRrIAWze4M=
Date: Tue, 06 Oct 2026 17:49:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-emit-tap-header-in-uffd-wp-mremap.patch removed from -mm tree
Message-Id: <20261007004937.E9E9E1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: emit TAP header in uffd-wp-mremap
has been removed from the -mm tree.  Its filename was
     selftests-mm-emit-tap-header-in-uffd-wp-mremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: selftests/mm: emit TAP header in uffd-wp-mremap
Date: Tue, 25 Aug 2026 16:57:54 +0800

Patch series "selftests/mm: TAP output and global-state fixes", v4.

uffd-wp-mremap and mremap_test never print the TAP header (and mremap_test
skips with a bare exit(KSFT_SKIP) rather than a KTAP skip), so their
output is not valid KTAP; hugetlb-soft-offline toggles enable_soft_offline
during the run and leaves it disabled afterwards.


This patch (of 3):

uffd-wp-mremap calls ksft_set_plan() without ksft_print_header(), so its
output is not valid KTAP.  Add the header, like the sibling uffd tests
(uffd-stress, uffd-unit-tests).

Link: https://lore.kernel.org/20260825085756.63030-1-husong@kylinos.cn
Link: https://lore.kernel.org/20260825085756.63030-2-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/uffd-wp-mremap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-emit-tap-header-in-uffd-wp-mremap
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -347,6 +347,8 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
+	ksft_print_header();
+
 	hugepage_save_settings(true, true);
 
 	check_uffd_wp_feature_supported();
_

Patches currently in -mm which might be from husong@kylinos.cn are


