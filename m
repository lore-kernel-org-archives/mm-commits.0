Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9990A1CDA1E
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 18:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730485741; cv=none; b=JuGkcbG97EQfWUdSHchl8Hl8dKIkkbtOsR4PRfsvVl2Xo8NBOnwcOpHwL81BWuFaeaIAgM9ZM82tRBLAsleLcYln0LM0DWpd3XuF2TPAO75TXWPH+z6scksFw8ARfSLMpSkn2Y/MBZn91QkQPVApDnssmPd4O4DFZBNUxkIV2Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730485741; c=relaxed/simple;
	bh=5nJCXHPwRMK7blXPlI0Zxlkt5TWSvv/XobeKwozgv8g=;
	h=Date:To:From:Subject:Message-Id; b=sGd5o0FYup2AVaU+iJtq0PtPNUtaY9FZI7FzmlQCAoV7tRnxIkrawomGaVuMLxjX0OWLj5MbRsY/xttT6zWAaOl5XvL9lcZj1y/fQdv8tv55xOX0eAwwlmL2Tg+HSlHRB7iAJlq5/a+Txwj5VD3DE8SWrxxTtkXF+Sh1jtpHHwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hdDNBHum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hdDNBHum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A22FC4CECD;
	Fri,  1 Nov 2024 18:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730485741;
	bh=5nJCXHPwRMK7blXPlI0Zxlkt5TWSvv/XobeKwozgv8g=;
	h=Date:To:From:Subject:From;
	b=hdDNBHumgqjwjVxyZTLxPDPfBF4SDYilJ5jlpQIXo77NHHjUnGfoNaCRmrT3zAA28
	 aWSfBPRWOxEEnzG9CLVgigUDePasSkAQJcO6hjtbDfMKpSm+7Ww2Yi0Dwzj+QFf7op
	 LM1S0ihU7zKmKPuztq1LK+g4JkCCMXzTCWFfkOzU=
Date: Fri, 01 Nov 2024 11:29:00 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,mcanal@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-docs-for-the-kernel-parameter-thp_anon=.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101182901.1A22FC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix docs for the kernel parameter ``thp_anon=``
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-docs-for-the-kernel-parameter-thp_anon=.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-docs-for-the-kernel-parameter-thp_anon=.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-fix-docs-for-the-kernel-parameter-thp_anon=.patch
mm-shmem-control-thp-support-through-the-kernel-command-line.patch
mm-move-get_order_from_str-to-internalh.patch
mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter.patch
mm-huge_memory-use-strscpy-instead-of-strcpy.patch

