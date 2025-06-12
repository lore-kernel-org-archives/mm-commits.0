Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E9515C158
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 05:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706982; cv=none; b=otqb+VJSBHSpnTaD1WPIk/Qap+O9IO53xZb2oMeoQwg4yBt3uTAyZu60rrHZv4XryS3jUrw0trszYaBs/jnaLTp32csBESbZ8OeNAVIr11a3NtoaEC5fhIE018G6FDRURoVyedJBKbGYUuwI0DZYoIv+GezZfLQpIpWrhjqCHvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706982; c=relaxed/simple;
	bh=LkvUyMMLMXNXWrb7tzfPrsXRzV6HinpcNds2vov1Nw4=;
	h=Date:To:From:Subject:Message-Id; b=EH/y69E+J0JIgEhQeo7Wc6KmL811DNYlkYmfL5G7NWJYhFCUO4gDhO9JQ0ft5CAeJCj2BJ+CIwFxEJLpp0JPh0y4E4WHnFQUREa2lLvZs1s12dw+WJFb4G7K6jthX2AcAh0DbIiPxu9fEIgA4/++J4rO+q4BKhBogZ4WfyJ955E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=142xDEn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="142xDEn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F529C4CEEA;
	Thu, 12 Jun 2025 05:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749706982;
	bh=LkvUyMMLMXNXWrb7tzfPrsXRzV6HinpcNds2vov1Nw4=;
	h=Date:To:From:Subject:From;
	b=142xDEn8uAFEcNRdiU2XH2iySBrigOyMfz3JV1c3QugfHx09TTpJl59JpEqy6hXrE
	 o7soe4H7CGm/TrJ8Qjr2dspApqNkxl/NJtJYBsvcRkxibxBkrlqZMRA8U6hs91FlS6
	 zilQkAEXbssAxUpyg9N99aJgyxxCEXRoak72/25k=
Date: Wed, 11 Jun 2025 22:43:01 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,tz2294@columbia.edu,npache@redhat.com,david@redhat.com,corbet@lwn.net,catalin.marinas@arm.com,andrii@kernel.org,wangfushuai@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-proc-update-vmflags-documentation-in-smaps.patch removed from -mm tree
Message-Id: <20250612054302.1F529C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: proc: update VmFlags documentation in smaps
has been removed from the -mm tree.  Its filename was
     docs-proc-update-vmflags-documentation-in-smaps.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wangfushuai <wangfushuai@baidu.com>
Subject: docs: proc: update VmFlags documentation in smaps
Date: Sat, 7 Jun 2025 23:36:14 +0800

Remove outdated VM_DENYWRITE("dw") reference and add missing
VM_LOCKONFAULT("lf") and VM_UFFD_MINOR("ui") flags.

[akpm@linux-foundation.org: add "dp" (VM_DROPPABLE), per Tal]
Link: https://lkml.kernel.org/r/20250607153614.81914-1-wangfushuai@baidu.com
Signed-off-by: wangfushuai <wangfushuai@baidu.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mariano Pache <npache@redhat.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~docs-proc-update-vmflags-documentation-in-smaps
+++ a/Documentation/filesystems/proc.rst
@@ -584,7 +584,6 @@ encoded manner. The codes are the follow
     ms    may share
     gd    stack segment growns down
     pf    pure PFN range
-    dw    disabled write to the mapped file
     lo    pages are locked in memory
     io    memory mapped I/O area
     sr    sequential read advise provided
@@ -607,8 +606,11 @@ encoded manner. The codes are the follow
     mt    arm64 MTE allocation tags are enabled
     um    userfaultfd missing tracking
     uw    userfaultfd wr-protect tracking
+    ui    userfaultfd minor fault
     ss    shadow/guarded control stack page
     sl    sealed
+    lf    lock on fault pages
+    dp    always lazily freeable mapping
     ==    =======================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
_

Patches currently in -mm which might be from wangfushuai@baidu.com are


