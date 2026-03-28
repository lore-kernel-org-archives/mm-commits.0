Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47C1315D43
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671878; cv=none; b=lsWrnK0V+0EPDxcgILNdP2NubVIYhmC4uuigTYegTZ0ZlVG78L2wm9GChPlAy37lzTDLkzloH8NXqtAB4ZXy6Uo2Iqmta84TfDf5+UnYKwO0prLVeBkOxV8B475OedirSCYBTahG/9sToMsisNuGsOx3iZ/353RYwO5SbYTrF00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671878; c=relaxed/simple;
	bh=ZA2nbxsnDeqKbaMhYGYc65VDUbMUE9Q8Y7E9Q0VRm5Y=;
	h=Date:To:From:Subject:Message-Id; b=TFfkQlw0i9yLrQ3M00myqnywoEZBTqHE76+/F7za6UMQypf4ugVCc94sR45JlBBatxuHcHoXkMrhTpBD7l6un5JZMIM7m4pZrrNsQIpR0DwNsEKi1iKulUcJFgFCJmDr9i6jC/xhm9NZqcSoa4FG5S+3FRuF03n246dLNigHkCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FTiWpR2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FTiWpR2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9412C4CEF7;
	Sat, 28 Mar 2026 04:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671877;
	bh=ZA2nbxsnDeqKbaMhYGYc65VDUbMUE9Q8Y7E9Q0VRm5Y=;
	h=Date:To:From:Subject:From;
	b=FTiWpR2WCd96puvj7LWtfugOHsJ9g/Mt99CD50efkEC2u8N8WmGSplGsrtnPmoJC9
	 UtKbIa1zOXk3iWWjiZVy7DZQne+lsDUyraN66JJJ/pG7idOpEqBIuGFvY2WD/HXqqu
	 D2srou8zGd0cdn0uvfrfFmOs3pp3f9AAsH540s2A=
Date: Fri, 27 Mar 2026 21:24:37 -0700
To: mm-commits@vger.kernel.org,gnoack3000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spellingtxt-add-bindedbound.patch removed from -mm tree
Message-Id: <20260328042437.A9412C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/spelling.txt: add "binded||bound"
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-bindedbound.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Günther Noack <gnoack3000@gmail.com>
Subject: scripts/spelling.txt: add "binded||bound"
Date: Sat, 14 Feb 2026 15:08:54 +0100

The correct passive of "to bind" is "bound", not "binded".  This is often
used in the context of the BSD socket bind(2) operation.

Link: https://lkml.kernel.org/r/20260214140854.42247-1-gnoack3000@gmail.com
Signed-off-by: Günther Noack <gnoack3000@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-bindedbound
+++ a/scripts/spelling.txt
@@ -257,6 +257,7 @@ begining||beginning
 beter||better
 betweeen||between
 bianries||binaries
+binded||bound
 bitmast||bitmask
 bitwiedh||bitwidth
 boardcast||broadcast
_

Patches currently in -mm which might be from gnoack3000@gmail.com are


