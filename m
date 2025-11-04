Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037132264BB
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 01:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762220087; cv=none; b=PHRskWh8unlP/2DuLRmZ0PRVSbFIlsJI/s748HjU/eYiA5Q2AKRDBCYMN+qqoUbV3Q0ZN6gfk7Gd5hZG/oDdlIUb/Xht+rso4EsDS7SIhmjIn+AAuMSGsK1T9Qxu8+B6GmLardJFGA6AbniDyDB+SMb7NiKsEdDLl+RTttdfOX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762220087; c=relaxed/simple;
	bh=ipPkt4F5UVEve+2ZO55o/CeD2d160j165u97BXEm8A4=;
	h=Date:To:From:Subject:Message-Id; b=heWKrRr9+TX1VILheBLR0xBHBEQsuFNdztHfVc4QQvVO7g1ynPrLsGwibA1s8IfB9vfgtanqkZlMHDZ+pJpfVBp/W61Um8UenLcxB0JxdVgX+Bi7FgRR8vEMfaa/bkV5F7zILeEIM7PvetAqnlVhtZPEQVunx+8T9XTUId7+Sa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sVflYK/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sVflYK/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A29C4CEE7;
	Tue,  4 Nov 2025 01:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762220086;
	bh=ipPkt4F5UVEve+2ZO55o/CeD2d160j165u97BXEm8A4=;
	h=Date:To:From:Subject:From;
	b=sVflYK/mG3+UcPkkiSu+KfTxTfOAPwJsW7tlksuHhK0ti0wrV/ILjZ6zwf7o0+V6t
	 JL0iGSE5oJOyIYNJHM/8pHZRuPOPvU7SGoQlhBtyGze1PSHdWM7I6w78rOOXX90uNW
	 zHNOVuJ29jDEaWXu38D77hsmqxjfij0Gf98W3ZN4=
Date: Mon, 03 Nov 2025 17:34:46 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,vbabka@suse.cz,dev.jain@arm.com,david@redhat.com,zhangchujun@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-fix-missing-space-in-case-statement.patch added to mm-new branch
Message-Id: <20251104013446.B0A29C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug: fix missing space in case statement
has been added to the -mm mm-new branch.  Its filename is
     mm-debug-fix-missing-space-in-case-statement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-fix-missing-space-in-case-statement.patch

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
From: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Subject: mm/debug: fix missing space in case statement
Date: Mon, 3 Nov 2025 14:59:09 +0800

In setup_vm_debug() , the case statement for 'p' option is written as
'case'p':' without a space between 'case' and the character constant. 
While this is syntactically valid C, it violates the Linux kernel coding
style, which requires a space after 'case'.  This patch adds the missing
space to comply with coding standards.

Link: https://lkml.kernel.org/r/20251103065910.2196-1-zhangchujun@cmss.chinamobile.com
Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-debug-fix-missing-space-in-case-statement
+++ a/mm/debug.c
@@ -327,7 +327,7 @@ static int __init setup_vm_debug(char *s
 
 	while (*str) {
 		switch (tolower(*str)) {
-		case'p':
+		case 'p':
 			__page_init_poisoning = true;
 			break;
 		default:
_

Patches currently in -mm which might be from zhangchujun@cmss.chinamobile.com are

mm-debug-fix-missing-space-in-case-statement.patch

