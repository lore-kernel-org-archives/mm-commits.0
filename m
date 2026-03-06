Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53287366804
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 18:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772820489; cv=none; b=qbm/TN3/0FK7FOG6VN/M7NVFGIk/5loI5DJBl+LY7vv9U54/3OM0Omn4m0CilIC+Rap7ooWiGw6r49UDU31rh/ADg4s1FunMqeIt4rb+V32B20nMXTmKsDNUkjwk6KbnKy7ySi4fCLHh6rZeLqeBWjxUTITrMQr/dPDdoxYqHTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772820489; c=relaxed/simple;
	bh=fIY01A1ikGQzJvVsl+CGZjhCYNZ6KXAm/2TtOSpbJgA=;
	h=Date:To:From:Subject:Message-Id; b=ZBJ/jez+BfNx9iwAGTfJyJUbnZiBjmyGColW/NTCuFTjoGBbtRLrxxtkYLWeQad33JCzrOapt8sFiJUhLgLEnqOSwWUS+776+rT+nMIt+/DkFbGba8bNxgdy5N2p7gsH/z4/PqbZyFN8aYTQFjh5QuZ//ts53broN6nwGzhQGgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v4Ejz4qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v4Ejz4qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1462C4CEF7;
	Fri,  6 Mar 2026 18:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772820488;
	bh=fIY01A1ikGQzJvVsl+CGZjhCYNZ6KXAm/2TtOSpbJgA=;
	h=Date:To:From:Subject:From;
	b=v4Ejz4qelCSonLdBX8KiQ3cJaeowOGhn1cTx2B0lmWIVK2qm5J9YLAK3K5sQk/yQf
	 hBX7V3+JaQil01Ng0RTPPTeTpvrgQ/QDKLQTDaJlxMf140x+7iSQi3hw0OzRVAjCHH
	 jMi2ee+QP4+uU3VZVw4sxy0Dk8+c7DpS5thFms8I=
Date: Fri, 06 Mar 2026 10:08:08 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20260306180808.D1462C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/inflate: fix typo "This results" to "The results" in comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch

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
From: Josh Law <hlcj1234567@gmail.com>
Subject: lib/inflate: fix typo "This results" to "The results" in comment
Date: Fri, 6 Mar 2026 16:17:32 +0000

Fix "This results of this trade" to "The results of this trade" in the
comment describing the lbits and dbits tuning parameters.

Link: https://lkml.kernel.org/r/20260306161732.2812132-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/inflate.c~lib-inflate-fix-typo-this-results-to-the-results-in-comment
+++ a/lib/inflate.c
@@ -286,7 +286,7 @@ static void free(void *where)
    the longer codes.  The time it costs to decode the longer codes is
    then traded against the time it takes to make longer tables.
 
-   This results of this trade are in the variables lbits and dbits
+   The results of this trade are in the variables lbits and dbits
    below.  lbits is the number of bits the first level table for literal/
    length codes can decode in one step, and dbits is the same thing for
    the distance codes.  Subsequent tables are also less than or equal to
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are

lib-glob-add-missing-spdx-license-identifier.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch
lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch

