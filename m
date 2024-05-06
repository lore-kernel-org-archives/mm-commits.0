Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB5C22089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957111; cv=none; b=TIqXp4aC8RFtwsp5/c4O4RpzziXYYMixrNG/AeG182VEh2C8cmVE3MbkgK8dc1S0vppYUutYgiRn6J1/AXTRW0xohh59GEAB/j6Ha3r59DAoh7UO24H80aMqyaSbTHbypofhSLembewx5jDp64vq/73EGVjLwkMKRVlA/5UVwfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957111; c=relaxed/simple;
	bh=tbhjPk8jHvh4GQ3TQaGnQuK6DClrW/34XyQnm/Cqy10=;
	h=Date:To:From:Subject:Message-Id; b=RxFdw/SsLx+FViYeJpjCccL5cnQ5Yp3o25z5WmK/slJcLryPxHXSXKlIE1BMTe4B4+Yhgty52ebeYMcz6fRgwZqJLn8JshuHLrCqra2ye0ednyWLPEClZ7wM9P2snGLE7JDOO4yDMXodwFZomJUMf84lwG8BSxSktxBZlYc3kNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SDvO3iUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SDvO3iUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022E2C116B1;
	Mon,  6 May 2024 00:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957111;
	bh=tbhjPk8jHvh4GQ3TQaGnQuK6DClrW/34XyQnm/Cqy10=;
	h=Date:To:From:Subject:From;
	b=SDvO3iUVP0IgBdDgqADyvrKqWvQHNJfYYvF20o+AmaWiaqX2aUbuwElus+ZrZ4chs
	 Z+J6dhFlCBMxLtv1qyp1Ykbwb3eIgZgSyrs/tvrgfambcSWSvog5CTSPSytR74YDZm
	 lSkp6Q08SrowPzRIGmO+1MaHH1FY0ukhGY4U0DyQ=
Date: Sun, 05 May 2024 17:58:30 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch removed from -mm tree
Message-Id: <20240506005831.022E2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: soft-dirty should fail if a testcase fails
has been removed from the -mm tree.  Its filename was
     selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: soft-dirty should fail if a testcase fails
Date: Wed, 24 Apr 2024 11:53:01 +0100

Previously soft-dirty was unconditionally exiting with success, even if
one of its testcases failed.  Let's fix that so that failure can be
reported to automated systems properly.

Link: https://lkml.kernel.org/r/20240424105301.3157695-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/soft-dirty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-soft-dirty-should-fail-if-a-testcase-fails
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -209,5 +209,5 @@ int main(int argc, char **argv)
 
 	close(pagemap_fd);
 
-	return ksft_exit_pass();
+	ksft_finished();
 }
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


