Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073A2252910
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597089; cv=none; b=lw68hKoK9gMUSlDxH5xHohLOmAHHb77oXwlkLXZpKWEritQcTi0jSk7HFAR48UONHA4Df7m+L4bEFj/t8gdNTDU79IV0NmfuG2+dfv72+vtKHz6dClva+B2TFcElU2XfNVaTz/GIe6FLqZqtgnAWAMy1VdTSaJMtE+M+m6HsOw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597089; c=relaxed/simple;
	bh=nT+GCYzkhXAK0MNyB7mf8FgAGSu6gI71OtuuFrPHkFA=;
	h=Date:To:From:Subject:Message-Id; b=JyUiE1XJuqYDfUl/Q5Bi04sguwRvxhcuHvU/Fr6K5Eo+rfWoSZrGTi6DcqVM7Wred4Gj3k2D8XAl3+z4L8uDu0IMzwZgdTk+mucHCaO481rUKKVvp19hgkO+wYFwqjTQSqiEPFIUCT4tKUg7oopo8dw46+ey5R6e5iAU2qx7TmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n0QmFC8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n0QmFC8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBB6C113D0;
	Tue, 23 Sep 2025 03:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597088;
	bh=nT+GCYzkhXAK0MNyB7mf8FgAGSu6gI71OtuuFrPHkFA=;
	h=Date:To:From:Subject:From;
	b=n0QmFC8sLY26gitckuD0QzPoJRYVx3suyNdd7Om/PptIcemE7SlH8TrJ+DKoIF2s1
	 XPmMOnvqL5FJvdC0G545cqD4K56LiTuj3mcpAgpLi4sS49fZ9QmEFC4eVlrYUwV4ni
	 f9WDL+7V/hS/hJ+njA12IQJtz/S0KgDmEz+QIcTg=
Date: Mon, 22 Sep 2025 20:11:28 -0700
To: mm-commits@vger.kernel.org,nicolas.palix@imag.fr,nathan@kernel.org,julia.lawall@inria.fr,krzysztof.kozlowski@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] coccinelle-platform_no_drv_owner-handle-also-built-in-drivers.patch removed from -mm tree
Message-Id: <20250923031128.7EBB6C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: coccinelle: platform_no_drv_owner: handle also built-in drivers
has been removed from the -mm tree.  Its filename was
     coccinelle-platform_no_drv_owner-handle-also-built-in-drivers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


