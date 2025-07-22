Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E9827A446
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 21:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220456; cv=none; b=OvShy53iAh/BHhNT+RkbmZXURJ/4VewSIX1JEkUO2Mxv45AZV0rBxGPQCO4LlDm/Zle/NoBq/gnlf5Pec6KKLPpADrafXr3CLECpAz5FHkBZAPESDm3iMC9sW6Yi5wRSw1A89T3mcgc9Q36X/OvF6V/qTLGCjvUbm7oSd6w0ZO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220456; c=relaxed/simple;
	bh=JEZt9mzYPZXwa/7+0y6cm/MOV9fss7d2SVKx70DPWzU=;
	h=Date:To:From:Subject:Message-Id; b=GTxYVg0Fe0lFp9WUT4ECSTSmw7AYDyNjPpj9CsggGccz3jWW81ZYbEzQY6fa8U3bztQAkdB+dUqi0N5ogV/1qYVS1HfHvwoNJmf9IePMQSAAbPbjR+UNvj7FaY78rprX2AurpZ5huXhsk6tvGWOLxaeGwStoQjmr/SPcoyfwg94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xzDwjQHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xzDwjQHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2316C4CEEB;
	Tue, 22 Jul 2025 21:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753220456;
	bh=JEZt9mzYPZXwa/7+0y6cm/MOV9fss7d2SVKx70DPWzU=;
	h=Date:To:From:Subject:From;
	b=xzDwjQHvKsQvJb2G8FwuYuqBo3eJHkPV+kBnYI70vdDjLis6dAa1WaNZjaqALkF7L
	 E7h5fIjORlz0VtZqG3UdK6HOBsuDIUPPbktvDWjh+6Ssdw5rYl3tQKDMGR0oiezs5K
	 HNyq3/kXCrZ1HgQ6jqwCyezpxF38ziL+ZmXPDs6I=
Date: Tue, 22 Jul 2025 14:40:55 -0700
To: mm-commits@vger.kernel.org,horms@kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + net-mvneta-fix-typo-notifer.patch added to mm-nonmm-unstable branch
Message-Id: <20250722214055.F2316C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: net: mvneta: fix typo "notifer"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     net-mvneta-fix-typo-notifer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/net-mvneta-fix-typo-notifer.patch

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
Subject: net: mvneta: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:27 +0800

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lkml.kernel.org/r/0CB4300CB6F49007+20250722073431.21983-4-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/marvell/mvneta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvneta.c~net-mvneta-fix-typo-notifer
+++ a/drivers/net/ethernet/marvell/mvneta.c
@@ -4610,7 +4610,7 @@ static int mvneta_stop(struct net_device
 		/* Inform that we are stopping so we don't want to setup the
 		 * driver for new CPUs in the notifiers. The code of the
 		 * notifier for CPU online is protected by the same spinlock,
-		 * so when we get the lock, the notifer work is done.
+		 * so when we get the lock, the notifier work is done.
 		 */
 		spin_lock(&pp->lock);
 		pp->is_stopped = true;
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

