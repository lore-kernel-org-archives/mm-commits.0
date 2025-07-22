Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA522868BD
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 21:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220450; cv=none; b=UOtgf1zd+voB5ZIiVyzFIQyqpwnXuh2Em7sshxPEy7/QZPC7YuZ5IGxloXpwoEExb7v5ONd1ufRAXZq1t1tKOZAqVDixGTEEZjV6Y8EKfO267PMd9PcQN2qYmDpZWdRIMdwuNFaenWil1hKR65SKxtclJpR2gxmrOm0sF/+m38Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220450; c=relaxed/simple;
	bh=h94EginYmX+bWNaNBphicJfgBBCyIsxKZZ5b75hhVog=;
	h=Date:To:From:Subject:Message-Id; b=HQ96qTM0PC4Tb/7ZgWbQESsRBfEt0oBFW+pQeeIADInZOJXzsTTNhChz+AJQ8qwMbW+ZQAeJmCssm+vfP9YvF4dzUI7cy1mHyzoojZVejfjfQ2Gd8c592aRi7XjJuEoD5LHwaGQRba1MY+q0iB39pU12Fme0DsDtOU3z3k78Nvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RX2V3fE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RX2V3fE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E39C4CEEB;
	Tue, 22 Jul 2025 21:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753220450;
	bh=h94EginYmX+bWNaNBphicJfgBBCyIsxKZZ5b75hhVog=;
	h=Date:To:From:Subject:From;
	b=RX2V3fE6F7icg62tJUezT2/eMQdxavA0AC+IhQy8un/zWyqxnu89qNfmP/vzlXVfV
	 mh4wxg7IrD9/Gi+dCmcWMqu8fEtx7zLWAgIH2QiTu6pEjTz1zblOHVcpBcqxgxsKuR
	 9DST/LnOyMoHNhGp7Es9+ZwoikLPA24++GKgZsGs=
Date: Tue, 22 Jul 2025 14:40:49 -0700
To: mm-commits@vger.kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kvm-x86-fix-typo-notifer.patch added to mm-nonmm-unstable branch
Message-Id: <20250722214050.30E39C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KVM: x86: fix typo "notifer"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kvm-x86-fix-typo-notifer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kvm-x86-fix-typo-notifer.patch

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
Subject: KVM: x86: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:24 +0800

Patch series "treewide: Fix typo "notifer"", v3.

There are some spelling mistakes of 'notifer' in comments which
should be 'notifier'.

Fix them and add it to scripts/spelling.txt.


This patch (of 8):

There are some spelling mistakes of 'notifer' which should be 'notifier'.

Link: https://lkml.kernel.org/r/576F0D85F6853074+20250722072734.19367-1-wangyuli@uniontech.com
Link: https://lkml.kernel.org/r/7F05778C3A1A9F8B+20250722073431.21983-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/i8254.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/i8254.c~kvm-x86-fix-typo-notifer
+++ a/arch/x86/kvm/i8254.c
@@ -641,7 +641,7 @@ static void kvm_pit_reset(struct kvm_pit
 	kvm_pit_reset_reinject(pit);
 }
 
-static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
+static void pit_mask_notifier(struct kvm_irq_mask_notifier *kimn, bool mask)
 {
 	struct kvm_pit *pit = container_of(kimn, struct kvm_pit, mask_notifier);
 
@@ -694,7 +694,7 @@ struct kvm_pit *kvm_create_pit(struct kv
 
 	pit_state->irq_ack_notifier.gsi = 0;
 	pit_state->irq_ack_notifier.irq_acked = kvm_pit_ack_irq;
-	pit->mask_notifier.func = pit_mask_notifer;
+	pit->mask_notifier.func = pit_mask_notifier;
 
 	kvm_pit_reset(pit);
 
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

