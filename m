Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E662939E9C8
	for <mm-commits@vger.kernel.org>; Wed, 17 Jun 2026 22:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781735903; cv=none; b=aUT+Ylsfg6TRy1cFwUpYoTt1RDSWRhZjVYtEyUuXgS77QvnpKiiLkPXXmIJsluUbV3TPhIVfZpy61d0qRIJCaro9g+Y8ljQIwkRNou9nVo9AGuPM/EUx9w/uxzzOQqKSCwwMnyQ/A6rQwYw0mrhKJ+BCphSClVbw2zibWvOgZf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781735903; c=relaxed/simple;
	bh=Pt00gh6ctpi+NwtAOQTJMu2ZA83FZ7OyCDG3xART3Vk=;
	h=Date:To:From:Subject:Message-Id; b=fnxmUUewxu+13UnfKxY1SdN6x8RmrLb3AyfkIfr7T8fp/nvVpsRIrTRrFxTERcVkLmjuqbQl1g0Wm7iRKsIH/Vr9s/q28e7mbhPbazziJHmg1B+IIfjuhhRVPTLuvpSxBPnwBMqAbEuBMrJu3DFoyC55ERU5QHC0Sygw7Leb0EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q4g+KB3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q4g+KB3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF511F000E9;
	Wed, 17 Jun 2026 22:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781735902;
	bh=oNZ0z9BTxi6Rj1guvwtvLlfA9oTXF5/GsudJ0ecU5d4=;
	h=Date:To:From:Subject;
	b=q4g+KB3ABWbrznjUmiEgXuARCyo7mOSyqCY/p5mr3fgHe3Oxr/UcV+NMvDmWfWMN7
	 C/5mplRjRMS+PWIv2BOXPDpm8SRGF3Riu5LsIC55PsTzEHE/DH7W1u6MZlIl/glopI
	 15FPBNEzhWGlDTs8LijFDy7kJbuI/ce5+AR9xovo=
Date: Wed, 17 Jun 2026 15:38:22 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,brauner@kernel.org,kanie@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-uevent-increase-__uevent_buffer_size-to-avoid-enobufs-on-busy-systems.patch removed from -mm tree
Message-Id: <20260617223822.9CF511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/uevent: increase __UEVENT_BUFFER_SIZE to avoid ENOBUFS on busy systems
has been removed from the -mm tree.  Its filename was
     selftests-uevent-increase-__uevent_buffer_size-to-avoid-enobufs-on-busy-systems.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


