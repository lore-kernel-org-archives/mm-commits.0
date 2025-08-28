Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421312773D6
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 05:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359984; cv=none; b=TUqcsYwdLLkBdf0zc81cFMa2nSlDyPiD7tQa9PlVkrJV4mlxEn5ylGFp9z+zhJqkBLY3v9PhGlEXwpclBc+oW04V/1fXe9pz9/9QSIiatetjnyxPNYl9ysjETLP4w8yQDvIhob+9ISk26BpNTKEaZlX6Snu3vUbSS8qHlOvFDFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359984; c=relaxed/simple;
	bh=7GleN6lk/CDNvqcc1annbriXDLplgtNyEFaOddwppr0=;
	h=Date:To:From:Subject:Message-Id; b=QD8PLH6sbkK2WwO9xBW3QeKbh4sciK3metDMO+4NEUVXvtRBuAmG9a8A1nTBSJrOZoNGdYJYg5F/zB/+TuCdUXvNIB7xH74b75Ky+SBA51yfTkqJqtQ7SCiX41WeGCDfrh6L7VKuQMMtqbwNWtumh6helmo0U/ap7vP5s2UeCjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=szBUEWyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="szBUEWyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0055C4CEEB;
	Thu, 28 Aug 2025 05:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359983;
	bh=7GleN6lk/CDNvqcc1annbriXDLplgtNyEFaOddwppr0=;
	h=Date:To:From:Subject:From;
	b=szBUEWyoOw7xEwU/W/9ADYUfQh0lVR8YCoq4q4Xffui7xla2qY8eRoQf/aiWAJ89v
	 aE2//ejMgQ9IqfH+Nji2VFn1uoIulLzMBCPpAwDP1Hx/Gumz6NxfnspJFxB9H1s14L
	 TjNnwKx+AuBfTOmgNAI/UB6gBMU+TwPZm9Vd69XM=
Date: Wed, 27 Aug 2025 22:46:23 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,saravanak@google.com,robh@kernel.org,mingo@redhat.com,hpa@zytor.com,graf@amazon.com,dyoung@redhat.com,bp@alien8.de,bhe@redhat.com,makb@juniper.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kexec-add-kexec_file_no_cma-as-a-legal-flag.patch removed from -mm tree
Message-Id: <20250828054623.A0055C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: add KEXEC_FILE_NO_CMA as a legal flag
has been removed from the -mm tree.  Its filename was
     kexec-add-kexec_file_no_cma-as-a-legal-flag.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brian Mak <makb@juniper.net>
Subject: kexec: add KEXEC_FILE_NO_CMA as a legal flag
Date: Tue, 5 Aug 2025 14:15:26 -0700

Commit 07d24902977e ("kexec: enable CMA based contiguous allocation")
introduces logic to use CMA-based allocation in kexec by default.  As part
of the changes, it introduces a kexec_file_load flag to disable the use of
CMA allocations from userspace.  However, this flag is broken since it is
missing from the list of legal flags for kexec_file_load.  kexec_file_load
returns EINVAL when attempting to use the flag.

Fix this by adding the KEXEC_FILE_NO_CMA flag to the list of legal flags
for kexec_file_load.

Without this fix, kexec_file_load syscall will failed and return
'-EINVAL' when KEXEC_FILE_NO_CMA is specified.

Link: https://lkml.kernel.org/r/20250805211527.122367-2-makb@juniper.net
Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Brian Mak <makb@juniper.net>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/kexec.h~kexec-add-kexec_file_no_cma-as-a-legal-flag
+++ a/include/linux/kexec.h
@@ -460,7 +460,8 @@ bool kexec_load_permitted(int kexec_imag
 
 /* List of defined/legal kexec file flags */
 #define KEXEC_FILE_FLAGS	(KEXEC_FILE_UNLOAD | KEXEC_FILE_ON_CRASH | \
-				 KEXEC_FILE_NO_INITRAMFS | KEXEC_FILE_DEBUG)
+				 KEXEC_FILE_NO_INITRAMFS | KEXEC_FILE_DEBUG | \
+				 KEXEC_FILE_NO_CMA)
 
 /* flag to track if kexec reboot is in progress */
 extern bool kexec_in_progress;
_

Patches currently in -mm which might be from makb@juniper.net are

x86-kexec-carry-forward-the-boot-dtb-on-kexec.patch

