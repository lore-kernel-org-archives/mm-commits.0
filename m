Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F95C1F5F6
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619846; cv=none; b=P67j0Gu8tWQXNmge7M26keYU6FWnc6EwasPdwgxIyZs9CppAmYFMgOtjBrAQIgrYjusyz39AxYHyhgSeEem8+/zJrGvShlQBRFj+ngMT/tYLRbn0Pgc5a0B1/AMEoLhzCm2S++w6pw7Ol8BZ49QYp3NJVHyJU9kibVfxI5N4ArA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619846; c=relaxed/simple;
	bh=BpL+YOX0XSV1mYVf7tJASf5zPsDC5sSfTRTzEvxKlT0=;
	h=Date:To:From:Subject:Message-Id; b=CWuurWIEqq0pBZdnstQy6FzEAqLh65RmTfoty7TJJrU+xjOmQfSgILiCUNwp3vjyy/dyzGfQK7tg4gf8gyYUDsuB2nu2fFllRFPz0ZBh1gjpVSp+JIytH/QQggCGeLXMYehq89NIUYVYNE5k3kxgEs+qU7YEGHAQy3nX3DAdGrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x96LreUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x96LreUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACFCC4CEDD;
	Sat, 22 Mar 2025 05:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619846;
	bh=BpL+YOX0XSV1mYVf7tJASf5zPsDC5sSfTRTzEvxKlT0=;
	h=Date:To:From:Subject:From;
	b=x96LreUWxQcJU6yceWGVqf7vyilBI2ftbk1/VM77mCE0t3XJfeLynQg10NekvFW2l
	 0N25PP4iyEk/ParDidwwMZwnX7VqFYM8kHq6ZiU1st+WVXxc55QS21uJgg0nn1Qk69
	 o65eWOdIXgZbWSPgaRCNoUIGm8ZpLJc+DHJ9bo10=
Date: Fri, 21 Mar 2025 22:04:05 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,surenb@google.com,pasha.tatashin@soleen.com,kirill.shutemov@linux.intel.com,jeffxu@chromium.org,david@redhat.com,corbet@lwn.net,catalin.marinas@arm.com,andrii@kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-add-unaccepted-meminfo-entry.patch removed from -mm tree
Message-Id: <20250322050406.0ACFCC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MM documentation: add "Unaccepted" meminfo entry
has been removed from the -mm tree.  Its filename was
     documentation-add-unaccepted-meminfo-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: MM documentation: add "Unaccepted" meminfo entry
Date: Mon, 17 Mar 2025 17:04:03 -0600

Commit dcdfdd40fa82 ("mm: Add support for unaccepted memory") added a
entry to meminfo but did not document it in the proc.rst file.

This counter tracks the amount of "Unaccepted" guest memory for some
Virtual Machine platforms, such as Intel TDX or AMD SEV-SNP.

Add the missing entry in the documentation.

Link: https://lkml.kernel.org/r/20250317230403.79632-1-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/filesystems/proc.rst~documentation-add-unaccepted-meminfo-entry
+++ a/Documentation/filesystems/proc.rst
@@ -1081,6 +1081,7 @@ Example output. You may not have all of
     FilePmdMapped:         0 kB
     CmaTotal:              0 kB
     CmaFree:               0 kB
+    Unaccepted:            0 kB
     Balloon:               0 kB
     HugePages_Total:       0
     HugePages_Free:        0
@@ -1256,6 +1257,8 @@ CmaTotal
               Memory reserved for the Contiguous Memory Allocator (CMA)
 CmaFree
               Free remaining memory in the CMA reserves
+Unaccepted
+              Memory that has not been accepted by the guest
 Balloon
               Memory returned to Host by VM Balloon Drivers
 HugePages_Total, HugePages_Free, HugePages_Rsvd, HugePages_Surp, Hugepagesize, Hugetlb
_

Patches currently in -mm which might be from npache@redhat.com are


