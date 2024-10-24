Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901BB42070
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729736809; cv=none; b=AbzXgD1/o04xReGyS5ZrZ47Lx7lPhR7/I3l34UXEJQ6GThosg6EP8KuOonJ5hhvBoEJiS+3BunA7AaP1StabaYjS/wR+oHnHA37RxdWywKnYjdCi5J9sb63VPZhAa38TqkxdwpPU5xoBZLjrcGLAevlw1YpC5yiLdgcFD0sa5OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729736809; c=relaxed/simple;
	bh=PNQjw/ocLKbEq9XSYFGQ7PCovS6MMPFny6yMfn1GehA=;
	h=Date:To:From:Subject:Message-Id; b=DTRywR/G0pK5TaRoVKkP8Wo2zofQfQal2DfolPpo1Ct68RKmXf0BT5nMn7iLU8UGWqRyHrT1UNJsR5m+dU2gQInZCP4UNMcXjI1IircWFIS5rrpsbAW0ce1jGwImIkAcZAqvUIq9Nt/SVpdmZhFFQsNRSo3uFo7utrjAfeWDfvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DOg9yfZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DOg9yfZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5E8C4CEC6;
	Thu, 24 Oct 2024 02:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729736809;
	bh=PNQjw/ocLKbEq9XSYFGQ7PCovS6MMPFny6yMfn1GehA=;
	h=Date:To:From:Subject:From;
	b=DOg9yfZoJQi0Jf2I9cTShJwAZdtp3wxiUFDmFad/l+p1CcicgCs40dUAtsPN0oKsW
	 0QAKp7a+1AbVqXVGjNDoTnQO6SjFn/r9jDdsmSW8R1gKzg4vmbevl42T7xPpicTIy9
	 nHX3OBtMxFu/33XhMcZj/MLuRgei9yADZPMDfymk=
Date: Wed, 23 Oct 2024 19:26:48 -0700
To: mm-commits@vger.kernel.org,liujing@cmss.chinamobile.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-free-the-allocated-memory-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20241024022649.0D5E8C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools-mm-free-the-allocated-memory-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-mm-free-the-allocated-memory-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-free-the-allocated-memory-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools-mm-free-the-allocated-memory-fix
Date: Wed Oct 23 07:26:22 PM PDT 2024

fix whitespace

Cc: Liu Jing <liujing@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-free-the-allocated-memory-fix
+++ a/tools/mm/page_owner_sort.c
@@ -377,7 +377,7 @@ static char *get_comm(char *buf)
 	if (errno != 0) {
 		if (debug_on)
 			fprintf(stderr, "wrong comm in follow buf:\n%s\n", buf);
-		free (comm_str);
+		free(comm_str);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
tools-mm-free-the-allocated-memory-fix.patch

