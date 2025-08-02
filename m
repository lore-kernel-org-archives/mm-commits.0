Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D775317A30A
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161224; cv=none; b=NQqoFIeqT2xIiacCR6wL7XtxZQw0YFD3hywEBNb6NewAC0awmd8GIlLdi869qvaSgR9UoNooAPno30COlIJdgDbFTNcwNGnqYG9QQRT25jPfmZpDHL9WGJ18WdEk1zLFh75PatyC63Vq1UqHukvDnlh3sfIXje06DfB3zDUwFAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161224; c=relaxed/simple;
	bh=6lk6ZtxS/4l5Iq/RJBIS3gjgapCHiXSwHz8Pac2ctw8=;
	h=Date:To:From:Subject:Message-Id; b=mChSUwyuR/ae2FVHg3iuChqh5T4WvZtH4w876gMMcOrl54QjKQTLhKpL0KXcgYy4lVgTfOPyKRG2JAbYIghMEDTS7JXwzAO/Ptq5Po09cAblA9/drLSfxqYMtZoiOR6XsRu7t9I4x96LStD39+rAq95L7W1o97WHt72CDaYKm28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yFWePvGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yFWePvGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2BDC4CEEF;
	Sat,  2 Aug 2025 19:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161223;
	bh=6lk6ZtxS/4l5Iq/RJBIS3gjgapCHiXSwHz8Pac2ctw8=;
	h=Date:To:From:Subject:From;
	b=yFWePvGvexvwV+KDnYKsIUOx6XzxkJg6tjc1eLuNNrLkBpBopJENz4n8ZBFz0qD9W
	 ZoN6ulp+Kbq1q3pI3FQK/Yj1boty2O92GA7CfEp635NTGVXyE7QFU3zcRpdDtH+EdU
	 7qWjfwnbGiKaq4DI188KPsdaNBtnCVXVgagT2zhM=
Date: Sat, 02 Aug 2025 12:00:22 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-add-test-for-kexec-handover-fix.patch removed from -mm tree
Message-Id: <20250802190023.6B2BDC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho-add-test-for-kexec-handover-fix
has been removed from the -mm tree.  Its filename was
     kho-add-test-for-kexec-handover-fix.patch

This patch was dropped because it was folded into kho-add-test-for-kexec-handover.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: kho-add-test-for-kexec-handover-fix
Date: Tue, 29 Jul 2025 12:14:51 +0300

fix section mismatch

Link: https://lkml.kernel.org/r/aIiRC8fXiOXKbPM_@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kho.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kho.c~kho-add-test-for-kexec-handover-fix
+++ a/lib/test_kho.c
@@ -194,7 +194,7 @@ static int kho_test_save(void)
 	return register_kho_notifier(&kho_test_nb);
 }
 
-static int __init kho_test_restore_data(const void *fdt, int node)
+static int kho_test_restore_data(const void *fdt, int node)
 {
 	const unsigned int *nr_folios;
 	const phys_addr_t *folios_info;
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-add-test-for-kexec-handover.patch

