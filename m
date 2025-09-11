Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE7927603B
	for <mm-commits@vger.kernel.org>; Thu, 11 Sep 2025 20:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757623820; cv=none; b=vEVnXCHy9IzoRWdgA/QWwrxuFLRkv5xKv2zrkdOIlvx9ag1x4yvqsM0FKPpTctdzrvy8SYImyTc80qjQEQuy94aZ/pW0RcwQ/jqe3AFW7x1WZioNloTxZmdsnjGzfhjt9Nqtxq/FIDyw7wXRxCbpvOqpNlYkMJxta/0okeD1F7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757623820; c=relaxed/simple;
	bh=J9iyvl1hk5xWpDA/OOYThEaEfUc/5RwSX0fWgd4xsL4=;
	h=Date:To:From:Subject:Message-Id; b=otzVH6UK2ZU6AZczIiX3aQLhicYOPO8tjhWTidtkXJYenng8tQDW0H/Y1mxzlo4zIBRjm9OurJI8V+9iN3+hQ3l5vtCBDiWydfic0dp3DEdjkbwsXc5LOjUFR2IEIBfE1Q1AajqVdWVybiJvoBF4nB6MryGEC4h2DA9IrFYeVEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JkyXZ1KK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JkyXZ1KK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA55C4CEF0;
	Thu, 11 Sep 2025 20:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757623820;
	bh=J9iyvl1hk5xWpDA/OOYThEaEfUc/5RwSX0fWgd4xsL4=;
	h=Date:To:From:Subject:From;
	b=JkyXZ1KKHsk+5Dk9iOLvMKe9HJTwBaQ5E0V/MmD+/gr7E1J9+ySohBCJmzGBhwIHb
	 93AUTcRLeXf732BUL40wrbzZQQvZ+OvwgxenTUrXi0MJTYv4ExET3CR/b77oTL5Vqc
	 QgIFHvXL3HyRReOqgI1AAttYNG4PPYkVgqxzqQ1Q=
Date: Thu, 11 Sep 2025 13:50:19 -0700
To: mm-commits@vger.kernel.org,nicolas.palix@imag.fr,nathan@kernel.org,julia.lawall@inria.fr,krzysztof.kozlowski@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + coccinelle-platform_no_drv_owner-handle-also-built-in-drivers.patch added to mm-nonmm-unstable branch
Message-Id: <20250911205020.1BA55C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: coccinelle: platform_no_drv_owner: handle also built-in drivers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     coccinelle-platform_no_drv_owner-handle-also-built-in-drivers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/coccinelle-platform_no_drv_owner-handle-also-built-in-drivers.patch

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
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: coccinelle: platform_no_drv_owner: handle also built-in drivers
Date: Thu, 11 Sep 2025 20:47:27 +0200

builtin_platform_driver() and others also use macro
platform_driver_register() which sets the .owner=THIS_MODULE, so extend
the cocci script to detect these as well.

Link: https://lkml.kernel.org/r/20250911184726.23154-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/api/platform_no_drv_owner.cocci |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/scripts/coccinelle/api/platform_no_drv_owner.cocci~coccinelle-platform_no_drv_owner-handle-also-built-in-drivers
+++ a/scripts/coccinelle/api/platform_no_drv_owner.cocci
@@ -10,12 +10,21 @@ virtual org
 virtual report
 
 @match1@
+declarer name builtin_i2c_driver;
+declarer name builtin_platform_driver;
+declarer name builtin_platform_driver_probe;
 declarer name module_i2c_driver;
 declarer name module_platform_driver;
 declarer name module_platform_driver_probe;
 identifier __driver;
 @@
 (
+	builtin_i2c_driver(__driver);
+|
+	builtin_platform_driver(__driver);
+|
+	builtin_platform_driver_probe(__driver, ...);
+|
 	module_i2c_driver(__driver);
 |
 	module_platform_driver(__driver);
_

Patches currently in -mm which might be from krzysztof.kozlowski@linaro.org are

coccinelle-of_table-handle-spi-device-id-tables.patch
coccinelle-platform_no_drv_owner-handle-also-built-in-drivers.patch

