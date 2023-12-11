Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7C510FA
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njiNXuPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEDFC433C9;
	Mon, 11 Dec 2023 00:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702255336;
	bh=Ip42byDGICrM/mJuKcgJ0c3WnAPJNk2OiIkZrNMSBgE=;
	h=Date:To:From:Subject:From;
	b=njiNXuPoGhNDgnk6S84kyQY1kOXsz4vWXjaY0LtsNnbyTmzjeSNnpyqG8egcK6O1L
	 2WrdeyAlrJI+2nJUFksC4i3RFYuz9MFAgUKerdfFSSeuUSsCdRNVkl84y1cz5alUEy
	 TlWj65sXR/QfK6SBCIUEpAkgNHLAy3VSxFNCsDNg=
Date: Sun, 10 Dec 2023 16:42:15 -0800
To: mm-commits@vger.kernel.org,avagin@google.com,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix-2.patch removed from -mm tree
Message-Id: <20231211004215.DFEDFC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix spelling mistake "succedded" -> "succeeded"
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix-2.patch

This patch was dropped because it was folded into selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: selftests/mm: fix spelling mistake "succedded" -> "succeeded"
Date: Tue, 21 Nov 2023 09:31:04 +0000

There is a spelling mistake in a ksft_exit_fail_msg message. Fix it.

Link: https://lkml.kernel.org/r/20231121093104.1728332-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix-2
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -75,7 +75,7 @@ static bool pagemap_scan_supported(int f
 	/* Provide an invalid address in order to trigger EFAULT. */
 	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
 	if (ret == 0)
-		ksft_exit_fail_msg("PAGEMAP_SCAN succedded unexpectedly\n");
+		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
 
 	supported = errno == EFAULT;
 
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

selftests-mm-check-that-pagemap_scan-returns-correct-categories.patch
scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

