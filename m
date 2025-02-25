Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBBF367
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 03:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740454705; cv=none; b=AFSpgcbh6rJG+WrEJi1tQPaKEsXxs574lVm01ncPRVG21iUvas2q6sdbmA97Dw13B9ZX2uiAfcw1N0gTHE7xU/ogjr9BbTlRy0PRlO4HXW9cnAoMTrb5TZHyAIEKXR8t9OU6ZNzjV8P3rLk0W9d3fAmG5tq30vrxdtRTw3/qAZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740454705; c=relaxed/simple;
	bh=2r+Ee8CIVdi7nxFMcgybPsgVGFocxrKfArRqjiev6Rg=;
	h=Date:To:From:Subject:Message-Id; b=rrI4iQ79xEHcbnjjOwrul0cT/URWH7BGiTuU2k9DH00AKqxCtNpRFM6i1faNmkzQTAYBOGntz4HMzYW0ay1wgcPrn3exQ3UQvusnU6LpkJ5OGyUQJs8BjzIjRJgcOr0J0fO8FYoeBcmEs4914l8NS3oZqrTV+i5/ZHNiNDXsMP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DrtoruNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DrtoruNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46AFC4CEE2;
	Tue, 25 Feb 2025 03:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740454704;
	bh=2r+Ee8CIVdi7nxFMcgybPsgVGFocxrKfArRqjiev6Rg=;
	h=Date:To:From:Subject:From;
	b=DrtoruNRjc/iIhIGhB02sI5rMpAO0L1J+LRy1xO0Om1x4bf0xtiqO+eZsw81fTX73
	 M4ZduS56WNs1XoE/np+dEQz3J6h1iR5jP5kLQBUKRTNPDObMTIpNPHI6PRD9bOU2pA
	 ZeyNouTWJag4ZaiqwCuWQeF+MYn69tp3RlhIYihI=
Date: Mon, 24 Feb 2025 19:38:24 -0800
To: mm-commits@vger.kernel.org,tzungbi@kernel.org,joel.granados@kernel.org,a.fatoum@pengutronix.de,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-add-support-for-configuring-emergency-hardware-protection-action-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250225033824.A46AFC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: reboot: hide unused hw_protection_attr
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-add-support-for-configuring-emergency-hardware-protection-action-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-add-support-for-configuring-emergency-hardware-protection-action-fix.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: reboot: hide unused hw_protection_attr
Date: Mon, 24 Feb 2025 15:16:09 +0100

The reference to hw_protection_attr is inside of an #ifdef block, but the
definition is not:

kernel/reboot.c:1092:30: error: unused variable 'hw_protection_attr' [-Werror,-Wunused-variable]
 1092 | static struct kobj_attribute hw_protection_attr = __ATTR_RW(hw_protection);
      |                              ^~~~~~~~~~~~~~~~~~

Add another #ifdef to match the first.

Link: https://lkml.kernel.org/r/20250224141849.1546019-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/reboot.c~reboot-add-support-for-configuring-emergency-hardware-protection-action-fix
+++ a/kernel/reboot.c
@@ -1071,6 +1071,7 @@ static int __init hw_protection_setup(ch
 }
 __setup("hw_protection=", hw_protection_setup);
 
+#ifdef CONFIG_SYSFS
 static ssize_t hw_protection_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
@@ -1090,6 +1091,7 @@ static ssize_t hw_protection_store(struc
 	return count;
 }
 static struct kobj_attribute hw_protection_attr = __ATTR_RW(hw_protection);
+#endif
 
 static int __init reboot_setup(char *str)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

reboot-add-support-for-configuring-emergency-hardware-protection-action-fix.patch

