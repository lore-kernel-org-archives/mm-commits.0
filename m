Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1574122B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671942; cv=none; b=fJGvuFNHzOzuqyB/EEBMK3hnMloZVfJoL0Iz8hQ+lJ0+1Gwl5/LO/Sq5rzzp9zFkYifUD0C17ZpVmLBelog34naXIEbzevWL3d/OYywk8HQG+ZgFLMD051OQZ9c73xxCMD+FudZmCByAch8Tiip6H9vJj/INVyzmjiUbQnpWVq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671942; c=relaxed/simple;
	bh=5QN2+e+rnQCjm4IKgpNwbv6nbv/UGVGoqnteBpZvcjI=;
	h=Date:To:From:Subject:Message-Id; b=c1HWgcS8G7My2XYGbvHSUGraaT82z/SefdxtJsFg70M0GmoXReoNj/6sDlDXbX0Y7IQawkSEDjEjY2DS4twprasOIj+EnN1hfFD6jdyijjv23mgMIBjwPQL91ZIGXVQZtOEH6ShI/patCHJMkqmSB8HJyknS3jA8HD/IaI1W1XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SumCNo22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SumCNo22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1227C4CEF7;
	Sat, 28 Mar 2026 04:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671942;
	bh=5QN2+e+rnQCjm4IKgpNwbv6nbv/UGVGoqnteBpZvcjI=;
	h=Date:To:From:Subject:From;
	b=SumCNo22X7xCDPjoSlMeFwZeOO7pC+yVob06nsO2bvdfgVtxA38Ad25jmgphQiaib
	 005gdEMfb6JG4uab+nH4UXiR+nlFYwGLG12aOs2PAEv2vw6awhASu3YAffb3yMHkBJ
	 8pJEBov3lB43TRFXsbygLGQHUP69EheU60PrpiME=
Date: Fri, 27 Mar 2026 21:25:41 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,lkp@intel.com,jiang.kun2@zte.com.cn,bsingharora@gmail.com,arnd@arndb.de,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-getdelays-use-the-static-uapi-headers-from-tools-include-uapi.patch removed from -mm tree
Message-Id: <20260328042541.E1227C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/getdelays: use the static UAPI headers from tools/include/uapi
has been removed from the -mm tree.  Its filename was
     tools-getdelays-use-the-static-uapi-headers-from-tools-include-uapi.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: tools/getdelays: use the static UAPI headers from tools/include/uapi
Date: Sat, 07 Mar 2026 09:47:53 +0100

The include directory ../../usr/include is only present if an in-tree
kernel build with CONFIG_HEADERS_INSTALL was done before.
Otherwise the system UAPI headers are used, which most likely are not
the most recent ones.

To make sure to always have access to up-to-date UAPI headers,
use the static copy in tools/include/uapi.

Link: https://lkml.kernel.org/r/20260307-accounting-taskstats-h-v1-2-0b75915c6ce5@weissschuh.net
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202603062103.Z5fecwZD-lkp@intel.com/
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Jiang Kun <jiang.kun2@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/accounting/Makefile~tools-getdelays-use-the-static-uapi-headers-from-tools-include-uapi
+++ a/tools/accounting/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 CC := $(CROSS_COMPILE)gcc
-CFLAGS := -I../../usr/include
+CFLAGS := -I../include/uapi/
 
 PROGS := getdelays procacct delaytop
 
_

Patches currently in -mm which might be from linux@weissschuh.net are


