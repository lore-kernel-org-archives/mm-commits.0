Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1A880C14
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104468; cv=none; b=e/02HwVe6cDp/Wale+XKj3USZJyZJYBPurQmuDEAORKUX4ct5ga9J6BVPmKRKehTIGT+xn/jilSa0P6gKQunep/bMF6baTwgcFT1Uu22TvDrN7SJ6g584lyUcDiSFpYgtxyUXL5vkCk7aPjpqmzwOosW7XoUneJVaH7Y09r+1eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104468; c=relaxed/simple;
	bh=PVdmgWlw6V+NKGivqn7tkWq0VmcDyCfUfTgFUcrodPM=;
	h=Date:To:From:Subject:Message-Id; b=pM0ypGyGkoER8owBVXpG9OMF00dKaxDYef5HlHYIMEz/Ko/qBZnwtzkMpY0HvsQf8VUUS7qmiwXfhTRQhZGv0euI1ufwNX6uK7PDyyR1WkCsxBnPK2mnUmoVEYQ+lBfQ1eUW/b3+3bmjPkxW0HkOnAy8AA6LXAAIqEVeoYsIMe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I0JebCmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I0JebCmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F267C113CD;
	Fri, 26 Apr 2024 04:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104468;
	bh=PVdmgWlw6V+NKGivqn7tkWq0VmcDyCfUfTgFUcrodPM=;
	h=Date:To:From:Subject:From;
	b=I0JebCmY2uvcvPDu99TeGyP2KVgV/7ob7bjrkd7kwtk0RABpIsokeEgn2YNgAPqe8
	 3Uucjrxh5rtA8bXJGn7+K0ladjZKI325jmEAQ+nSQ5qupfwuGLL41fuNrSnln9eN/J
	 HfgWEHnj62ft4zyRH/ow0CaxAZq5Ccp3WW9M/Ko4=
Date: Thu, 25 Apr 2024 21:07:48 -0700
To: mm-commits@vger.kernel.org,kernel@xen0n.name,geert@linux-m68k.org,corbet@lwn.net,chenhuacai@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] documentation-kdump-clean-up-the-outdated-description.patch removed from -mm tree
Message-Id: <20240426040748.7F267C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: kdump: clean up the outdated description
has been removed from the -mm tree.  Its filename was
     documentation-kdump-clean-up-the-outdated-description.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: Documentation: kdump: clean up the outdated description
Date: Fri, 29 Mar 2024 21:28:25 +0800

After commit 443cbaf9e2fd ("crash: split vmcoreinfo exporting code out
from crash_core.c"), Kconfig item CRASH_CORE has gone away in kernel. 
Items VMCORE_INFO and CRASH_RESERVE are used instead.

So clean up the outdated description about CRASH_CORE and update it
accordingly.

Link: https://lkml.kernel.org/r/20240329132825.1102459-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/kdump/kdump.rst~documentation-kdump-clean-up-the-outdated-description
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -136,10 +136,6 @@ System kernel config options
 
 	CONFIG_KEXEC_CORE=y
 
-   Subsequently, CRASH_CORE is selected by KEXEC_CORE::
-
-	CONFIG_CRASH_CORE=y
-
 2) Enable "sysfs file system support" in "Filesystem" -> "Pseudo
    filesystems." This is usually enabled by default::
 
@@ -168,6 +164,10 @@ Dump-capture kernel config options (Arch
 
 	CONFIG_CRASH_DUMP=y
 
+   And this will select VMCORE_INFO and CRASH_RESERVE::
+	CONFIG_VMCORE_INFO=y
+	CONFIG_CRASH_RESERVE=y
+
 2) Enable "/proc/vmcore support" under "Filesystems" -> "Pseudo filesystems"::
 
 	CONFIG_PROC_VMCORE=y
_

Patches currently in -mm which might be from bhe@redhat.com are

kexec-fix-the-unexpected-kexec_dprintk-macro.patch

