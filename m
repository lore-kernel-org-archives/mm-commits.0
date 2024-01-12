Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB0418EA9
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 23:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YysGP2Dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7764DC43399;
	Fri, 12 Jan 2024 23:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101701;
	bh=2Uunil58rypCOcGWbdauOcFiH8Rz1tr/IzpMu8xkBA8=;
	h=Date:To:From:Subject:From;
	b=YysGP2Dlacz26myydmI2OXRoyjHKjRblvM7kbsIZOC3kCqsZwkxI0asHs6ZZZG35Z
	 1h+WllMOBb2S+ye/xslnFLOWXnDauvdNkw45z5LKrl+hDlJzmdpWMH8F4WbcVA/jEK
	 wd3ZNN+xwnhvRq7t3YehRvVU58lCi6QR+Z2wA6a4=
Date: Fri, 12 Jan 2024 15:21:40 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kernel-crash_corec-make-__crash_hotplug_lock-static.patch removed from -mm tree
Message-Id: <20240112232141.7764DC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/crash_core.c: make __crash_hotplug_lock static
has been removed from the -mm tree.  Its filename was
     kernel-crash_corec-make-__crash_hotplug_lock-static.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/crash_core.c: make __crash_hotplug_lock static
Date: Tue Jan  9 09:35:21 PM PST 2024

sparse warnings:
kernel/crash_core.c:749:1: sparse: sparse: symbol '__crash_hotplug_lock' was not declared. Should it be static?

Fixes: e2a8f20dd8e9 ("Crash: add lock to serialize crash hotplug handling")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401080654.IjjU5oK7-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/crash_core.c~kernel-crash_corec-make-__crash_hotplug_lock-static
+++ a/kernel/crash_core.c
@@ -877,7 +877,7 @@ subsys_initcall(crash_notes_memory_init)
  * regions are online. So mutex lock  __crash_hotplug_lock is used to
  * serialize the crash hotplug handling specifically.
  */
-DEFINE_MUTEX(__crash_hotplug_lock);
+static DEFINE_MUTEX(__crash_hotplug_lock);
 #define crash_hotplug_lock() mutex_lock(&__crash_hotplug_lock)
 #define crash_hotplug_unlock() mutex_unlock(&__crash_hotplug_lock)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


