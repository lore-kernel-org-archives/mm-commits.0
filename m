Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F22185924
	for <mm-commits@vger.kernel.org>; Fri, 15 Nov 2024 06:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653074; cv=none; b=kbeI4SFSiuwNffdNsvVTWcf9ti1Zo5o5o5gJDkE9ByyPIGLUqCAkvpzO6dbU2rnPquor5L2OfogBUKl8+qhgXKfgVC50XYHli9T3EObaA5UPUQ7YwqoFBy2wn2bSTNB30OlTwtgTwErUVMEfrl9KBAob0dxDA+1Ok9+ZQjVIdDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653074; c=relaxed/simple;
	bh=/+RzSlavR/LqI/KYh2eLpKIZBoIu8XAyT+0KUEyEAvY=;
	h=Date:To:From:Subject:Message-Id; b=ZXEOi75raT3eCA3H3jM49yA8XcExCnI5klfZ75vtg0Tlwx7YCRLHDwzmqhk0loB6ZRmbi2TsvlvcRuSmSPGLReub4+YcwTjbDHzBFUMQDoPYfdt3XyOREmJwU5Bw779BdfCiOArDe9y4JXK/hD++YiKNvgYvJ4rrZGKAVZfZrus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bLkuQEz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bLkuQEz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE9EC4CED0;
	Fri, 15 Nov 2024 06:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653074;
	bh=/+RzSlavR/LqI/KYh2eLpKIZBoIu8XAyT+0KUEyEAvY=;
	h=Date:To:From:Subject:From;
	b=bLkuQEz6CpAFKDmLjIuhM+ythiULn+OwCBDyk0kr3RC2ioeSY/fALhnIvh7AJMQUB
	 57ZdIE950dw/UX1vAWeWbwtO0glHvzMhw54OxeSvhmLaLX2KsJb0ltEafK8tjDO0Lh
	 rochhyz3ID0jW5jLOvjw+8JjhulCDgXg7ykw93q8=
Date: Thu, 14 Nov 2024 22:44:30 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-doc-update-read_ahead_kb-for-madv_hugepage.patch removed from -mm tree
Message-Id: <20241115064433.9BE9EC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, doc: update read_ahead_kb for MADV_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     mm-doc-update-read_ahead_kb-for-madv_hugepage.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, doc: update read_ahead_kb for MADV_HUGEPAGE
Date: Wed, 13 Nov 2024 23:07:11 +0800

MADV_HUGEPAGE is a new addition to readahead with behavior distinct from
normal pages.  To prevent confusion, we should update the documentation
accordingly.

Link: https://lkml.kernel.org/r/20241113150711.1685-1-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/stable/sysfs-block |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/ABI/stable/sysfs-block~mm-doc-update-read_ahead_kb-for-madv_hugepage
+++ a/Documentation/ABI/stable/sysfs-block
@@ -594,6 +594,9 @@ Description:
 		[RW] Maximum number of kilobytes to read-ahead for filesystems
 		on this block device.
 
+		For MADV_HUGEPAGE, the readahead size may exceed this setting
+		since its granularity is based on the hugepage size.
+
 
 What:		/sys/block/<disk>/queue/rotational
 Date:		January 2009
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-readahead-fix-large-folio-support-in-async-readahead.patch

