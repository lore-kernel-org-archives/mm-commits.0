Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8272ED17B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388583; cv=none; b=P75wOejldAuq01SbKkvrorfpotp7vDwpfa5iJMVoVk4HsNuXBMOg2yUYcPgZr4FgjEDnqvBW7nUICB1RELS6hY3/WknHN9aWTUOKD9bVpFhjwt2kXjENP5X3j3Lqt4EO2IV2cg4sd0b1KZLr0stnZ9XLvhnV/w3IA1d4ssi9joQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388583; c=relaxed/simple;
	bh=VhkyNUtm0K4QoE3z7StSFJiEkorDZzoXm/aoF/RbSIE=;
	h=Date:To:From:Subject:Message-Id; b=n/GGwNQjfmhB44hWguafzC+ecFuBbjBxdQLvPDPFuqPEkwlm169xdSYcXjY3wC32vpd7pshXhXUrZV02nNJmuXgTPdDqNgx81SqvD2cD4ncj2A+wn2/M0Vjhep6D9yJ40WFAcg2FJb3RaCY6Fg9CeJn1I5RwTu5ZpKfrwHtdcNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SiZ9HRVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SiZ9HRVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645B0C19424;
	Tue, 24 Mar 2026 21:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388583;
	bh=VhkyNUtm0K4QoE3z7StSFJiEkorDZzoXm/aoF/RbSIE=;
	h=Date:To:From:Subject:From;
	b=SiZ9HRVyGsa20P9/Vxf4HO2qg9So24AUoyFMwvpugZ4T0T71B49dCSXt8XYIcApsi
	 DoWe3fi67U1tuTob9q55VyOk2wATG5SVtDi4LrIw0iS+4SRVhQMYnFVL7w4YrJcfaN
	 jAmZzal0SjD2kI2kUL/02RAewtQnXtWkIAcZAA9Y=
Date: Tue, 24 Mar 2026 14:43:02 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,zhongqiu.han@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-remove-unreachable-return-statement-in-scan_should_stop.patch removed from -mm tree
Message-Id: <20260324214303.645B0C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: remove unreachable return statement in scan_should_stop()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-remove-unreachable-return-statement-in-scan_should_stop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Subject: mm/kmemleak: remove unreachable return statement in scan_should_stop()
Date: Fri, 30 Jan 2026 17:37:28 +0800

Patch series "mm/kmemleak: Improve scan_should_stop() implementation".

This series improves the scan_should_stop() function by addressing code
quality issues and enhancing kernel thread detection robustness.


This patch (of 2):

Remove unreachable "return 0;" statement as all execution paths return
before reaching it.

No functional change.

Link: https://lkml.kernel.org/r/20260130093729.2045858-2-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-remove-unreachable-return-statement-in-scan_should_stop
+++ a/mm/kmemleak.c
@@ -1507,10 +1507,8 @@ static int scan_should_stop(void)
 	 */
 	if (current->mm)
 		return signal_pending(current);
-	else
-		return kthread_should_stop();
 
-	return 0;
+	return kthread_should_stop();
 }
 
 /*
_

Patches currently in -mm which might be from zhongqiu.han@oss.qualcomm.com are


