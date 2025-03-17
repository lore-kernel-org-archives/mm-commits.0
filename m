Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0174418C337
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 16:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742228348; cv=none; b=CIYiapRqr8hv1YpCWwlQzjrtZ9Wv7AIxqKHal8966KZhGR7Dzal4RBoYX0ERWAooCtPCzxuKmdFsxYONd+hbyt2BEGtI5A2d1wdOlZ9mY1O6TLVcMDP1FgZwSvUGzDV1RIMUa6y+I1NOr/+rmGwrjXwpI7I4XFoFN6C3TOcbng8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742228348; c=relaxed/simple;
	bh=xnwBA8CZ59rAH8fv/Y1ouwHqVYkb5ukNS54aM4mQr5U=;
	h=Date:To:From:Subject:Message-Id; b=nZwoegh/UxfRUJAit8olnaXrGvikFtCypzmIpY07Ayl9S+FVwISFUhk3buIYEcqIdccIPz1Tj2CW7j8UVgFLy1Gyd3vNs5Z9V0bPHh705P0UsxoWTFOdLN3fy2mZcM5vXQGqUQ+IrWZb2iD9p+chRxol7SkHBq3EsZYaJE1zQBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jb6yFWbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jb6yFWbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654DAC4CEE3;
	Mon, 17 Mar 2025 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742228347;
	bh=xnwBA8CZ59rAH8fv/Y1ouwHqVYkb5ukNS54aM4mQr5U=;
	h=Date:To:From:Subject:From;
	b=jb6yFWbgO+X67PsBZtbTBboBv41IoC2SaHAx5078x9ce8VJGSS5Ztm/qs9P2q32i3
	 BMeJUzCXaSEUL0zA2AbnzLUzIWudZ7ijI0K5X0Cj8JQZSGx4d+JDGSLI0Gu7QoXD8i
	 hlnd/B4YrnU3q4zuLwlZPjfXl6ouHK/JxwNbkvLs=
Date: Mon, 17 Mar 2025 09:19:06 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jeffxu@chromium.org,gor@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-sysmap-enable-s390-fix.patch added to mm-unstable branch
Message-Id: <20250317161907.654DAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal sysmap: update supported architectures
has been added to the -mm mm-unstable branch.  Its filename is
     mseal-sysmap-enable-s390-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-sysmap-enable-s390-fix.patch

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
From: Heiko Carstens <hca@linux.ibm.com>
Subject: mseal sysmap: update supported architectures
Date: Mon, 17 Mar 2025 14:19:17 +0100

Add s390 to the list of architectures which support mseal sysmap.

Link: https://lkml.kernel.org/r/20250317131917.1332402-1-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mseal.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/userspace-api/mseal.rst~mseal-sysmap-enable-s390-fix
+++ a/Documentation/userspace-api/mseal.rst
@@ -143,7 +143,8 @@ Use cases
   the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
   architecture.
 
-  The following architectures currently support this feature: x86-64 and arm64.
+  The following architectures currently support this feature: x86-64, arm64,
+  and s390.
 
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
_

Patches currently in -mm which might be from hca@linux.ibm.com are

mseal-sysmap-generic-vdso-vvar-mapping.patch
mseal-sysmap-enable-s390.patch
mseal-sysmap-enable-s390-fix.patch

