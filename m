Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CAC23C6EA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837024; cv=none; b=Ss18TVGSVuiGydcly6f9HmuViGDMiUa/84v10l5ndZhHQf2AW7/1y32E7H5269nTPIwWJAgdIfcB2ZGKECTq2HMQznwjoIRG9jOkB0e5F/dPex5FkKE8YVODybbwyyV1BVTsvbU/kUgk/xX3fi5MSQlnna3pu8ZmggwHhqsNkVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837024; c=relaxed/simple;
	bh=WRnAsxjrwE7IjP8B5wPmsZGjvzU3VAAuKpH2pY/c1YQ=;
	h=Date:To:From:Subject:Message-Id; b=Ek4EoVizrgSaByoO+SovIUO0pO3Wtj11x3H2uYllM4F1fwCdk6WXetp80Q/m6Cwm42kFdqK3Q4QDZERtnGsc7Ud32g3SZS2QU9E9i5t8i5B6tEOZS+qs9FPa8KVbN9UMN3N3fzD9cSeLJf6mSv4eODRaK6+kS7y10wk8Bou176w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iR0luz0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iR0luz0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B54CC4CEDD;
	Tue, 14 Jan 2025 06:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837023;
	bh=WRnAsxjrwE7IjP8B5wPmsZGjvzU3VAAuKpH2pY/c1YQ=;
	h=Date:To:From:Subject:From;
	b=iR0luz0Aj9GSN8Si4wmyqPnm8l0WlFAgPwjZ6cH759BqYiruUQHW5DB1FFWndJX0x
	 dh5FDwC2BjJmoZCtyrmILiei8PETGXFTiiMNEqos/jbMeKl48Kw7x1jqJgvXCbkl9i
	 kAy51yvfybv9vDrYB62DpI6pGpCdofdDF01tz7hY=
Date: Mon, 13 Jan 2025 22:43:42 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,sfr@canb.auug.org.au,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch removed from -mm tree
Message-Id: <20250114064343.7B54CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/vaddr-kunit.h: reduce stack consumption
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/damon/tests/vaddr-kunit.h: reduce stack consumption
Date: Mon Dec  9 06:20:01 PM PST 2024

After "mm: move per-vma lock into vm_area_struct" we're hitting

mm/damon/tests/vaddr-kunit.h: In function 'damon_test_three_regions_in_vmas':
mm/damon/tests/vaddr-kunit.h:92:1: error: the frame size of 3280 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Fix by moving all those vmas off the stack.

[akpm@linux-foundation.org: fix build]
Closes: https://lkml.kernel.org/r/20241209170829.11311e70@canb.auug.org.au
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-tests-vaddr-kunith-reduce-stack-consumption
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -68,7 +68,7 @@ static void damon_test_three_regions_in_
 	static struct mm_struct mm;
 	struct damon_addr_range regions[3] = {0};
 	/* 10-20-25, 200-210-220, 300-305, 307-330 */
-	struct vm_area_struct vmas[] = {
+	static struct vm_area_struct vmas[] = {
 		(struct vm_area_struct) {.vm_start = 10, .vm_end = 20},
 		(struct vm_area_struct) {.vm_start = 20, .vm_end = 25},
 		(struct vm_area_struct) {.vm_start = 200, .vm_end = 210},
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ksm-add-ksm-involvement-information-for-each-process-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch

