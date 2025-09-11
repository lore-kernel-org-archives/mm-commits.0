Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E54A2D541B
	for <mm-commits@vger.kernel.org>; Thu, 11 Sep 2025 20:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757623819; cv=none; b=mtNrNWOF7WgBTOpKeenaHK24ft5rTGJNG4u6og+xHK6g3Py3rrkNIjA7AR5DbRRBdI1o23n7u6RWu981JegIxR7pTs7BHNP33WdGge63vBGOuubuQsHRHc0C/s5JE5XoS+WTkvVigusk8oqk5G2Izd3Mty5ybbJrs5OUFc6j0as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757623819; c=relaxed/simple;
	bh=g9fXv7EWzCeZxGnH0kLCpnhls6hcO74ScMij8yxPftQ=;
	h=Date:To:From:Subject:Message-Id; b=hSQi2uxMuOigUcYopIhScdDVuXf/NRLQFh/+o3oM9Z4UFoRfjLEaW4MFOQ2MpB0hc5vxo/U0uot7ckSUT/4rPrBhX3oMNuynxNsvgoPLeK4+ooAe9U0/leIrmHwrFrHqLgQDKnRD9P/QJo4Ac4+F52wt0BOae98wk5XWCTTAm+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xN2HITSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xN2HITSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B12C4CEF0;
	Thu, 11 Sep 2025 20:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757623818;
	bh=g9fXv7EWzCeZxGnH0kLCpnhls6hcO74ScMij8yxPftQ=;
	h=Date:To:From:Subject:From;
	b=xN2HITStiQJUq5+IZjURoaNht0xMY2NMcaBy9aahUipsgexe+0GPhfjehNqCLPlI3
	 D9mR87luTmtIj3hvrJKI9Ke9XiDIHJL3XoYxotvr8pA/xeyIFnrwM/KJcNs1/X8m8U
	 W/xHZibbWUMXUkovT4zKSCy13QuRfNhmkwjf344Y=
Date: Thu, 11 Sep 2025 13:50:17 -0700
To: mm-commits@vger.kernel.org,nicolas.palix@imag.fr,nathan@kernel.org,julia.lawall@inria.fr,krzysztof.kozlowski@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + coccinelle-of_table-handle-spi-device-id-tables.patch added to mm-nonmm-unstable branch
Message-Id: <20250911205018.B9B12C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: coccinelle: of_table: handle SPI device ID tables
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     coccinelle-of_table-handle-spi-device-id-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/coccinelle-of_table-handle-spi-device-id-tables.patch

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
Subject: coccinelle: of_table: handle SPI device ID tables
Date: Thu, 11 Sep 2025 21:33:55 +0200

'struct spi_device_id' tables also need to be NULL terminated.

Link: https://lkml.kernel.org/r/20250911193354.56262-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/misc/of_table.cocci |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/scripts/coccinelle/misc/of_table.cocci~coccinelle-of_table-handle-spi-device-id-tables
+++ a/scripts/coccinelle/misc/of_table.cocci
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/// Make sure (of/i2c/platform)_device_id tables are NULL terminated
+/// Make sure (of/i2c/platform/spi)_device_id tables are NULL terminated
 //
 // Keywords: of_table i2c_table platform_table
 // Confidence: Medium
@@ -15,14 +15,14 @@ identifier var, arr;
 expression E;
 @@
 (
-struct \(of_device_id \| i2c_device_id \| platform_device_id\) arr[] = {
+struct \(of_device_id \| i2c_device_id \| platform_device_id \| spi_device_id\) arr[] = {
 	...,
 	{
 	.var = E,
 *	}
 };
 |
-struct \(of_device_id \| i2c_device_id \| platform_device_id\) arr[] = {
+struct \(of_device_id \| i2c_device_id \| platform_device_id \| spi_device_id\) arr[] = {
 	...,
 *	{ ..., E, ... },
 };
@@ -33,7 +33,7 @@ identifier var, arr;
 expression E;
 @@
 (
-struct \(of_device_id \| i2c_device_id \| platform_device_id\) arr[] = {
+struct \(of_device_id \| i2c_device_id \| platform_device_id \| spi_device_id\) arr[] = {
 	...,
 	{
 	.var = E,
@@ -42,7 +42,7 @@ struct \(of_device_id \| i2c_device_id \
 +	{ }
 };
 |
-struct \(of_device_id \| i2c_device_id \| platform_device_id\) arr[] = {
+struct \(of_device_id \| i2c_device_id \| platform_device_id \| spi_device_id\) arr[] = {
 	...,
 	{ ..., E, ... },
 +	{ },
@@ -55,7 +55,7 @@ identifier var, arr;
 expression E;
 @@
 (
-struct \(of_device_id \| i2c_device_id \| platform_device_id\) arr[] = {
+struct \(of_device_id \| i2c_device_id \| platform_device_id \| spi_device_id\) arr[] = {
 	...,
 	{
 	.var = E,
@@ -63,7 +63,7 @@ struct \(of_device_id \| i2c_device_id \
 	@p1
 };
 |
-struct \(of_device_id \| i2c_device_id \| platform_device_id\) arr[] = {
+struct \(of_device_id \| i2c_device_id \| platform_device_id \| spi_device_id\) arr[] = {
 	...,
 	{ ..., E, ... }
 	@p1
_

Patches currently in -mm which might be from krzysztof.kozlowski@linaro.org are

coccinelle-of_table-handle-spi-device-id-tables.patch
coccinelle-platform_no_drv_owner-handle-also-built-in-drivers.patch

