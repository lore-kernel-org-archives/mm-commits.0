Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6883035C1BB
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967366; cv=none; b=bLIQvfFruH+58K41bQYvE2MQvUoeM/RFWLYb9/UgIYyIFri1KN3fwP+5EZAW0NxXZhMXzaZgGpSd8saK1qcPJTc93fhZmcu5dE8jpzLYgE5UgARke3lD7Ke6ENyaUXHh/VmzM40pa6HVgH9Dx0kE6qBorOrEJPGaFjbGWMb5TsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967366; c=relaxed/simple;
	bh=49d7qKz8o/jiEnWmrVybqK6y3Z40fMsB4rlTu7mHdM0=;
	h=Date:To:From:Subject:Message-Id; b=mbmiN8RQdmD/m0kh9jhXj9UNwzyr0/VTq+JzL054zlWm7V0lIiIMU366AY3aba0GXBfHD7rtj5U6hahmKn+6QrVQSzchhV6OURsuo1x9AfmVDuGDLsxRzEd9qkYclzizOCC6sOis9OAPgif0WahUjiKsSJiLwHKMNsro8I7+1lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FEO1SbWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FEO1SbWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278DFC16AAE;
	Wed, 21 Jan 2026 03:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967366;
	bh=49d7qKz8o/jiEnWmrVybqK6y3Z40fMsB4rlTu7mHdM0=;
	h=Date:To:From:Subject:From;
	b=FEO1SbWF2RnexMkqq+S0XO9zDzeoxBuxN4PgIXkqteQ83l9sVFLuTlf9JmTMWU7Pv
	 r+Tw83AyBS9Lak5PgG1K0+kOI+WIX/u4EJMPj7O2+ap5tcxUofKqdIutXFCOs6miFK
	 MQ+nvTo+5OJU78HaBeXdtqsP+gNNK68nugzMKc9Q=
Date: Tue, 20 Jan 2026 19:49:25 -0800
To: mm-commits@vger.kernel.org,arnd@arndb.de,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-shm-uapi-remove-dependency-on-libc.patch removed from -mm tree
Message-Id: <20260121034926.278DFC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc/shm: uapi: remove dependency on libc
has been removed from the -mm tree.  Its filename was
     ipc-shm-uapi-remove-dependency-on-libc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: ipc/shm: uapi: remove dependency on libc
Date: Mon, 22 Dec 2025 08:55:10 +0100

Using libc types and headers from the UAPI headers is problematic as it
introduces a dependency on a full C toolchain.  shm.h does not even use
any symbols from the libc header as the usage of getpagesize() was removed
a decade ago in commit 060028bac94b ("ipc/shm.c: increase the defaults for
SHMALL, SHMMAX")

Drop the unnecessary inclusion.

Link: https://lkml.kernel.org/r/20251222-uapi-shm-v1-1-270bb7f75d97@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/shm.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/uapi/linux/shm.h~ipc-shm-uapi-remove-dependency-on-libc
+++ a/include/uapi/linux/shm.h
@@ -5,9 +5,6 @@
 #include <linux/ipc.h>
 #include <linux/errno.h>
 #include <asm-generic/hugetlb_encode.h>
-#ifndef __KERNEL__
-#include <unistd.h>
-#endif
 
 /*
  * SHMMNI, SHMMAX and SHMALL are default upper limits which can be
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are


