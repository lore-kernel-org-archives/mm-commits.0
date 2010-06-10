From: akpm@linux-foundation.org
Subject: + s5pc110-sdhci-s3c-can-override-host-capabilities.patch added to -mm tree
Date: Thu, 10 Jun 2010 13:43:14 -0700
Message-ID: <201006102043.o5AKhEtI022722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812Ab0FJUnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 16:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kmpark@infradead.org, kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     s5pc110: SDHCI-s3c can override host capabilities
has been added to the -mm tree.  Its filename is
     s5pc110-sdhci-s3c-can-override-host-capabilities.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s5pc110: SDHCI-s3c can override host capabilities
From: Kyungmin Park <kmpark@infradead.org>

Each board can override the default sdhci host capabilities.
Some board has broken features by hardwares and support 8-bit bandwidth.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-samsung/dev-hsmmc.c  |    2 ++
 arch/arm/plat-samsung/dev-hsmmc1.c |    2 ++
 arch/arm/plat-samsung/dev-hsmmc2.c |    2 ++
 3 files changed, 6 insertions(+)

diff -puN arch/arm/plat-samsung/dev-hsmmc.c~s5pc110-sdhci-s3c-can-override-host-capabilities arch/arm/plat-samsung/dev-hsmmc.c
--- a/arch/arm/plat-samsung/dev-hsmmc.c~s5pc110-sdhci-s3c-can-override-host-capabilities
+++ a/arch/arm/plat-samsung/dev-hsmmc.c
@@ -65,4 +65,6 @@ void s3c_sdhci0_set_platdata(struct s3c_
 		set->cfg_gpio = pd->cfg_gpio;
 	if (pd->cfg_card)
 		set->cfg_card = pd->cfg_card;
+	if (pd->host_caps)
+		set->host_caps = pd->host_caps;
 }
diff -puN arch/arm/plat-samsung/dev-hsmmc1.c~s5pc110-sdhci-s3c-can-override-host-capabilities arch/arm/plat-samsung/dev-hsmmc1.c
--- a/arch/arm/plat-samsung/dev-hsmmc1.c~s5pc110-sdhci-s3c-can-override-host-capabilities
+++ a/arch/arm/plat-samsung/dev-hsmmc1.c
@@ -65,4 +65,6 @@ void s3c_sdhci1_set_platdata(struct s3c_
 		set->cfg_gpio = pd->cfg_gpio;
 	if (pd->cfg_card)
 		set->cfg_card = pd->cfg_card;
+	if (pd->host_caps)
+		set->host_caps = pd->host_caps;
 }
diff -puN arch/arm/plat-samsung/dev-hsmmc2.c~s5pc110-sdhci-s3c-can-override-host-capabilities arch/arm/plat-samsung/dev-hsmmc2.c
--- a/arch/arm/plat-samsung/dev-hsmmc2.c~s5pc110-sdhci-s3c-can-override-host-capabilities
+++ a/arch/arm/plat-samsung/dev-hsmmc2.c
@@ -66,4 +66,6 @@ void s3c_sdhci2_set_platdata(struct s3c_
 		set->cfg_gpio = pd->cfg_gpio;
 	if (pd->cfg_card)
 		set->cfg_card = pd->cfg_card;
+	if (pd->host_caps)
+		set->host_caps = pd->host_caps;
 }
_

Patches currently in -mm which might be from kmpark@infradead.org are

mmc-recognize-csd-structure.patch
mmc-recognize-csd-structure-fix.patch
s5pc110-sdhci-s3c-can-override-host-capabilities.patch
s5pc110-sdhci-s3c-support-on-s5pc110.patch
sdhci-add-no-hi-speed-bit-quirk-support.patch

