Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038268;
	b=JeXU9whPKG3pJAuZ4/91dSFu0LbQkjQu79r663NgAY970hVHsxJqATPd8u8yXPJKNgm5
	 1/gpxpmMNWUqT+KRpf4sFIQF9F0xMYgzoFh/9dVyb3mnMQtwIXq4UoIlLR70PzwNXH4Ki
	 qnMYryqa/YGCKUMIYqMVb0gFh5Qa3FgLAkT55t6PZsAUaO6g3wgeeh+ezuBxIkMmk/yDa
	 0FAT7BOM9YDiRWRoEcTVbrHOXvJG+QuGHoJk0iJKgIMSdZd08eLHg8QhSk8wvkP+s6feL
	 6O0/UVqiWmUohndh+Mh80unYl62qDkkAH7puReqnKO3avmaeX1vozTrbPiANBffCpzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038268;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Gx0JTl7snLd1RDWvEqXR0hHBtnxOIzYkzt4aQhW68mc=;
	b=Z3iJcyU+jEVhUbcnMbWGGuVXXZSQAG/pUOCXdeJd7V6TlaOSyob97NZhqZkoWk6wKt4d
	 4CfyJaPcesqLkOX4XqSYi6qMqpK0qAw0SV89TID0gwCHy3Yp6YPs9tEq0L21dUNJ6nVBr
	 9OGrUMNP7tVr9saWn80nFAYSsCCzJn4NpI92oI9sW6MyPr0zn1B5L0iLuMOBrin9wkAEm
	 eg8S/3iV5YG/v//RjscMMdG0poA4nKZkP+a3HXWV79peAW0Yv7z5Ts7o7SEfPWKOd2j9t
	 7DZFmKexEK+9ijZsNjRDwFydLcunOxU+EbQvAAZNfvv2vFvQSSxdf/ye1yjBsZwI/aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TqHqsj2e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D40606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 21:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TqHqsj2e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FE41F000C4;
	Wed, 18 Nov 2026 21:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795038268;
	bh=Gx0JTl7snLd1RDWvEqXR0hHBtnxOIzYkzt4aQhW68mc=;
	h=Date:To:From:Subject;
	b=TqHqsj2eI81CvK0geu7CpDkKRoJhtVDSMtYCYi7aQErPk5VckgVpbfY7+M3RiBoe+
	 dfbtYJ6y189Kq9CGRNPXyqffXw/QHdbE22kBV/QxfKTtC2BW6YUBM7iyVK0fWjUALj
	 AL1kmb8kvOi1AEn+/KvmcB/AxDC3kSx47So23dJU=
Date: Wed, 18 Nov 2026 13:44:27 -0800
To: mm-commits@vger.kernel.org,akinobu.mita@gmail.com,ekffu200098@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-injection-fix-typo-in-failcmdsh.patch added to mm-nonmm-unstable branch
Message-Id: <20261118214427.E7FE41F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fault-injection: fix typo in failcmd.sh
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-injection-fix-typo-in-failcmdsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-injection-fix-typo-in-failcmdsh.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: fault-injection: fix typo in failcmd.sh
Date: Thu, 19 Nov 2026 01:43:02 +0900

The failslab debugfs file is cache-filter, not cache_filter.

Link: https://lore.kernel.org/20261118164303.97840-1-ekffu200098@gmail.com
Fixes: c24aa64d169b ("fault-injection: add tool to run command with failslab or fail_page_alloc")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>

 tools/testing/fault-injection/failcmd.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/fault-injection/failcmd.sh~fault-injection-fix-typo-in-failcmdsh
+++ a/tools/testing/fault-injection/failcmd.sh
@@ -196,7 +196,7 @@ while true; do
 		shift 2
 		;;
 	--cache-filter)
-		echo $2 > $FAULTATTR/cache_filter
+		echo $2 > $FAULTATTR/cache-filter
 		shift 2
 		;;
 	--ignore-gfp-highmem)
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch
mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch
mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch
fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch
fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms.patch
fault-injection-fix-typo-in-failcmdsh.patch

