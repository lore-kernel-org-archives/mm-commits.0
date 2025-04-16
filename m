Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A21B1C3C1C
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 23:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744847424; cv=none; b=Y7bObWI9QxFiWvQ6kRb6zJZaiNjkSnzXK572DE/QQpeNssBeCFvweNRmWm0tc7VL0NQq51WFEjbvbq19D0fJb5BvnVnrhA66RuHKvoi2z/v7tcnWZ9YHlrvLeCAxkiIiH9XZWb6SeN9IYuOqXHFFzHIucvphocrS/ZEm9rgq9gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744847424; c=relaxed/simple;
	bh=fQkdNVxjhr/sVabhFFMSnQoyEEkcafNUK/DDVza3GbE=;
	h=Date:To:From:Subject:Message-Id; b=Hsmj7XJDPAHNk3e6xtWJdM56oc5hz7CH2dog0gj1J86QgGZAHsbQdkFweCZmPV2PS1TJuYX4JU1Tang2USJKMxdGk3pGT9CYNovujH1f2/FG/be427RsqklLbugIBBla+cyEdxiD/SK41AzsTao3x+2j6ept+B8pDZkxaWKdSR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cmZs9Ebe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cmZs9Ebe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB4BC4CEE2;
	Wed, 16 Apr 2025 23:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744847423;
	bh=fQkdNVxjhr/sVabhFFMSnQoyEEkcafNUK/DDVza3GbE=;
	h=Date:To:From:Subject:From;
	b=cmZs9EbekEgC2fFn2SjtzKi/tK1mFiMfgi7ANPjgNhwYgkaxfpK9uInpghOFQrPQf
	 vkFTOYwk/DLZYgr/tZXYIMqMxNrZjH3pVeAQsqo1fYvCNzipZ0XUUmhZUgChIOMHn0
	 zy7xU18dVMoD+jBH74zSB9oqHy38b+mDRe6g5Pvs=
Date: Wed, 16 Apr 2025 16:50:23 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,kawasin@google.com,corbet@lwn.net,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-zram-update-idle-pages-tracking-documentation.patch added to mm-new branch
Message-Id: <20250416235023.BBB4BC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: zram: update IDLE pages tracking documentation
has been added to the -mm mm-new branch.  Its filename is
     documentation-zram-update-idle-pages-tracking-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-zram-update-idle-pages-tracking-documentation.patch

This patch will later appear in the mm-new branch at
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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Documentation: zram: update IDLE pages tracking documentation
Date: Wed, 16 Apr 2025 13:27:59 +0900

Move IDLE pages tracking into a separate chapter because there are
multiple features that use (or depend on) it either in built-in variant
("mark all") or in extended variant (ac-time tracking).

In addition, recompression doesn't require memory tracking to be enabled
in order to be able to perform idle recompression.

Link: https://lkml.kernel.org/r/20250416042833.3858827-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Shin Kawamura <kawasin@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   41 +++++++++---------
 1 file changed, 21 insertions(+), 20 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-zram-update-idle-pages-tracking-documentation
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -317,6 +317,26 @@ a single line of text and contains the f
 Optional Feature
 ================
 
+IDLE pages tracking
+-------------------
+
+zram has built-in support for idle pages tracking (that is, allocated but
+not used pages). This feature is useful for e.g. zram writeback and
+recompression. In order to mark pages as idle, execute the following command::
+
+	echo all > /sys/block/zramX/idle
+
+This will mark all allocated zram pages as idle. The idle mark will be
+removed only when the page (block) is accessed (e.g. overwritten or freed).
+Additionally, when CONFIG_ZRAM_TRACK_ENTRY_ACTIME is enabled, pages can be
+marked as idle based on how many seconds have passed since the last access to
+a particular zram page::
+
+	echo 86400 > /sys/block/zramX/idle
+
+In this example, all pages which haven't been accessed in more than 86400
+seconds (one day) will be marked idle.
+
 writeback
 ---------
 
@@ -331,24 +351,7 @@ If admin wants to use incompressible pag
 
 	echo huge > /sys/block/zramX/writeback
 
-To use idle page writeback, first, user need to declare zram pages
-as idle::
-
-	echo all > /sys/block/zramX/idle
-
-From now on, any pages on zram are idle pages. The idle mark
-will be removed until someone requests access of the block.
-IOW, unless there is access request, those pages are still idle pages.
-Additionally, when CONFIG_ZRAM_TRACK_ENTRY_ACTIME is enabled pages can be
-marked as idle based on how long (in seconds) it's been since they were
-last accessed::
-
-        echo 86400 > /sys/block/zramX/idle
-
-In this example all pages which haven't been accessed in more than 86400
-seconds (one day) will be marked idle.
-
-Admin can request writeback of those idle pages at right timing via::
+Admin can request writeback of idle pages at right timing via::
 
 	echo idle > /sys/block/zramX/writeback
 
@@ -499,8 +502,6 @@ attempt to recompress:::
 
 	echo "type=huge_idle max_pages=42" > /sys/block/zramX/recompress
 
-Recompression of idle pages requires memory tracking.
-
 During re-compression for every page, that matches re-compression criteria,
 ZRAM iterates the list of registered alternative compression algorithms in
 order of their priorities. ZRAM stops either when re-compression was
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch
zram-modernize-writeback-interface.patch
zram-modernize-writeback-interface-v3.patch
zram-modernize-writeback-interface-v4.patch
zsmalloc-cleanup-headers-includes.patch
documentation-zram-update-idle-pages-tracking-documentation.patch

