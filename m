Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333F52DBF78
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280964; cv=none; b=mga2rt4G6nbsU6uZ/1ocjDb+aKSlByARiCgtx0WEHax5FVKDpXx0Dl6me1aVhbNQ1den1XocmPNohzLCLPou/ZACvP4wn4GF/QrfOn0RbOOQPpXxYQlgJ4Pyh1OkS1Fbma8KAvp4zZ9W3283B9ae28wl7RRza9vB+YNHkqxjksc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280964; c=relaxed/simple;
	bh=xWy9lnpAB32ZjesTaVrDJgAzX3aiYyHmThPPhqzp88s=;
	h=Date:To:From:Subject:Message-Id; b=ils8Jw9g38nmCfOpzf++CTAw9QjIxZkPnKLTbmsdn8RX1kIKQXQkTvmWTnF60uVmX+DYgKPzbHhsXBdrQBljBdWM2wcmvORD585qzp9Zv1SsDj706Nkm2MMAX5AXd1fxKIiJroXifJzGmiX34NI1WI5mISbBfXYSF122X/p+Yso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nyA5+hLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nyA5+hLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0927BC116C6;
	Tue, 13 Jan 2026 05:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280964;
	bh=xWy9lnpAB32ZjesTaVrDJgAzX3aiYyHmThPPhqzp88s=;
	h=Date:To:From:Subject:From;
	b=nyA5+hLbUw/9LPewvLmJ2L/XHstWd7rdyE4lYVI19xr81N/9mPYSngKYjEaBWwgSH
	 kD978PO/aYLIypIz28WbvAd9X2m6AvcyJ4GV1peyyr33BLE8DCtIqubI+c/jHiYbkW
	 z+Id7mZfvjBj1zJtdMpeiLPZMRFptNihZzWb+Mlw=
Date: Mon, 12 Jan 2026 21:09:23 -0800
To: mm-commits@vger.kernel.org,glider@google.com,dvyukov@google.com,corbet@lwn.net,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-kernel-parameters-add-kfence-parameters.patch removed from -mm tree
Message-Id: <20260113050924.0927BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: kernel-parameters: add kfence parameters
has been removed from the -mm tree.  Its filename was
     docs-kernel-parameters-add-kfence-parameters.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: docs: kernel-parameters: add kfence parameters
Date: Mon, 22 Dec 2025 16:00:06 +0100

Add a brief summary for KFENCE's kernel command-line parameters in
admin-guide/kernel-parameters.

Link: https://lkml.kernel.org/r/20251222150018.1349672-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   35 ++++++++++++++
 1 file changed, 35 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~docs-kernel-parameters-add-kfence-parameters
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2917,6 +2917,41 @@ Kernel parameters
 			for Movable pages.  "nn[KMGTPE]", "nn%", and "mirror"
 			are exclusive, so you cannot specify multiple forms.
 
+	kfence.burst=	[MM,KFENCE] The number of additional successive
+			allocations to be attempted through KFENCE for each
+			sample interval.
+			Format: <unsigned integer>
+			Default: 0
+
+	kfence.check_on_panic=
+			[MM,KFENCE] Whether to check all KFENCE-managed objects'
+			canaries on panic.
+			Format: <bool>
+			Default: false
+
+	kfence.deferrable=
+			[MM,KFENCE] Whether to use a deferrable timer to trigger
+			allocations. This avoids forcing CPU wake-ups if the
+			system is idle, at the risk of a less predictable
+			sample interval.
+			Format: <bool>
+			Default: CONFIG_KFENCE_DEFERRABLE
+
+	kfence.sample_interval=
+			[MM,KFENCE] KFENCE's sample interval in milliseconds.
+			Format: <unsigned integer>
+			 0 - Disable KFENCE.
+			>0 - Enabled KFENCE with given sample interval.
+			Default: CONFIG_KFENCE_SAMPLE_INTERVAL
+
+	kfence.skip_covered_thresh=
+			[MM,KFENCE] If pool utilization reaches this threshold
+			(pool usage%), KFENCE limits currently covered
+			allocations of the same source from further filling
+			up the pool.
+			Format: <unsigned integer>
+			Default: 75
+
 	kgdbdbgp=	[KGDB,HW,EARLY] kgdb over EHCI usb debug port.
 			Format: <Controller#>[,poll interval]
 			The controller # is the number of the ehci usb debug
_

Patches currently in -mm which might be from elver@google.com are


