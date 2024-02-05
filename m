Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D2813B7A9
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 21:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707167102; cv=none; b=i6A8C+dp0ovrgH3Gx4ryw9qvfy0lNLTgcVuFoM4TSL9ih2/qK9I2dlzu8XYIXJvgLqW49ALx23/lVdb4qjaTOQkOdB67tiBKR28V1EWUJh76gTeEgQQdHWhM4+KSP4Ha2RekTBjdVcRJWNDSkUzTFa9iE/+fXAQrjv6+dp1YdR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707167102; c=relaxed/simple;
	bh=bP9oke7VknXbrX6agz1nQXhHIWYI9uPHgbh0I+lmOhQ=;
	h=Date:To:From:Subject:Message-Id; b=bt3LiukWJfDKw6S33bUX1O2YQYEaKUfs063EX7fpAsKqxtuXEMLjlx400fu0jkd43tqOEIQgh+kMUiwRWgoyv52IQjO84Kg4jNQRzK3KDKrW8S1n8zMJlnmD3vunyehPRGSB0+ER4k9nJy4RAujy8Pd6C2/g347A4ULP8neU3+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CJBfdPiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CJBfdPiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7293C43394;
	Mon,  5 Feb 2024 21:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707167101;
	bh=bP9oke7VknXbrX6agz1nQXhHIWYI9uPHgbh0I+lmOhQ=;
	h=Date:To:From:Subject:From;
	b=CJBfdPiIp4UNiioO5RvXLwCijuPmKd64HLvpFMwOgpZIrxYEwry0GCDlNGFp1w7pR
	 RlSh78ZwW/GTidOjByIZk0e0ssdXGOdpfx7S7tm1OzjJTLGBR821Q0RzV2rINKj7jR
	 03NZkSdVRNDAWGPRiwhOq7YzPXB/hNsI845bowbM=
Date: Mon, 05 Feb 2024 13:05:01 -0800
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,linux@weissschuh.net,joe@perches.com,gregkh@linuxfoundation.org,dwaipayanray1@gmail.com,apw@canonical.com,ricardo@marliere.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + const_structscheckpatch-add-bus_type.patch added to mm-nonmm-unstable branch
Message-Id: <20240205210501.A7293C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: const_structs.checkpatch: add bus_type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     const_structscheckpatch-add-bus_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/const_structscheckpatch-add-bus_type.patch

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
From: "Ricardo B. Marliere" <ricardo@marliere.net>
Subject: const_structs.checkpatch: add bus_type
Date: Sun, 04 Feb 2024 19:39:57 -0300

Since commit d492cc2573a0 ("driver core: device.h: make struct bus_type a
const *"), the driver core can properly handle constant struct bus_type. 
Make sure that new usages of the struct already enter the tree as const.

Link: https://lkml.kernel.org/r/20240204-bus_cleanup-checkpatch-v1-1-8d51dcecda20@marliere.net
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Suggested-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-bus_type
+++ a/scripts/const_structs.checkpatch
@@ -2,6 +2,7 @@ acpi_dock_ops
 address_space_operations
 backlight_ops
 block_device_operations
+bus_type
 clk_ops
 comedi_lrange
 component_ops
_

Patches currently in -mm which might be from ricardo@marliere.net are

const_structscheckpatch-add-bus_type.patch

