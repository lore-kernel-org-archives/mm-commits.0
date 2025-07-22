Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0553D286426
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 21:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220462; cv=none; b=U3Per3l68RwDbvLpQS4MS10tMc3PNu797WEfR0KtoV9d6dCBgQWg9YKi4hsiWOrAbhrtaDnZryYp/Q8nSHidzGS04wNdz+Pi6OIEBf/ubaP6uIQHR5x/D5q6F5xw9kn7veYWLG3qKstYok/Mtb9Un48q1mhTIwpwm15HyUec5ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220462; c=relaxed/simple;
	bh=PNWefVrHLdG6r7zCGRcEm39ZNRHyetRkr6WcNGhVWFM=;
	h=Date:To:From:Subject:Message-Id; b=Ur1iXRpos4INqht7IZoDYPqohyalL5R/B8Il7bDh6ydiJA+o7tNeCN4IB8jglcZdH05l6fKBbXR+roO4FHIMUOEWRYzT6g2AnexhJmKxbo/EbxZdsXlpSwO0g7uEs+eGjtXK+WS4yf2zvOGF2ZIaVQzvYS+udI+vLhkeEpVIIoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sLu/bg9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sLu/bg9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FC1C4CEEB;
	Tue, 22 Jul 2025 21:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753220461;
	bh=PNWefVrHLdG6r7zCGRcEm39ZNRHyetRkr6WcNGhVWFM=;
	h=Date:To:From:Subject:From;
	b=sLu/bg9qTSuLp81B+Uz7QOpUvZv2syMmBZEXpad/JKCtKQfrSe7+5EjwaMtYXEfTM
	 L4hKAo30F4jaRh/Cc/LYeu40x4aivvumm8aefcV/rtZoG7vA/635L8BA8T9kD6TbhZ
	 3AL4+fM8SFq6rFweR8f/l5ZH6Y0PdV06PvWloro8=
Date: Tue, 22 Jul 2025 14:41:01 -0700
To: mm-commits@vger.kernel.org,jgross@suse.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xen-xenbus-fix-typo-notifer.patch added to mm-nonmm-unstable branch
Message-Id: <20250722214101.81FC1C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xen/xenbus: fix typo "notifer"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xen-xenbus-fix-typo-notifer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xen-xenbus-fix-typo-notifer.patch

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
From: WangYuli <wangyuli@uniontech.com>
Subject: xen/xenbus: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:30 +0800

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lkml.kernel.org/r/C6633C66376C709A+20250722073431.21983-7-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/xen/xenbus.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/xen/xenbus.h~xen-xenbus-fix-typo-notifer
+++ a/include/xen/xenbus.h
@@ -180,7 +180,7 @@ int xenbus_printf(struct xenbus_transact
  * sprintf-style type string, and pointer. Returns 0 or errno.*/
 int xenbus_gather(struct xenbus_transaction t, const char *dir, ...);
 
-/* notifer routines for when the xenstore comes up */
+/* notifier routines for when the xenstore comes up */
 extern int xenstored_ready;
 int register_xenstore_notifier(struct notifier_block *nb);
 void unregister_xenstore_notifier(struct notifier_block *nb);
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

kvm-x86-fix-typo-notifer.patch
cxl-mce-fix-typo-notifer.patch
drm-xe-fix-typo-notifer.patch
net-mvneta-fix-typo-notifer.patch
wifi-brcmfmac-fix-typo-notifer.patch
serial-8250_dw-fix-typo-notifer.patch
xen-xenbus-fix-typo-notifer.patch
scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch

