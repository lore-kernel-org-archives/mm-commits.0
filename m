Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEFB217916
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017731; cv=none; b=ohiTUKUHgXrxSvo18rQpbg+mEX4wwFVaY7KZcW7ZpG3mmb+Fi/tnh+mMwPBBM3icBZwoxdnxBMJFscrrxvZn73hzSBY62948+qtMyZO+8JEM2dYc1BOTq4dyDjvGVrZCanaONItvDN+LTS/yUUXIbpOiV1EyDbVUstYtDbmty9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017731; c=relaxed/simple;
	bh=/kHQdqp0ILjXQT9mj670Fe1M3crTrE/xibVTrOaFLd8=;
	h=Date:To:From:Subject:Message-Id; b=KwtCMILptibGJqMd/0AtiVlu1EvsuHIPD9shSU3dbiV757ACQBwoABgAAEJGzvXst9bDXkl9QQtAzHwqies9AW4psrExrKMlzzAc1jB1//fpw8zp+87xy04VZ9epl2uzkk2qV/2WpXY6nf54BrdngFAgFtqkP7d/VGGc611vcB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aNEWA3rH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aNEWA3rH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF31C4CECC;
	Thu,  7 Nov 2024 22:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017730;
	bh=/kHQdqp0ILjXQT9mj670Fe1M3crTrE/xibVTrOaFLd8=;
	h=Date:To:From:Subject:From;
	b=aNEWA3rHpNm6UypEdlZYmmmvqA3apQVoQtj6+cFJjHNrVHG76VOW1EM+wKaNTsR9K
	 Dc/U5kIen+1PbmN4psNypZaLViqBKl7tpkEmN4GaKYKbkPHxEich9JpXTu3Rbplu+7
	 P3zOsRVGA17nZKZ7LFRpGcIZApkxiDNx0VjqQIBA=
Date: Thu, 07 Nov 2024 14:15:30 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,mcanal@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-docs-for-the-kernel-parameter-thp_anon=.patch removed from -mm tree
Message-Id: <20241107221530.DBF31C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix docs for the kernel parameter ``thp_anon=``
has been removed from the -mm tree.  Its filename was
     mm-fix-docs-for-the-kernel-parameter-thp_anon=.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maíra Canal <mcanal@igalia.com>
Subject: mm: fix docs for the kernel parameter ``thp_anon=``
Date: Fri, 1 Nov 2024 13:54:05 -0300

If we add ``thp_anon=32,64K:always`` to the kernel command line, we
will see the following error:

[    0.000000] huge_memory: thp_anon=32,64K:always: error parsing string, ignoring setting

This happens because the correct format isn't ``thp_anon=<size>,<size>[KMG]:<state>```,
as [KMG] must follow each number to especify its unit. So, the correct
format is ``thp_anon=<size>[KMG],<size>[KMG]:<state>```.

Therefore, adjust the documentation to reflect the correct format of the
parameter ``thp_anon=``.

Link: https://lkml.kernel.org/r/20241101165719.1074234-3-mcanal@igalia.com
Fixes: dd4d30d1cdbe ("mm: override mTHP "enabled" defaults at kernel cmdline")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 Documentation/admin-guide/mm/transhuge.rst      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-fix-docs-for-the-kernel-parameter-thp_anon=
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -6688,7 +6688,7 @@
 			0: no polling (default)
 
 	thp_anon=	[KNL]
-			Format: <size>,<size>[KMG]:<state>;<size>-<size>[KMG]:<state>
+			Format: <size>[KMG],<size>[KMG]:<state>;<size>[KMG]-<size>[KMG]:<state>
 			state is one of "always", "madvise", "never" or "inherit".
 			Control the default behavior of the system with respect
 			to anonymous transparent hugepages.
--- a/Documentation/admin-guide/mm/transhuge.rst~mm-fix-docs-for-the-kernel-parameter-thp_anon=
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -303,7 +303,7 @@ control by passing the parameter ``trans
 kernel command line.
 
 Alternatively, each supported anonymous THP size can be controlled by
-passing ``thp_anon=<size>,<size>[KMG]:<state>;<size>-<size>[KMG]:<state>``,
+passing ``thp_anon=<size>[KMG],<size>[KMG]:<state>;<size>[KMG]-<size>[KMG]:<state>``,
 where ``<size>`` is the THP size (must be a power of 2 of PAGE_SIZE and
 supported anonymous THP)  and ``<state>`` is one of ``always``, ``madvise``,
 ``never`` or ``inherit``.
_

Patches currently in -mm which might be from mcanal@igalia.com are

mm-shmem-control-thp-support-through-the-kernel-command-line.patch
mm-move-get_order_from_str-to-internalh.patch
mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter.patch
mm-huge_memory-use-strscpy-instead-of-strcpy.patch

