Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29404266EE9
	for <mm-commits@vger.kernel.org>; Wed, 10 Jun 2026 01:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781055257; cv=none; b=iq31MQIGVgSXdp3og2KCaMvq4183fXqIPTsdgOjeSginnwxxS03do8IZVr3yNxYWA/3F9FMmiPMv5hTsBO3K3HhKLewBmWEfTuOMJKUQ9BdlqAz6ZF8CZkYyFGe8pwnQsN+mYKCVWsei6LNHuCP18KyRAyEwswOMoKJajYWe7UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781055257; c=relaxed/simple;
	bh=PuuvCebhB5g4ZRzXcnIiVGUrXFQHUGN9dn2IuHdPjBQ=;
	h=Date:To:From:Subject:Message-Id; b=Tij2bwp1VPBQlbfVdMaC38pdFS5a/+Bge3sNRdXhIeTL5KMR2AkYYcwQesdk7IqcGQ0rb6iPBqD7ZElBf+xYQQ0UUs5iDnK8OdJRSbdfRDxHrdj+bodpL8WDFFrO8Wcepxqe6S5gplspkOukZb+Jo3pxfP/7k0tZ/pfeFvJY/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wauk6UbX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wauk6UbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB27D1F00893;
	Wed, 10 Jun 2026 01:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781055255;
	bh=HHpDC0oFOAeBWwcE9mxAtPgndsWMyBuQTtD7GzKOFtE=;
	h=Date:To:From:Subject;
	b=Wauk6UbXPgoTHBujFae+gSAChiEqh3tAkjq4OcqXvTP9x/360UlgnesIZql2SoG4s
	 I15L4VSeyISmGSg2/vLZnqTCya46FvHsUPU420BbwFF1mqxgUmQ5rdu6+gcd2RCuQ/
	 c7oDDVWXeShlQIlsMLEaAhHAVzM75wrXtAZhvz/s=
Date: Tue, 09 Jun 2026 18:34:15 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,brauner@kernel.org,kanie@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-uevent-increase-__uevent_buffer_size-to-avoid-enobufs-on-busy-systems.patch added to mm-nonmm-unstable branch
Message-Id: <20260610013415.AB27D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/uevent: increase __UEVENT_BUFFER_SIZE to avoid ENOBUFS on busy systems
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-uevent-increase-__uevent_buffer_size-to-avoid-enobufs-on-busy-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-uevent-increase-__uevent_buffer_size-to-avoid-enobufs-on-busy-systems.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Guixin Liu <kanie@linux.alibaba.com>
Subject: selftests/uevent: increase __UEVENT_BUFFER_SIZE to avoid ENOBUFS on busy systems
Date: Mon, 8 Jun 2026 13:39:34 +0800

The kselftests case uevent.uevent_filtering fails reproducibly on busy
systems (e.g.  Intel EMR / AMD servers) with:

  No buffer space available - Failed to receive uevent

The listener binds the NETLINK_KOBJECT_UEVENT socket to all 32 multicast
groups (nl_groups = -1) but only sets SO_RCVBUF to 4 KiB
(__UEVENT_BUFFER_SIZE = 2048 * 2).  On hosts with many devices, the kernel
and userspace daemons (udev/systemd) constantly emit uevents on multiple
groups, plus the test itself triggers 10 add events in a row.  The 4 KiB
receive buffer overflows before the listener can drain it, recvmsg()
returns -ENOBUFS, and the test bails out as failure.

Increase __UEVENT_BUFFER_SIZE to 1 MiB so the receive buffer is large
enough to absorb the burst of uevents on busy systems.  After this change
the test passes consistently across dozens of runs on Intel EMR and AMD
platforms.

Link: https://lore.kernel.org/20260608053934.4059533-1-kanie@linux.alibaba.com
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/uevent/uevent_filtering.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/uevent/uevent_filtering.c~selftests-uevent-increase-__uevent_buffer_size-to-avoid-enobufs-on-busy-systems
+++ a/tools/testing/selftests/uevent/uevent_filtering.c
@@ -22,7 +22,7 @@
 #include "kselftest_harness.h"
 
 #define __DEV_FULL "/sys/devices/virtual/mem/full/uevent"
-#define __UEVENT_BUFFER_SIZE (2048 * 2)
+#define __UEVENT_BUFFER_SIZE (1024 * 1024)
 #define __UEVENT_HEADER "add@/devices/virtual/mem/full"
 #define __UEVENT_HEADER_LEN sizeof("add@/devices/virtual/mem/full")
 #define __UEVENT_LISTEN_ALL -1
_

Patches currently in -mm which might be from kanie@linux.alibaba.com are

selftests-uevent-increase-__uevent_buffer_size-to-avoid-enobufs-on-busy-systems.patch

