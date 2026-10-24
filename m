Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828037;
	b=EXCPD9ld4N7Goo1qH67ftx3wyt6hhPKJGPfcgceeyCF4/DYLRvKyJj8YfaSRs90mYLfN
	 2vYKXZZWrNLHVlD50HWzHasEqMP1LT8fm8BJO3rOx8N8H6+B05qm3p0tZ/l6mvJ7pz9I0
	 7l2BnZ2R8pWfQq1ZqudsMGQinjSwVYcgmRJmx2NygDTMBZHY+cQHwj5DltLBjZh0Bz+uA
	 SXQ3ns6DnaWzwI/H0GkmxK6j8mdnmn4yhkWDQLeaiWPzxR3cNJqNoGAFPFqAG4pfb5pQy
	 2xS2tUD/5KefR4VxwgEWmIaHHp/ukNsg8tutZuh4LPaD3FHK3bdIfr2LmNj/+iKOaBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828037;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Lnkgwz4trgVqQULm4yNCShUCh1VH69J0jhfcrdupSRw=;
	b=EIyPIw/B5MkLEDEArmPT/cf6gOw/33cEwyZ9aQTlBHzV1gUVKU8FOIKtyEBfQLqoM/V6
	 fN3xZSEaRt18lWueAgFC5cavNlTXEXUS6IfjOJZmwECfwGRopeEqxdq5DjjQRUV3bkP89
	 9s2Ng6hg0/3+WzwQeqElJL0tBZtYnOe9L4rV60+2SiaQGWq7X5XrfPqXRP/UngHvHf4El
	 eoWWIBlPcRjG3Cdgu2iXu0HPEGB9Dqa03k4oq+EJ/O4lBsOAnK7cPzScf3IvbrJKusgXs
	 ALo8e1DLAMZf7z16dhmGwlsRPmThqi2KT2EUub7C2lKN/qjgpWwat1MoUj8wjK1JoVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WGBsSLYi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC63606A327
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 07:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WGBsSLYi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7BA1F01825;
	Sat, 24 Oct 2026 07:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828037;
	bh=Lnkgwz4trgVqQULm4yNCShUCh1VH69J0jhfcrdupSRw=;
	h=Date:To:From:Subject;
	b=WGBsSLYiYDsquxXsKDM6nNg/1JzoX3XR5Gqq15k6lbPyXaX142RdrKmK5nH+zTjSg
	 oTpcAr2JoYN2ECgPNsDhtkPkzMxGgw0DLut7VKkUFStFqR/+iS1fuYCrNGlLDXS6ut
	 Tw/TJM0BTIUPLkFmGf1AKhHk0Psjt9VYvEjWXp4k=
Date: Sat, 24 Oct 2026 00:47:16 -0700
To: mm-commits@vger.kernel.org,martink@posteo.de,kuba@kernel.org,cel@kernel.org,alex@sverdlin.org,markus.mayer@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-update-my-e-mail-address.patch removed from -mm tree
Message-Id: <20261024074717.2A7BA1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: update Markus's e-mail address
has been removed from the -mm tree.  Its filename was
     maintainers-update-my-e-mail-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Markus Mayer <markus.mayer@broadcom.com>
Subject: MAINTAINERS: update Markus's e-mail address
Date: Thu, 22 Oct 2026 14:19:48 -0700

Classic Broadcom e-mail addresses were recently phased out.  Update
MAINTAINERS to the new format.  Also add an entry to .mailmap for said
address.

Finally, since I am already touching .mailmap, I may as well map an
ancient Linaro address, as well.

Link: https://lore.kernel.org/20261022211949.42939-1-markus.mayer@broadcom.com
Signed-off-by: Markus Mayer <markus.mayer@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexander Sverdlin <alex@sverdlin.org>
Cc: Chuck Lever <cel@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
---

 .mailmap    |    2 ++
 MAINTAINERS |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/.mailmap~maintainers-update-my-e-mail-address
+++ a/.mailmap
@@ -597,6 +597,8 @@ Marek Lindner <marek.lindner@mailbox.org
 Marek Lindner <marek.lindner@mailbox.org> <mareklindner@neomailbox.ch>
 Mark Brown <broonie@sirena.org.uk>
 Mark Starovoytov <mstarovo@pm.me> <mstarovoitov@marvell.com>
+Markus Mayer <markus.mayer@broadcom.com> <mmayer@broadcom.com>
+Markus Mayer <markus.mayer@broadcom.com> <markus.mayer@linaro.org>
 Markus Schneider-Pargmann <msp@baylibre.com> <mpa@pengutronix.de>
 Mark Yao <markyao0591@gmail.com> <mark.yao@rock-chips.com>
 Martin K. Petersen <mkp@kernel.org> <martin.petersen@oracle.com>
--- a/MAINTAINERS~maintainers-update-my-e-mail-address
+++ a/MAINTAINERS
@@ -5296,7 +5296,7 @@ F:	Documentation/devicetree/bindings/usb
 F:	drivers/usb/gadget/udc/bdc/
 
 BROADCOM BMIPS CPUFREQ DRIVER
-M:	Markus Mayer <mmayer@broadcom.com>
+M:	Markus Mayer <markus.mayer@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
@@ -5571,7 +5571,7 @@ F:	drivers/spi/spi-brcmstb-qspi.c
 F:	drivers/spi/spi-iproc-qspi.c
 
 BROADCOM STB AVS CPUFREQ DRIVER
-M:	Markus Mayer <mmayer@broadcom.com>
+M:	Markus Mayer <markus.mayer@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
@@ -5579,7 +5579,7 @@ F:	Documentation/devicetree/bindings/cpu
 F:	drivers/cpufreq/brcmstb*
 
 BROADCOM STB AVS TMON DRIVER
-M:	Markus Mayer <mmayer@broadcom.com>
+M:	Markus Mayer <markus.mayer@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
@@ -5587,7 +5587,7 @@ F:	Documentation/devicetree/bindings/the
 F:	drivers/thermal/broadcom/brcmstb*
 
 BROADCOM STB DPFE DRIVER
-M:	Markus Mayer <mmayer@broadcom.com>
+M:	Markus Mayer <markus.mayer@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
_

Patches currently in -mm which might be from markus.mayer@broadcom.com are


