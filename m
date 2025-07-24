Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0D61E1DEC
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 03:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753329266; cv=none; b=NqzivS8l0rbJCHUsEt1ri12vsmULuMFEnmNY+OKtZVsz0dvastQGe0N6MfTgS8B8BU9prCsu/+FMCboUUTWemjKM1E6SQiG7nBvChJfsvNG5iSKjqx8rOERMCJlEMyw5XadL2daTQ+FlfKTasaMVaFNhKbNQtTliSc6mVXAhmnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753329266; c=relaxed/simple;
	bh=ZYSeHR1ew5IG5ZCh8zmdepwRQESR9eb1cjxok/e7jPY=;
	h=Date:To:From:Subject:Message-Id; b=sgULtl4PRaA1Wykrf1TBFkKN9taoZF21zf9rn21XpDIAn2DlRWlWKOTel809zAaKot9p5rfoSvqfNSDOArUfvO24xodfEFioPQlBiZ+uTcW5nQoLYgJ+bMwA7ulfmL6KvushHgBPw5BeP0ZFtDsTZyeqWkp76HFpw4E/Oecai28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vpq/XKbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vpq/XKbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C5AC4CEED;
	Thu, 24 Jul 2025 03:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753329266;
	bh=ZYSeHR1ew5IG5ZCh8zmdepwRQESR9eb1cjxok/e7jPY=;
	h=Date:To:From:Subject:From;
	b=vpq/XKbpy62jz15u0WG+yc/9Ikqlj3eYlCXKGKUrWnOpBewc5MVdNhwqTG2hNtv0L
	 DrdrfXICDZeT9cVye4+AwEh1H0cPpxNEkXdqwdr5G0rG82VsPcGxDNxBU3HegrGCPj
	 a9CW6Y5x/bBKZLUxibyHAV2veB5PJYXDOS7mrjXQ=
Date: Wed, 23 Jul 2025 20:54:25 -0700
To: mm-commits@vger.kernel.org,johannes@sipsolutions.net,arend.vanspriel@broadcom.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] wifi-brcmfmac-fix-typo-notifer.patch removed from -mm tree
Message-Id: <20250724035426.00C5AC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: wifi: brcmfmac: fix typo "notifer"
has been removed from the -mm tree.  Its filename was
     wifi-brcmfmac-fix-typo-notifer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: wifi: brcmfmac: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:28 +0800

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lkml.kernel.org/r/6CA31F0821E6687F+20250722073431.21983-5-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c~wifi-brcmfmac-fix-typo-notifer
+++ a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -8313,7 +8313,7 @@ struct brcmf_cfg80211_info *brcmf_cfg802
 	cfg->d11inf.io_type = (u8)io_type;
 	brcmu_d11_attach(&cfg->d11inf);
 
-	/* regulatory notifer below needs access to cfg so
+	/* regulatory notifier below needs access to cfg so
 	 * assign it now.
 	 */
 	drvr->config = cfg;
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

kvm-x86-fix-typo-notifer.patch
cxl-mce-fix-typo-notifer.patch
drm-xe-fix-typo-notifer.patch
net-mvneta-fix-typo-notifer.patch
serial-8250_dw-fix-typo-notifer.patch
xen-xenbus-fix-typo-notifer.patch
scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch

