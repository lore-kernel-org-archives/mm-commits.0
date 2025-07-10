Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2846E5383
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126309; cv=none; b=M5maGcKsHQqYPebIJ/WtbkbKk/M5v8PRg2IWyB/XMSjW7b0cn8ObkgM2N5Ab7kuPNAlfFHE8EyJ5QElxv1Pub8ptZDvhmK/db8breXKJaNT9mENaFxawh3F9kWKEWUYWU3IysZlN4sTRhcQLxnAfuy6Py7R6/AqJqWYqCQJUOKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126309; c=relaxed/simple;
	bh=NkWWNqzAm8t48C+2BUwLI/vwiMStgaDG6L32WwAa04s=;
	h=Date:To:From:Subject:Message-Id; b=lR1ytEIh6hO780/I6PW1g6lL8uBw676ZjkwGPBtMef+O6dhNxkfuJ18HzOrNT30DUEW2LwzJEvAg5rGtUmZ88GtAWPsoFbtn/b89nB4aC7cMPdDCVvVfz1jvpoyECludpXHuF+onDanDPznCXiGE+qdMOOWg0sI1Sl/rWk+nCaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PFcZSrHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PFcZSrHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9821C4CEE3;
	Thu, 10 Jul 2025 05:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126308;
	bh=NkWWNqzAm8t48C+2BUwLI/vwiMStgaDG6L32WwAa04s=;
	h=Date:To:From:Subject:From;
	b=PFcZSrHJTkDvYV7aimjFrdHq67aAVWzQvt9B+yaFXNhNKSCFE5WjI1ipA+4hapSrg
	 qHKhXWG0XnlxjvtdTx33l2LFKGaW7bFAPBDxHw+CcoKRHGFIvgbh5SAkZEBUvXmX3Q
	 R2vOyHHpxhwL+wpR7G+2i3GwuSpQJmFC45BpYsm4=
Date: Wed, 09 Jul 2025 22:45:08 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-mm-skip-if-fallocate-is-unsupported-in-gup_longterm.patch removed from -mm tree
Message-Id: <20250710054508.C9821C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: skip if fallocate() is unsupported in gup_longterm
has been removed from the -mm tree.  Its filename was
     selftest-mm-skip-if-fallocate-is-unsupported-in-gup_longterm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftest/mm: skip if fallocate() is unsupported in gup_longterm
Date: Fri, 13 Jun 2025 12:44:07 +0100

Currently gup_longterm assumes that filesystems support fallocate() and
uses that to allocate space in files, however this is an optional feature
and is in particular not implemented by NFSv3 which is commonly used in CI
systems leading to spurious failures.  Check for lack of support and
report a skip instead for that case.

Link: https://lkml.kernel.org/r/20250613-selftest-mm-gup-longterm-fallocate-nfs-v1-1-758a104c175f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftest-mm-skip-if-fallocate-is-unsupported-in-gup_longterm
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -114,7 +114,15 @@ static void do_test(int fd, size_t size,
 	}
 
 	if (fallocate(fd, 0, 0, size)) {
-		if (size == pagesize) {
+		/*
+		 * Some filesystems (eg, NFSv3) don't support
+		 * fallocate(), report this as a skip rather than a
+		 * test failure.
+		 */
+		if (errno == EOPNOTSUPP) {
+			ksft_print_msg("fallocate() not supported by filesystem\n");
+			result = KSFT_SKIP;
+		} else if (size == pagesize) {
 			ksft_print_msg("fallocate() failed (%s)\n", strerror(errno));
 			result = KSFT_FAIL;
 		} else {
_

Patches currently in -mm which might be from broonie@kernel.org are


