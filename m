Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B94C1A08CA
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011143; cv=none; b=Tlb6IGZpSUIh0ckiv4D1Ya39A6JMqoL0iDlzoYOKxyHe8UCV/ZC3WnOlopP2i7Cmx2uBlW5UbbryUWBFGp5JAK55ya9KOlWuVVGkrrygYKOIqkgARW4koendjkOJVsNNwxgHH6Kze8830uv7FfYZKHFGRMBo6VsmplVbTnL/Ve0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011143; c=relaxed/simple;
	bh=DOo7VCJBnXNecxt3jIpaiv+J/xusi/j8vGGzxGFIGek=;
	h=Date:To:From:Subject:Message-Id; b=juJvzHYb/mHyienghGkb4SFkam5YsH+FTZ/I1A4DOVxy5qIGZfBkf+Vw/jiUietSwi7lZJ/+cYK3R3ZAsCNqdp15pmwS2/yrtedZm0Ze5Xgl0MP2r9VcsFQ0cULXCpWV1d1QKQOOl79ekkPBAYidbYf0OXUNBkYCREfZ9SoGkfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ghEYHsIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ghEYHsIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F2EC4CEE4;
	Mon, 12 May 2025 00:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011143;
	bh=DOo7VCJBnXNecxt3jIpaiv+J/xusi/j8vGGzxGFIGek=;
	h=Date:To:From:Subject:From;
	b=ghEYHsISgWuamIC1EMEN4z9B58m1XXGJ15n/CKWvT6g6/i0+IJxXtRT8cSaho1MUt
	 VQ1J/X3Q8vxNKXyL2qT5Y6zrijlhbLJWNnoRqsa6H283gtLRzz+Xf+Bmj625jRsUHb
	 l4FVbBhPPLV9X68jthH8RsCy+i+cVW/02bQfW2YQ=
Date: Sun, 11 May 2025 17:52:22 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,kawasin@google.com,corbet@lwn.net,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-zram-update-idle-pages-tracking-documentation.patch removed from -mm tree
Message-Id: <20250512005223.30F2EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: zram: update IDLE pages tracking documentation
has been removed from the -mm tree.  Its filename was
     documentation-zram-update-idle-pages-tracking-documentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


