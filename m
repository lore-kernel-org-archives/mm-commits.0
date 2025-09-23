Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0392512DE
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597088; cv=none; b=asyoFXBTo6bNUOmeNi08umqh4lINdxLi4ftX6bazHZ9ExiDld+JzxLk4FKPaobNhDg9a2GlEeh8DBj1M7uHW0XeeVirNnLzNu2JwNj8URm+B8uwti3dcpTBTuj5I6uGXlM0JFaAtez6PgIj2K8IR/KYR4uN0OYWob2jFXKn/00I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597088; c=relaxed/simple;
	bh=6R3WxvpUj8i6hPGbM/IzIC4CUifAzyWoWX/j7S67HzI=;
	h=Date:To:From:Subject:Message-Id; b=l46yICGWbLThnoofUHmzJJwi1rppgw7fP5/pBybsFcCPCAL7hfDxcqDIe3yMysbwZTk39d1zi+knZ3i0a7bVR054hvkzljNrMTaT7JEhiLkUuYRAIheYGNTXzXpNxIWfaMPnORfff9G71yoGQwuO9w11QjBu3uOSBFm6b0T0E14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N9OKWG7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N9OKWG7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55213C19421;
	Tue, 23 Sep 2025 03:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597087;
	bh=6R3WxvpUj8i6hPGbM/IzIC4CUifAzyWoWX/j7S67HzI=;
	h=Date:To:From:Subject:From;
	b=N9OKWG7ehQLabnbIwLjvTQ7M0cRCn8w6Alm2KunNqxInwUxqIJliMWMKrbVfb5G4x
	 qOxncAs9j5elheNoCJ8eS1b2xTHnXBu+Uoy565EAiyZLsnSaDMQYwKaDcaEiIqgzm9
	 QNMB6I4nYBpGL+XgyKLsksyoJbPczzSZzP6E1IBY=
Date: Mon, 22 Sep 2025 20:11:26 -0700
To: mm-commits@vger.kernel.org,nicolas.palix@imag.fr,nathan@kernel.org,julia.lawall@inria.fr,krzysztof.kozlowski@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] coccinelle-of_table-handle-spi-device-id-tables.patch removed from -mm tree
Message-Id: <20250923031127.55213C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: coccinelle: of_table: handle SPI device ID tables
has been removed from the -mm tree.  Its filename was
     coccinelle-of_table-handle-spi-device-id-tables.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


