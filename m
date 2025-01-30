Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF7D3987D;
	Thu, 30 Jan 2025 22:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738276790; cv=none; b=EixCfwqEobYyPJbfFc99Hdr8HDq5v50qR9RYt5m6Ba6kRttKjjnk8VT5QfA7dE0zTp2GOy06wcdCZm5LPpv8BR8Pr/PlEk4Ln465Dioilu4YLmrDDmpLgi63K94gjQEaTWKUIaniOJkRoD7WF1horEqae4EQe4kXcSYotRF0/sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738276790; c=relaxed/simple;
	bh=xBi8k8k0fa7Y7B8ARc3ifazTtPrMd7L7S5+HT9Opo+Y=;
	h=Date:To:From:Subject:Message-Id; b=kF1OAqMLUXonbJzhppMZX4gOuZKzu0xcYTerPDJKyR61LV1KGJQjp6jQAfPod38IinTNqPPq4cefsBTu/7w8KSKIwwyXGaAOPbqIhLVwEoAqeE3eDANejpD5gghIysxukE6HilDI0S3JsPmQGXlOxGKPxaSWpEg99McX8Cy2szM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lgkAS/sp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lgkAS/sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EBEC4CED2;
	Thu, 30 Jan 2025 22:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738276789;
	bh=xBi8k8k0fa7Y7B8ARc3ifazTtPrMd7L7S5+HT9Opo+Y=;
	h=Date:To:From:Subject:From;
	b=lgkAS/sp4Qt5tT+I5ezA5tEblTgGGtNRH8fdIqBTY+cVELsc7TyIuyq8jP4blxOuo
	 W9k0Kaaze88Y+CO+YA/q1WCthyJyf1XfrLOJv8GQaonCRePzrdfPtOntwZoXn7jF3k
	 XFqMioQHPkqmf53AyvA6HvlmgsxSOM7vsu/PkrKE=
Date: Thu, 30 Jan 2025 14:39:48 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,ojeda@kernel.org,luiz.von.dentz@intel.com,lkp@intel.com,geert@linux-m68k.org,anna-maria@linutronix.de,eahariha@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + jiffies-cast-to-unsigned-long-for-secs_to_jiffies-conversion.patch added to mm-hotfixes-unstable branch
Message-Id: <20250130223949.99EBEC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: jiffies: cast to unsigned long for secs_to_jiffies() conversion
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     jiffies-cast-to-unsigned-long-for-secs_to_jiffies-conversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/jiffies-cast-to-unsigned-long-for-secs_to_jiffies-conversion.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: jiffies: cast to unsigned long for secs_to_jiffies() conversion
Date: Thu, 30 Jan 2025 19:26:58 +0000

While converting users of msecs_to_jiffies(), lkp reported that some range
checks would always be true because of the mismatch between the implied
int value of secs_to_jiffies() vs the unsigned long return value of the
msecs_to_jiffies() calls it was replacing.  Fix this by casting
secs_to_jiffies() values as unsigned long.

Link: https://lkml.kernel.org/r/20250130192701.99626-1-eahariha@linux.microsoft.com
Fixes: b35108a51cf7ba ("jiffies: Define secs_to_jiffies()")
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501301334.NB6NszQR-lkp@intel.com/
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: <stable@vger.kernel.org>	[6.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/jiffies.h~jiffies-cast-to-unsigned-long-for-secs_to_jiffies-conversion
+++ a/include/linux/jiffies.h
@@ -537,7 +537,7 @@ static __always_inline unsigned long mse
  *
  * Return: jiffies value
  */
-#define secs_to_jiffies(_secs) ((_secs) * HZ)
+#define secs_to_jiffies(_secs) (unsigned long)((_secs) * HZ)
 
 extern unsigned long __usecs_to_jiffies(const unsigned int u);
 #if !(USEC_PER_SEC % HZ)
_

Patches currently in -mm which might be from eahariha@linux.microsoft.com are

jiffies-cast-to-unsigned-long-for-secs_to_jiffies-conversion.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies.patch
accel-habanalabs-convert-timeouts-to-secs_to_jiffies.patch
alsa-ac97-convert-timeouts-to-secs_to_jiffies.patch
btrfs-convert-timeouts-to-secs_to_jiffies.patch
rbd-convert-timeouts-to-secs_to_jiffies.patch
libceph-convert-timeouts-to-secs_to_jiffies.patch
libata-zpodd-convert-timeouts-to-secs_to_jiffies.patch
xfs-convert-timeouts-to-secs_to_jiffies.patch
power-supply-da9030-convert-timeouts-to-secs_to_jiffies.patch
nvme-convert-timeouts-to-secs_to_jiffies.patch
spi-spi-fsl-lpspi-convert-timeouts-to-secs_to_jiffies.patch
spi-spi-imx-convert-timeouts-to-secs_to_jiffies.patch
platform-x86-amd-pmf-convert-timeouts-to-secs_to_jiffies.patch
platform-x86-thinkpad_acpi-convert-timeouts-to-secs_to_jiffies.patch
rdma-bnxt_re-convert-timeouts-to-secs_to_jiffies.patch

