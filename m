Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF322185AA
	for <mm-commits@vger.kernel.org>; Tue,  8 Apr 2025 05:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744091421; cv=none; b=JEEvACgliaXhnixLQSZv8heCO6ma4DkaaYnXiGJDp+PUfFPyxII2l8wvoAWIcVr5V3cnLVnXbVQIc6wE5xbCOp3T5zgJOC1MUVZc7kpHNFgWw/FCBQx6Yj8rUkhDjrhlnfum3ofB95S5WiMHizXf8rOZX3CVQ/TESs1HuHZblWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744091421; c=relaxed/simple;
	bh=Wt3e8r/AnlkfJA/+wkpedM4gFQlhD26JtyrOkWjmiPc=;
	h=Date:To:From:Subject:Message-Id; b=BitsAkZztz+nFGGtRCd++nBF0fJh/9kkUnKeUdPw1Px/I66v+K4fXNvC7/3xaOXd4rAoVU8wxiAUO1A/vMmAvh8W/7iYkHxNJgdgkglJljDJVl6krAsORAh0n7bE5FHtfejqKTK3FGF80/pqayObK2T5u/BFzaKDob1WowKjXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zyKVIGhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zyKVIGhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E06C4CEE5;
	Tue,  8 Apr 2025 05:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744091419;
	bh=Wt3e8r/AnlkfJA/+wkpedM4gFQlhD26JtyrOkWjmiPc=;
	h=Date:To:From:Subject:From;
	b=zyKVIGhXYZb7IdiIEkN9azVWfhVr7CxseJmT8u2Q411qWC3ZUu9T59e/KUVJ477Y8
	 8ZHK494H5wLrRKZJ/Yjm2OC1UzdAjo0toDoHnWcgTGyrjxm9KDzqXifQrQRnYT4m+K
	 swPr6XPmxvOa0tQu1A8ybqv/Jrn6xni6cQG9iQt4=
Date: Mon, 07 Apr 2025 22:50:18 -0700
To: mm-commits@vger.kernel.org,sstabellini@kernel.org,sfr@canb.auug.org.au,oleksandr_tyshchenko@epam.com,masahiroy@kernel.org,jgross@suse.com,jeff.johnson@oss.qualcomm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] xenbus-add-module-description.patch removed from -mm tree
Message-Id: <20250408055019.36E06C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xenbus: add module description
has been removed from the -mm tree.  Its filename was
     xenbus-add-module-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: xenbus: add module description
Date: Mon, 24 Mar 2025 18:32:30 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/xen/xenbus/xenbus_probe_frontend.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-5-arnd@kernel.org
Fixes: 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/xenbus/xenbus_probe_frontend.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/xenbus/xenbus_probe_frontend.c~xenbus-add-module-description
+++ a/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -513,4 +513,5 @@ static int __init boot_wait_for_devices(
 late_initcall(boot_wait_for_devices);
 #endif
 
+MODULE_DESCRIPTION("Frontend for Xen bus probe");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arnd@arndb.de are

asn1-add-module-description.patch
samples-livepatch-add-module-descriptions.patch
fpga-tests-add-module-descriptions.patch
zlib-add-module-description.patch
ucs2_string-add-module-description.patch
mm-kasan-add-module-decription.patch
kunit-slub-add-module-description.patch

