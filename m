Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8DF35F8C8
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966116; cv=none; b=nWx/oa88dXYtdKFVn9HoS4P+DyzSF9Q/eeYfzOR/CRQ6XrHKIBxI00NXjqyxJcpuy3eKCGJGCIQ708MFdAeedLFakikRJJUsKYGeQ7e9NysxpmVhWDHO2c9NA6fQwqWS1Hqm0IC0na6NQdzHZ2j8VswNOFndVh6hKD72PUL7HRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966116; c=relaxed/simple;
	bh=y5eDBldTr7ZC0Jnn2iwgeq2FdQ9aDWawye/Hi2lKn3Q=;
	h=Date:To:From:Subject:Message-Id; b=swDzHi9c2CFqjDi/3Y6+fq4PewEtKylciXzEPmNHkS5mC/TKKMgcKNszD6iQ+2t/s2JtJTsnxGfquQ6kv4egrongvUI4WN8jByqH5misb/M3vDVvEA/Z5dCuoCajXc+tiqX/5h4jC013mur8cZ8oUvBXf6D8vyUz2+wz+9DrTaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=djbDt70W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="djbDt70W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CA1C16AAE;
	Wed, 21 Jan 2026 03:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966116;
	bh=y5eDBldTr7ZC0Jnn2iwgeq2FdQ9aDWawye/Hi2lKn3Q=;
	h=Date:To:From:Subject:From;
	b=djbDt70WxPSFkVB8Z3OGgsjVWl15cPYMJ9E3UgU18424gq/vY/gchwrX8lKBLnJqO
	 zXPXoUdQbdkEA9uGaEv0uV+3d9TX9fe4mcWRChdEYExIY7EYpWWhewK9VO0APuUKa/
	 oxO+B+xlshghO+a5Hxxr3JHnGBce3GFTpdX8LDz4=
Date: Tue, 20 Jan 2026 19:28:35 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-comment-for-check_test_requirements.patch removed from -mm tree
Message-Id: <20260121032836.62CA1C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix comment for check_test_requirements
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-comment-for-check_test_requirements.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: fix comment for check_test_requirements
Date: Sun, 21 Dec 2025 12:00:25 +0800

The test supports arm64 as well so the comment is incorrect.  And there's
a check for arm64 in va_high_addr_switch.c.

Link: https://lkml.kernel.org/r/20251221040025.3159990-5-chuhu@redhat.com
Fixes: 983e760bcdb6 ("selftest/mm: va_high_addr_switch: add ppc64 support check")
Fixes: f556acc2facd ("selftests/mm: skip test for non-LPA2 and non-LVA systems")
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-fix-comment-for-check_test_requirements
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -61,9 +61,9 @@ check_supported_ppc64()
 
 check_test_requirements()
 {
-	# The test supports x86_64 and powerpc64. We currently have no useful
-	# eligibility check for powerpc64, and the test itself will reject other
-	# architectures.
+	# The test supports x86_64, powerpc64 and arm64. There's check for arm64
+	# in va_high_addr_switch.c. The test itself will reject other architectures.
+
 	case `uname -m` in
 		"x86_64")
 			check_supported_x86_64
_

Patches currently in -mm which might be from chuhu@redhat.com are


