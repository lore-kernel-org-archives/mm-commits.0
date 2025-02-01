Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65DC199932
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410863; cv=none; b=tWsU92BxaAz7ViGVWFjKDRGVKCRXjL1zkr8MJPJCL7HOG4gWhiShJeTyHp/V6XtdqprcF5HD1mfqoDKZZ5TSbPmQtsn+GrzThk6ePhhC91P6Q56N0HnWth+57MhczFS6qau1JPFmsAv/fCIc/KnRFaDwz5o5Ptz/UAVvfGbMf3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410863; c=relaxed/simple;
	bh=Yp2Txhz08YK4gC/QwfV7K18xmrCnp8B81WJGVR7RC0g=;
	h=Date:To:From:Subject:Message-Id; b=Xt2dNemPXJrz7l2L2LOStm8yb2VB1CrwaAvdvDliZ3Q/RhHkHl7f/T9XxXbgMipsXwFNthWoWR4uvUAKUL/Bfarr8zG1OKgpOmqWjW+FhFbsROyqj0E4qbIpJqacFqRK5BJ3wMiCRlOQVmxcz2rcvhJjv5SM/Cq1VxQlAvHnSVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zif5ofjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zif5ofjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E58C4CED3;
	Sat,  1 Feb 2025 11:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410863;
	bh=Yp2Txhz08YK4gC/QwfV7K18xmrCnp8B81WJGVR7RC0g=;
	h=Date:To:From:Subject:From;
	b=zif5ofjx3kIrH6DUiPqNWTAF5PkKZwuzE/gT5W1xOZTHQR+0im/GDR/QNtAaQXEcz
	 FUKS6s+vbgS3NK+kq4AyNPrOaG4CIgpiKsTEgZA/IYYFYo2vjifREIp78IKY3vK2xX
	 VxmH8p1N4DzurMKUh0SV7O4Nv7Qpvi90VDVfk8oY=
Date: Sat, 01 Feb 2025 03:54:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tamird@gmail.com,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,geert@linux-m68k.org,davidgow@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-include-linux-mm-for-xarray-maintenance.patch removed from -mm tree
Message-Id: <20250201115423.17E58C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: include linux-mm for xarray maintenance
has been removed from the -mm tree.  Its filename was
     maintainers-include-linux-mm-for-xarray-maintenance.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: include linux-mm for xarray maintenance
Date: Thu Jan 30 04:16:20 PM PST 2025

MM developers have an interest in the xarray code.

Cc: David Gow <davidgow@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-include-linux-mm-for-xarray-maintenance
+++ a/MAINTAINERS
@@ -25729,6 +25729,7 @@ F:	arch/x86/entry/vdso/
 XARRAY
 M:	Matthew Wilcox <willy@infradead.org>
 L:	linux-fsdevel@vger.kernel.org
+L:	linux-mm@kvack.org
 S:	Supported
 F:	Documentation/core-api/xarray.rst
 F:	include/linux/idr.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch

