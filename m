Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C13233942
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622850; cv=none; b=re9BpGYZDNmdXD+MvEjG+GX0Y2+LPgKeZQRbOQ6IQq53vFI2SZ6sNAVyeQi/s+3su5ALHqR82hIIY5eRKBrbRHfBdinK/sWYPWjvNnqZsLXKpgXiIJfiXnvaspigOgl3p5rpCQRA0XdVGGpY9CPGBYF9sd79CzL2HNY08SuxfuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622850; c=relaxed/simple;
	bh=7EP+hDzq00K6jvPaCWf2krpKmwXIJnaVlrzzXiHdG/I=;
	h=Date:To:From:Subject:Message-Id; b=OEC2FR2qzvyz0oujHhw+EnucgECFjJ96krlxMMj7FbWMHAJRaz/sQZOEG2KNsU5KoZe/X0HQyATejPs1m/FUIkGmbO0YlYGLfkQFTIUfdbNNA27J3YLTMx5dB/0LlEaQBWm0yBBJKjUhTwGtz+feDBdDKq8BZv621WoPy8RQQIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VZgj4Bri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VZgj4Bri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025501F00A3A;
	Tue, 25 Aug 2026 01:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622845;
	bh=oZ8jZjvFMVsfURmKvobWZYBxhWvwMWBG+NNFKjDfXvQ=;
	h=Date:To:From:Subject;
	b=VZgj4BriMTg1We8lC6CmW0mx7fcTZrqMQB+c3hPCyLUcJipe3aIRZLJ0qV8BG8Cuu
	 HSogM7H1syihHIERrvRQogHgME7kKzQAPm7n/b2XhAb9JUXXOVRr/8Fi4JyLx17xAs
	 jGhkeukpbQgfijJe30l0APfALT2Wy9Mvl75ju0Ps=
Date: Mon, 24 Aug 2026 18:54:04 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,hao.ge@linux.dev,abhishekbapat@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-expose-boot-time-compression-configuration.patch removed from -mm tree
Message-Id: <20260825015405.025501F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: expose boot-time compression configuration
has been removed from the -mm tree.  Its filename was
     alloc_tag-expose-boot-time-compression-configuration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: alloc_tag: expose boot-time compression configuration
Date: Wed, 5 Aug 2026 17:29:52 +0000

Currently, userspace has limited visibility into the exact active runtime
state of memory allocation profiling and its page extension compression
('sysctl.vm.mem_profiling={0|1|never}[,compressed]').

While reading the sysctl provides basic on/off status, it is currently
impossible for userspace to natively determine whether page-tag
compression was successfully enabled without scraping dmesg boot logs.

Add a new read-only sysctl representing how compression was configured
at boot time.

Link: https://lore.kernel.org/c795f8089f82841e8a6e00d7ca286da2b23aeb7b.1785950530.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/allocation-profiling.rst |   11 +++++++++++
 mm/alloc_tag.c                            |    6 ++++++
 2 files changed, 17 insertions(+)

--- a/Documentation/mm/allocation-profiling.rst~alloc_tag-expose-boot-time-compression-configuration
+++ a/Documentation/mm/allocation-profiling.rst
@@ -43,6 +43,17 @@ sysctl:
   warnings produced by allocations made while profiling is disabled and freed
   when it's enabled.
 
+  /proc/sys/vm/mem_profiling_compressed
+
+  1: Page alloc tag compression is enabled.
+
+  0: Page alloc tag compression is disabled.
+
+  This reflects a static boot-time configuration of how page allocation tags are
+  stored (in page flags when compression is enabled and in page_ext when disabled).
+  Toggling ``mem_profiling`` at runtime does not change the state of
+  ``mem_profiling_compressed``.
+
 Runtime info:
   /proc/allocinfo
 
--- a/mm/alloc_tag.c~alloc_tag-expose-boot-time-compression-configuration
+++ a/mm/alloc_tag.c
@@ -961,6 +961,12 @@ static const struct ctl_table memory_all
 		.mode		= 0644,
 		.proc_handler	= proc_mem_profiling_handler,
 	},
+	{
+		.procname	= "mem_profiling_compressed",
+		.data		= &mem_profiling_compressed,
+		.mode		= 0444,
+		.proc_handler	= proc_do_static_key,
+	},
 };
 
 static void __init sysctl_init(void)
_

Patches currently in -mm which might be from abhishekbapat@google.com are


