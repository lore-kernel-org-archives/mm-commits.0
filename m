Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8AD35337A;
	Tue, 19 Aug 2025 23:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646589; cv=none; b=f1xEC2yzQyFfekOG1N9WDBt9uM208aaGrk3ElgD2xOUSWWy3XMi6gW/6PZz0lErRlfs7TSw22BkoPhcbouVKJQ1/AuqLZuJSZChF4/UljgDonaCR1gFfjrcCVVyJ+omkxBeIVzFB1YcmGl7wleM0bS+NlXnlx2PkaM6KlUohkss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646589; c=relaxed/simple;
	bh=Bcc4AXSBipXodhC98aWGzSjlfl20ND9puXPaMyS20tM=;
	h=Date:To:From:Subject:Message-Id; b=J1BSNvCuWqPFvWTKujJcPkZVHEQ5H1qHzEyN2DhyTnaL1ApWXxab1v9TZYghdyGw8TMuAzHItj2aV2VO1JThseRBO/DAxrWP9GFfx8atkqe5qwXlh0EPjqUMJo6G6VqmII/RfYfe5cvHJ1luyOlXv9HmlW7t+7kW37ve24ty6DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VCRawlPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VCRawlPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03C9C113D0;
	Tue, 19 Aug 2025 23:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646589;
	bh=Bcc4AXSBipXodhC98aWGzSjlfl20ND9puXPaMyS20tM=;
	h=Date:To:From:Subject:From;
	b=VCRawlPxv2fGlmDcKRcoEEowlN9tFEHSXXkCIqNtkLq+ucJ0t5+1/fIStHBiDs5Hy
	 nniizejzuqQUKz7JptS+6w2lP5gKE2Ael5ein0Yr1tAbP3lf8b5IQneTc6u/YZpqEb
	 ryNuSAJpGtllK1MF+f4iJKaNZTrZbDZUMrVanLmk=
Date: Tue, 19 Aug 2025 16:36:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,changyuanl@google.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kho-warn-if-kho-is-disabled-due-to-an-error.patch removed from -mm tree
Message-Id: <20250819233628.E03C9C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: warn if KHO is disabled due to an error
has been removed from the -mm tree.  Its filename was
     kho-warn-if-kho-is-disabled-due-to-an-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: warn if KHO is disabled due to an error
Date: Fri, 8 Aug 2025 20:18:04 +0000

During boot scratch area is allocated based on command line parameters or
auto calculated.  However, scratch area may fail to allocate, and in that
case KHO is disabled.  Currently, no warning is printed that KHO is
disabled, which makes it confusing for the end user to figure out why KHO
is not available.  Add the missing warning message.

Link: https://lkml.kernel.org/r/20250808201804.772010-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/kexec_handover.c~kho-warn-if-kho-is-disabled-due-to-an-error
+++ a/kernel/kexec_handover.c
@@ -564,6 +564,7 @@ err_free_scratch_areas:
 err_free_scratch_desc:
 	memblock_free(kho_scratch, kho_scratch_cnt * sizeof(*kho_scratch));
 err_disable_kho:
+	pr_warn("Failed to reserve scratch area, disabling kexec handover\n");
 	kho_enable = false;
 }
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


