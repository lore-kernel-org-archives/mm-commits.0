Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA82E367
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 03:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740454919; cv=none; b=IcbTV9UoGbrx2rdc4egigYpeygcf5ReQcw5Mj9G+XacW/6+o8yTN82Yb+wfwOSQ4hHL7S5j6kkHUtgExfdw4t9gudv6nUEGeZqA2pZkiNvW9wADdTpLUBv4+1y8rbeodDs1cWSKlQj8fp5iZL3j7357Hl8UzhWsZDPMHjolArKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740454919; c=relaxed/simple;
	bh=sIdTgouxpeFvGUxSaXBSeRu8uz5HWX9KR/BxHmVykQ8=;
	h=Date:To:From:Subject:Message-Id; b=a+830g9IGQxATgtfktrRA+6xrYTlHTWOMtYG7QjBK9MbkG9YatmCdhyAodGW+wam8FVnRcpg2SC61+UGL35KNCD8ruyzOz4qmxDVan9rwk+WXEqaAv3xth5rBZugVdC1XWYBXHrT3utF1CxGDKDt+GkZFpgZT4OSf2AH+2ry2Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZsdP4Ypu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZsdP4Ypu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB435C4CEE2;
	Tue, 25 Feb 2025 03:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740454919;
	bh=sIdTgouxpeFvGUxSaXBSeRu8uz5HWX9KR/BxHmVykQ8=;
	h=Date:To:From:Subject:From;
	b=ZsdP4Ypur9QgPmj5wLPBRhXGhICyUDGMraQZE3vvZcj98vawviDQi9elxko6R71G0
	 DKDuLS+YIzRqX8nBdfozjbmhi+Le503MfZ45DRM9SduTDkJl/AN5SCrZPBmzkoas0/
	 w5kEd+G94k+QrtjlYeMDaY+3oBbmBge4RiOZrgvc=
Date: Mon, 24 Feb 2025 19:41:59 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,fvdl@google.com,david@redhat.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-support-multiple-contiguous-ranges-if-requested-fix-2.patch added to mm-unstable branch
Message-Id: <20250225034159.AB435C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, cma: use literal printf format string
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-support-multiple-contiguous-ranges-if-requested-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-support-multiple-contiguous-ranges-if-requested-fix-2.patch

This patch will later appear in the mm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm, cma: use literal printf format string
Date: Mon, 24 Feb 2025 15:07:36 +0100

Using a variable string as a printf format can be a security issue that
clang warns about when extra warnings are enabled:

mm/cma.c:239:37: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
  239 |                 snprintf(cma->name, CMA_MAX_NAME, name);
      |                                                   ^~~~

This one does not appear to be a security issue since the string is
not user controlled, but it's better to avoid the warning.
Use "%s" as the format instead and just pass the name as the argument.

Link: https://lkml.kernel.org/r/20250224141120.1240534-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Frank van der Linden <fvdl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-support-multiple-contiguous-ranges-if-requested-fix-2
+++ a/mm/cma.c
@@ -199,7 +199,7 @@ static int __init cma_new_area(const cha
 	cma_area_count++;
 
 	if (name)
-		snprintf(cma->name, CMA_MAX_NAME, name);
+		snprintf(cma->name, CMA_MAX_NAME, "%s", name);
 	else
 		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
 
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-cma-support-multiple-contiguous-ranges-if-requested-fix.patch
mm-cma-support-multiple-contiguous-ranges-if-requested-fix-2.patch
reboot-add-support-for-configuring-emergency-hardware-protection-action-fix.patch

