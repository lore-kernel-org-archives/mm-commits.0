Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C081A8412
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161344; cv=none; b=gFJJf3XC2GzqYh9eCAxccdp5KZ7UF8LfVW4hUwF9hfVkwzTH7RIqy00oCRfL41NcMERq7kVQY1I7S7IGxxtrfhlw5RCbUMaH+W5NVL2dUGCA+fnIKsofjQffgNeELRyu5RjvBEphptkUV/agWfM3nYQIGK0OiZMAlAeA3N8oXnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161344; c=relaxed/simple;
	bh=CiAp+TC4Bjou0mC4W80lFmow40YBc8A1LM5pVCvOAx0=;
	h=Date:To:From:Subject:Message-Id; b=F1nSF8/0MzWGRkBMfzXgam3F87na8nQ7g/HqLqpjRs/yuDjuNBbxyt312oeZraDl75NUkQwpHVNMHH+6tz+AwUSNZhCGRrq4K3d/R7VHr/5Aqvg6M06yYF/99MPG8V5gD4AlRyiYqrOklHK7lQJy7GugKYjL250/zk9Woc/gcu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rsU7W+3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rsU7W+3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA16C4CEEF;
	Sat,  2 Aug 2025 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161343;
	bh=CiAp+TC4Bjou0mC4W80lFmow40YBc8A1LM5pVCvOAx0=;
	h=Date:To:From:Subject:From;
	b=rsU7W+3sDB2g/kkJyNhHGfs9kCkgG543dh4c0gGXFQSVE/katGWYfIzU9Ikcl1ZnN
	 Hh0gP6UeQGV5NquswuJo+rDtaPtpdgGOVSVxVFYUi4ynoPqoMhmtUplBKIHEwrANqP
	 WXe/mUcNS7flm5Ncm9zMeRcvaZeIcQxCtbIOemxs=
Date: Sat, 02 Aug 2025 12:02:23 -0700
To: mm-commits@vger.kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kvm-x86-fix-typo-notifer.patch removed from -mm tree
Message-Id: <20250802190223.9BA16C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KVM: x86: fix typo "notifer"
has been removed from the -mm tree.  Its filename was
     kvm-x86-fix-typo-notifer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


