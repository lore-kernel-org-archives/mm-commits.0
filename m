Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D2A14D6F6
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742141; cv=none; b=JWTrTjRYOd+DwudTtnSgTzKs2mETz1FlPzRneECQdztM3LNGcL90XenlmXxLX1oDUN1yeTzbeZrfQodIkq74DqUVRTdHCFUhjZic4LBZYi/QLvcUlXEGWqxemtwBK6usBL3pW0m0JoRWAPVv1XA7hL5cerHWrJHvRo9RJiNSX7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742141; c=relaxed/simple;
	bh=nqycl7snrB1Hp0LOZKyMJSrbdtc+9VV+rxOEBW6aO+g=;
	h=Date:To:From:Subject:Message-Id; b=E3P6xMu8SGYudvSuKhOBJplFAGqiuaal0IT9FUI/4nY8Oue41K303dD00bPU2CPt4/dukq6HDE56DNyCfBjVpoo+G8rOo9+/7KxYI8icqog5Habl4Gl+piW5AFsk+gTojrH4Ljph1QfLA3WSSCCpw5fEVvu3dlfosHLZmSzeH4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zZQVV4/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zZQVV4/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05553C4CED6;
	Mon, 13 Jan 2025 04:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742141;
	bh=nqycl7snrB1Hp0LOZKyMJSrbdtc+9VV+rxOEBW6aO+g=;
	h=Date:To:From:Subject:From;
	b=zZQVV4/otWS8Bsr0vdP92DveIJKWXE9ObgKSXqQmjr6vZA495PgKLqdbUs3pY5oaV
	 wtDZMzTMMUYB91oLxDy4pvegG7bIzUWZp0DP17xy0Sg/ExlKDuxiWdOQSOaz9nAp9N
	 WY6p9k3vTXrs/aozSZfaYSjd/ecm7VDtCr/hjvjs=
Date: Sun, 12 Jan 2025 20:22:20 -0800
To: mm-commits@vger.kernel.org,thomas.orgis@uni-hamburg.de,zhangjiao2@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-accounting-procacct-fix-minor-errors.patch removed from -mm tree
Message-Id: <20250113042221.05553C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/accounting/procacct: fix minor errors
has been removed from the -mm tree.  Its filename was
     tools-accounting-procacct-fix-minor-errors.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Subject: tools/accounting/procacct: fix minor errors
Date: Tue, 3 Dec 2024 10:05:50 +0800

The logfile option was documented but not working.  Add it and optimized
the while loop.

Link: https://lkml.kernel.org/r/20241203020550.3145-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Reviewed-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/procacct.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/accounting/procacct.c~tools-accounting-procacct-fix-minor-errors
+++ a/tools/accounting/procacct.c
@@ -274,12 +274,11 @@ int main(int argc, char *argv[])
 	int maskset = 0;
 	char *logfile = NULL;
 	int cfd = 0;
-	int forking = 0;
 
 	struct msgtemplate msg;
 
-	while (!forking) {
-		c = getopt(argc, argv, "m:vr:");
+	while (1) {
+		c = getopt(argc, argv, "m:vr:w:");
 		if (c < 0)
 			break;
 
_

Patches currently in -mm which might be from zhangjiao2@cmss.chinamobile.com are


