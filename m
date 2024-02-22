Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AA813BAF9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645219; cv=none; b=PM0yacsApIJuwjlNZ+mC1FtgipWfs1UlDM1NyILKjvrGYeM4HxW1FSkGKoKhI4/mY/KwdhwG/JIXswUdnLtYjjA03ykGPP12zdy3ibWIkhMWJ6S0ktZnt4RCAiONkwD6jErG/rozu+Chr2Gp8iT1TjY5XAlSLuIGicRzJqAUrFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645219; c=relaxed/simple;
	bh=8pHJCqBCSagkOmRE2IRiQpt6EnkGylosHdUYHGA7GoI=;
	h=Date:To:From:Subject:Message-Id; b=P2++vDb7ZfrweP4bSIUFK1a+XxTCccht3XvK9nh1lM9xrZAbTxhcYJYdrzdXWe9Hrd81lqwdi2CBvTDTSBzo+PRU53SWVADS6UPck2vxPWEgipDaHW1eLBEDsMPfk/YTMADx33OwlGgoz0b3QWuy9+09vHS+kliLGwuOdmq+KMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uzyr1lO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uzyr1lO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A00C433F1;
	Thu, 22 Feb 2024 23:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645218;
	bh=8pHJCqBCSagkOmRE2IRiQpt6EnkGylosHdUYHGA7GoI=;
	h=Date:To:From:Subject:From;
	b=Uzyr1lO9zruJwTNJPqaBVBKl9KM49/Ax7/zbrg874LBuOOVzWoyIA7ITMmANOmvMn
	 xmEvUe7iEBSAIBUAJVjgN6RymGlmoobdhKAR7Qtb2A+sDw/HqfQIHvNWc/9dR7/AWL
	 8DoZC9ZXsCDUmWRw/SoXULnVv66VPwsHPgxaiSow=
Date: Thu, 22 Feb 2024 15:40:18 -0800
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,linux@weissschuh.net,joe@perches.com,gregkh@linuxfoundation.org,dwaipayanray1@gmail.com,apw@canonical.com,ricardo@marliere.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] const_structscheckpatch-add-bus_type.patch removed from -mm tree
Message-Id: <20240222234018.95A00C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: const_structs.checkpatch: add bus_type
has been removed from the -mm tree.  Its filename was
     const_structscheckpatch-add-bus_type.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

const_structscheckpatch-add-device_type.patch

