Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82261286887
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 21:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220454; cv=none; b=KS98SojKme5LOwIcfRc04tOgz2+xww6482EfeTDWmjbcvHVy7IxatOuB8+4hFSHQqqomEfiFzeTkPwn129Gw+5D7yL7qlhVwvUrjW8CAWDHh0XxJzF97JxweysL2N4Uh8kux3fqQoRhILcFIA0W0j7Y6I/xrSc6BHTCn0P36GIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220454; c=relaxed/simple;
	bh=cexSb0PCKykAWHfeD5si0N22T+vmu5quuyLgLYaCLsI=;
	h=Date:To:From:Subject:Message-Id; b=pxU7haJs3/XPbZcFQKSQ7igJZx4q+ksaR3v+XwMgoHwy1zpQhpri+ETdHlT3xWHdvbBj6xnLENR6QWNLwwdpBOF6oc8Yux+0ZUDty98nZc+UmvVWzwHJe+lWneUlQPa8oHfK8dvjcQgcUEx8C5n1Lm0/S0vipruihQcQ04b9gF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ms/JlnsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ms/JlnsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E803BC4CEEB;
	Tue, 22 Jul 2025 21:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753220454;
	bh=cexSb0PCKykAWHfeD5si0N22T+vmu5quuyLgLYaCLsI=;
	h=Date:To:From:Subject:From;
	b=Ms/JlnsGlwTI2rLg8ao5MquxfVP9rP06Nf6/+jLGj5EqCeYPUBIoAKbbDv9giPueT
	 2+XKSNXQ+NB3QBOXhWSS+bl2vx8dg1DoO8StfYPMRbL+ZpbGpakGbJRc+T6yjv4gWy
	 zQOyI9FumSVZz5qO7Y7D0R+VMlMYJM9kJVOxJHgs=
Date: Tue, 22 Jul 2025 14:40:53 -0700
To: mm-commits@vger.kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-xe-fix-typo-notifer.patch added to mm-nonmm-unstable branch
Message-Id: <20250722214053.E803BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/xe: fix typo "notifer"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-xe-fix-typo-notifer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-xe-fix-typo-notifer.patch

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
Subject: drm/xe: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:26 +0800

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lkml.kernel.org/r/94190C5F54A19F3E+20250722073431.21983-3-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/xe/xe_vm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_vm_types.h~drm-xe-fix-typo-notifer
+++ a/drivers/gpu/drm/xe/xe_vm_types.h
@@ -259,7 +259,7 @@ struct xe_vm {
 		 * up for revalidation. Protected from access with the
 		 * @invalidated_lock. Removing items from the list
 		 * additionally requires @lock in write mode, and adding
-		 * items to the list requires either the @userptr.notifer_lock in
+		 * items to the list requires either the @userptr.notifier_lock in
 		 * write mode, OR @lock in write mode.
 		 */
 		struct list_head invalidated;
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

