Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FFD2765DE
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 22:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755642116; cv=none; b=KyDNntuRUaaSU44SegyNSUgHLTr2iuKlf0brfWTQslxGbU6itRVg/cOJDXgz1MKoON/mrsjCAE9hG5qr1J/r9bOfr7J9Z3+Dyxjm4DSxAGHlTHMJ2RXk9VEc+wJIL9jAPV4QG2o5hC4wfghj31bQRsPDjGgDDdotdMfkieY4l9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755642116; c=relaxed/simple;
	bh=/mQ0lH+MVaV430YDzUYWd119SQJd8PXrENhzvEIh6QQ=;
	h=Date:To:From:Subject:Message-Id; b=T963p7g9tDnRkvPGf+UCFPFCDkvOBWnykh0eBbUW44nA7maPvvrqX2Q6IGJDLV42TKSPqXMGMStrfAAGEJ5QylZjfwFbQEjAefYobFLO0QQzJw71cZujp+N7H9QZ6ypWh/SiORToHwEpjZ5R7JMTZQKChVAA13Am/5M841GUxw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X5Yrf3wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X5Yrf3wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2F3C4CEF1;
	Tue, 19 Aug 2025 22:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755642115;
	bh=/mQ0lH+MVaV430YDzUYWd119SQJd8PXrENhzvEIh6QQ=;
	h=Date:To:From:Subject:From;
	b=X5Yrf3wYMHYlwZ1x+i9gUUvhfot9Qgv9I/BeEe30cTZWRqsGpWgXeivYb7PyjfILq
	 E77DYPbDTXzAaj5NJ+CXwZujcAMdbHy7ZFjgIlxNINtn4rssqtcFUcwO0q2D7gM/BU
	 GTSz7N67zE2QUSNShX5c7YfNKXRnv0JwSNKxUSHQ=
Date: Tue, 19 Aug 2025 15:21:54 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,zhao.xichao@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-drop-redundant-conversion-to-bool.patch added to mm-new branch
Message-Id: <20250819222155.4B2F3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: drop redundant conversion to bool
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-drop-redundant-conversion-to-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-drop-redundant-conversion-to-bool.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xichao Zhao <zhao.xichao@vivo.com>
Subject: lib/test_hmm: drop redundant conversion to bool
Date: Tue, 19 Aug 2025 15:04:57 +0800

The result of integer comparison already evaluates to bool.  No need for
explicit conversion.

No functional impact.

Link: https://lkml.kernel.org/r/20250819070457.486348-1-zhao.xichao@vivo.com
Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_hmm.c~lib-test_hmm-drop-redundant-conversion-to-bool
+++ a/lib/test_hmm.c
@@ -140,7 +140,7 @@ static int dmirror_bounce_init(struct dm
 static bool dmirror_is_private_zone(struct dmirror_device *mdevice)
 {
 	return (mdevice->zone_device_type ==
-		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE) ? true : false;
+		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE);
 }
 
 static enum migrate_vma_direction
_

Patches currently in -mm which might be from zhao.xichao@vivo.com are

mm-remove-unnecessary-pointer-variables.patch
lib-test_hmm-drop-redundant-conversion-to-bool.patch
lib-use-ptr_err_or_zero-to-simplify-code.patch

