Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6939A28640E
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 21:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220459; cv=none; b=FJ/M09Z0Izb3yvt8Z6wTZZKEhfWauEF4z2Ho0myb3ardY8GWh/Kzao27VpPaxo0uy2oCWoUjaxVdnQfAk4IarsDPXGLCR+7hv9o9a9UQY6has/Kra+MJ6NWz3xb9YPBL1S/aEwOodC+wWG9V0UuKujE3wcdPfmVfQJ7nXB1wLHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220459; c=relaxed/simple;
	bh=KX4vDQ0f9XuxWLC1W3tJKWAw8xvXmKgyeqHDxS2qDwc=;
	h=Date:To:From:Subject:Message-Id; b=HwGELmKeMp7YLRgvCaTANxzxx+q4Qef1gsScFNRZN55p4gfaAtCiz4DmdrANGB3v3v6LDZ7FdedUcYGwo4JcELefoz6PaTyQPwek39rfcRGB9jfN3IJjKL4Mc/eRTbF88uC3tta7keHJGaYn2PN5tLneWQW3vIxbaJwBeuQxG5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ohjDL6o+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ohjDL6o+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B06C4CEEB;
	Tue, 22 Jul 2025 21:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753220457;
	bh=KX4vDQ0f9XuxWLC1W3tJKWAw8xvXmKgyeqHDxS2qDwc=;
	h=Date:To:From:Subject:From;
	b=ohjDL6o+G9f9qLU1ke5jtIn9+60f6eMcgJBgul9iSf6xSGFOUNoC+RwcN23nBXnO+
	 yoNWWhsXHSQOO444UqvqfMuJ5P0P3TJ2in+zCjV81sEWsEj3bDcRqrUu3j7LgqF2rO
	 n91B1QTrfOzj5uBkOh3jFT3MtkskdpSbQB9BUqK8=
Date: Tue, 22 Jul 2025 14:40:57 -0700
To: mm-commits@vger.kernel.org,arend.vanspriel@broadcom.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + wifi-brcmfmac-fix-typo-notifer.patch added to mm-nonmm-unstable branch
Message-Id: <20250722214057.D5B06C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: wifi: brcmfmac: fix typo "notifer"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     wifi-brcmfmac-fix-typo-notifer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/wifi-brcmfmac-fix-typo-notifer.patch

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
Subject: wifi: brcmfmac: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:28 +0800

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lkml.kernel.org/r/6CA31F0821E6687F+20250722073431.21983-5-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
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
wifi-brcmfmac-fix-typo-notifer.patch
serial-8250_dw-fix-typo-notifer.patch
xen-xenbus-fix-typo-notifer.patch
scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch

