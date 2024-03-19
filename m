Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A2F3CF4F;
	Tue, 19 Mar 2024 20:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710880464; cv=none; b=YSvXNVZFDojv6PXBvxV9ckhwezenSWEgISMxw+h6GMV3dFJJRtSkTTXGADiUWJtD7sjTI0iL7lf4w7Y2gT1j2FMR8tOQNw+h/dqDMzSnrm/iLFWQNJc7ETTPh2YzL5MmlLruty7MWnnkKv0HJeHyQU+dv9qXTbJbQQ0eW3dfWNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710880464; c=relaxed/simple;
	bh=hP78SXMHsTMMd4Q//Jo7PKjchTiUIFsJuQL4eeR3GHI=;
	h=Date:To:From:Subject:Message-Id; b=r+T8im3pISyijtofbA2DT3FKXjjQkkabI2PPYNdLbCeuKqIf41TxkiO1g/a36H8CRI80qyaPE8bk5BM1vFQPVwceptQyTSoBAXCXT78yI4TD703qZrbOlaLqT9r08pHOPqcFg3yFVRx2B/7xs391tV5pP4pB/a750WzNmTV+iuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l0TJypjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l0TJypjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34741C433F1;
	Tue, 19 Mar 2024 20:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710880463;
	bh=hP78SXMHsTMMd4Q//Jo7PKjchTiUIFsJuQL4eeR3GHI=;
	h=Date:To:From:Subject:From;
	b=l0TJypjbaRk2jccgr8iBALzjSBOvPVcSu6X3RHNzHDU6y5QvgHGY7u6TPGL2u/KxE
	 8SddosdJF/lcfyCQbf6WHwYHM6c5OZYIEXvWprnZ2cmgIzCMi3DYjSDpubZ/gMOk6e
	 qCrgg612uU84DbQR5HFYKx6mAo2Vq4HlJLKCkZY8=
Date: Tue, 19 Mar 2024 13:34:22 -0700
To: mm-commits@vger.kernel.org,msakai@redhat.com,jserv@ccns.ncku.edu.tw,dm-devel@lists.linux.dev,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-incorrect-m-tag-for-dm-devel-listslinuxdev.patch added to mm-hotfixes-unstable branch
Message-Id: <20240319203423.34741C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: remove incorrect M: tag for dm-devel@lists.linux.dev
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-incorrect-m-tag-for-dm-devel-listslinuxdev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-incorrect-m-tag-for-dm-devel-listslinuxdev.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: MAINTAINERS: remove incorrect M: tag for dm-devel@lists.linux.dev
Date: Wed, 20 Mar 2024 02:18:42 +0800

The dm-devel@lists.linux.dev mailing list should only be listed under the
L: (List) tag in the MAINTAINERS file.  However, it was incorrectly listed
under both L: and M: (Maintainers) tags, which is not accurate.  Remove
the M: tag for dm-devel@lists.linux.dev in the MAINTAINERS file to reflect
the correct categorization.

Link: https://lkml.kernel.org/r/20240319181842.249547-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Michael Sclafani <dm-devel@lists.linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-incorrect-m-tag-for-dm-devel-listslinuxdev
+++ a/MAINTAINERS
@@ -6159,7 +6159,6 @@ F:	include/uapi/linux/dm-*.h
 
 DEVICE-MAPPER VDO TARGET
 M:	Matthew Sakai <msakai@redhat.com>
-M:	dm-devel@lists.linux.dev
 L:	dm-devel@lists.linux.dev
 S:	Maintained
 F:	Documentation/admin-guide/device-mapper/vdo*.rst
_

Patches currently in -mm which might be from visitorckw@gmail.com are

maintainers-remove-incorrect-m-tag-for-dm-devel-listslinuxdev.patch

