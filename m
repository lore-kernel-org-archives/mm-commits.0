Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D19214535D
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293210; cv=none; b=Z8X2AMLAveUV7Q3UZrayB4mN5Yr+dA+t9BFCq4VHNEEJnQBIAefaNMYGvo8d0QJaccvB0PNajPV9/mz1OnyH0yjZdLn2ovRQ23FpfDBAAuWLbuLy03J5HtuRxAp1/4XKtsoRNEVpMWeKKJRYkbSkfbQltOYtNQG/spew5rmVGKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293210; c=relaxed/simple;
	bh=Q0gCIH88V2ZM/BVMBHu88LZkGfB+uWb6soTQbr5b218=;
	h=Date:To:From:Subject:Message-Id; b=aKFOa2aT7UBjQd5pn5YOKtrJxRz6wvjP/M1U7afLY7fkmIJEe027SQR8td44rvGEp2HE0r66ypnfkNrC0m8qCcgrl0x0YV/rVx5IP68o3ypFqcUHtSaojytfusCapGihyYg/4auPN78oXFT5qwSAaGaTDcAQt0Nj2DaD8kg3VzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rK7+IOmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rK7+IOmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E30C32789;
	Tue, 25 Jun 2024 05:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293210;
	bh=Q0gCIH88V2ZM/BVMBHu88LZkGfB+uWb6soTQbr5b218=;
	h=Date:To:From:Subject:From;
	b=rK7+IOmw3Mev86poPZnV1/x3WDfahFqEg9Ttnd9nv7JTISv/dxUMQmbDiztY2LmPS
	 ceX6npE9FL7pLENk1aUBR/F2RQ0BjnT8atkdDImNf3QXhSWnfK5nhOZKus8t0mJkCN
	 FLJBRpdeMm0K+9FfmCn2asbIiAI9Bzb/iYcEKgxs=
Date: Mon, 24 Jun 2024 22:26:49 -0700
To: mm-commits@vger.kernel.org,javierm@redhat.com,bmasney@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-kconfigdebug-document-panic=-command-line-option-and-procfs-entry-for-panic_timeout.patch removed from -mm tree
Message-Id: <20240625052650.44E30C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/Kconfig.debug: document panic= command line option and procfs entry for PANIC_TIMEOUT
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-document-panic=-command-line-option-and-procfs-entry-for-panic_timeout.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brian Masney <bmasney@redhat.com>
Subject: lib/Kconfig.debug: document panic= command line option and procfs entry for PANIC_TIMEOUT
Date: Fri, 7 Jun 2024 11:24:43 -0400

PANIC_TIMEOUT can also be controlled with the panic= kernel command line
option and the file /proc/sys/kernel/panic.  Let's document both of these
in the Kconfig help text.

Link: https://lkml.kernel.org/r/20240607152443.925168-1-bmasney@redhat.com
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-document-panic=-command-line-option-and-procfs-entry-for-panic_timeout
+++ a/lib/Kconfig.debug
@@ -1043,7 +1043,9 @@ config PANIC_TIMEOUT
 	  Set the timeout value (in seconds) until a reboot occurs when
 	  the kernel panics. If n = 0, then we wait forever. A timeout
 	  value n > 0 will wait n seconds before rebooting, while a timeout
-	  value n < 0 will reboot immediately.
+	  value n < 0 will reboot immediately. This setting can be overridden
+	  with the kernel command line option panic=, and from userspace via
+	  /proc/sys/kernel/panic.
 
 config LOCKUP_DETECTOR
 	bool
_

Patches currently in -mm which might be from bmasney@redhat.com are


