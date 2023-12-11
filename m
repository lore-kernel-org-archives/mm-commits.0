Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4287493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="csrd3/cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63553C433CA;
	Mon, 11 Dec 2023 01:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257815;
	bh=ls91sYG06cRtoQJVjKZhneEnSOVI4IT3czV61F4JZI8=;
	h=Date:To:From:Subject:From;
	b=csrd3/cfOuEO+1bgt5lxQWhrbz2RYCm+cB3vCqpRYZ92NC34AmEADZpzZ8rugnmVU
	 TjiwjkpcVg7xLmvQM5OIl/c7QHprPm+14JUHzNVR16vCVaOITxfJ7j06sBut35RCUT
	 Nh9V8U2aDDxGvMibin9WX1zcvoIejoDPiu6nIXjA=
Date: Sun, 10 Dec 2023 17:23:34 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-rs870e-stop-exporting-local-functions.patch removed from -mm tree
Message-Id: <20231211012335.63553C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: rs870e: stop exporting local functions
has been removed from the -mm tree.  Its filename was
     mips-rs870e-stop-exporting-local-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: rs870e: stop exporting local functions
Date: Mon, 4 Dec 2023 12:56:54 +0100

These four functions are exported, but don't have any users, and no
prototypes, which now causes warnings:

drivers/platform/mips/rs780e-acpi.c:35:6: error: no previous prototype for 'pm_iowrite' [-Werror=missing-prototypes]
drivers/platform/mips/rs780e-acpi.c:41:4: error: no previous prototype for 'pm_ioread' [-Werror=missing-prototypes]
drivers/platform/mips/rs780e-acpi.c:47:6: error: no previous prototype for 'pm2_iowrite' [-Werror=missing-prototypes]
drivers/platform/mips/rs780e-acpi.c:53:4: error: no previous prototype for 'pm2_ioread' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-5-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/mips/rs780e-acpi.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/platform/mips/rs780e-acpi.c~mips-rs870e-stop-exporting-local-functions
+++ a/drivers/platform/mips/rs780e-acpi.c
@@ -32,29 +32,25 @@ static u8 pmio_read_index(u16 index, u8
 	return inb(index + 1);
 }
 
-void pm_iowrite(u8 reg, u8 value)
+static void pm_iowrite(u8 reg, u8 value)
 {
 	pmio_write_index(PM_INDEX, reg, value);
 }
-EXPORT_SYMBOL(pm_iowrite);
 
-u8 pm_ioread(u8 reg)
+static u8 pm_ioread(u8 reg)
 {
 	return pmio_read_index(PM_INDEX, reg);
 }
-EXPORT_SYMBOL(pm_ioread);
 
-void pm2_iowrite(u8 reg, u8 value)
+static void pm2_iowrite(u8 reg, u8 value)
 {
 	pmio_write_index(PM2_INDEX, reg, value);
 }
-EXPORT_SYMBOL(pm2_iowrite);
 
-u8 pm2_ioread(u8 reg)
+static u8 pm2_ioread(u8 reg)
 {
 	return pmio_read_index(PM2_INDEX, reg);
 }
-EXPORT_SYMBOL(pm2_ioread);
 
 static void acpi_hw_clear_status(void)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

