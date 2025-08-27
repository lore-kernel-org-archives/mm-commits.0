Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D6C3595C;
	Wed, 27 Aug 2025 01:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756256746; cv=none; b=D/xk1xDIJsRhSRlhSviezt/mKd2MXI9BLhKxKHIqnZtpr7M+YyELez6X1uH8mtZCPDsFRLPpSL4eV+SDY3zNZtHTJnucelcm9JYcGr1z/uM3j47bWVnvzGwqwePHuIIGkAJoa819bd38p/rba6b3IfRRuHBl8phG7sfChEC6CYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756256746; c=relaxed/simple;
	bh=QNFKRmGsbQeMiAENvcLukYQ+2NJurOLg0bFNqs8VQ0I=;
	h=Date:To:From:Subject:Message-Id; b=GLiWX4dGE8cwETbQJBSjDwIEIptfsHT1e6sxRCDcpqL8aPAv7kJI3X7H2OqtpYtWnUh88CUEg4mZcVkE2yXSMvSUL239VlaSx9/Qhjd2kNR9FBMhiRa8Fs7tcs5FJzDnKYha+9BmHZwUvSVhzsCmEtr1131zZLaGEGS/vFd3k5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SHMJkCgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SHMJkCgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2D9C4CEF1;
	Wed, 27 Aug 2025 01:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756256746;
	bh=QNFKRmGsbQeMiAENvcLukYQ+2NJurOLg0bFNqs8VQ0I=;
	h=Date:To:From:Subject:From;
	b=SHMJkCgMjUSnpRxqB0Kn7Wok3LvVYa1rmaU0w46Zo54fTIZ1g+zCp57jzObXSpZ6k
	 6zNOJHnNlp2r5tAzGi/Pqt3i/OsDukK+ZUa7WmActm5vcpjxdxqwdMnSImMb06Ub0I
	 l7/pnMNQL25IhvNGNCjfpa/ErlpvJe9rEVgW1Amg=
Date: Tue, 26 Aug 2025 18:05:45 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,stable@vger.kernel.org,ryncsn@gmail.com,okozina@redhat.com,mark.rutland@arm.com,kernelfans@gmail.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,coxu@redhat.com,bhe@redhat.com,berrange@redhat.com,akpm@linux-foundation.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-kexec-initialize-kexec_buf-struct-in-image_load.patch added to mm-hotfixes-unstable branch
Message-Id: <20250827010546.2E2D9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: kexec: Initialize kexec_buf struct in image_load()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arm64-kexec-initialize-kexec_buf-struct-in-image_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-kexec-initialize-kexec_buf-struct-in-image_load.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: arm64: kexec: Initialize kexec_buf struct in image_load()
Date: Tue, 26 Aug 2025 05:08:51 -0700

The kexec_buf structure was previously declared without initialization in
image_load().  This led to a UBSAN warning when the structure was expanded
and uninitialized fields were accessed [1].

Zero-initializing kexec_buf at declaration ensures all fields are cleanly
set, preventing future instances of uninitialized memory being used.

Fixes this UBSAN warning:

  [   32.362488] UBSAN: invalid-load in ./include/linux/kexec.h:210:10
  [   32.362649] load of value 252 is not a valid value for type '_Bool'

Andrew Morton suggested that this function is only called 3x a week[2],
thus, the memset() cost is inexpensive.

Link: https://lore.kernel.org/all/oninomspajhxp4omtdapxnckxydbk2nzmrix7rggmpukpnzadw@c67o7njgdgm3/ [1]
Link: https://lore.kernel.org/all/20250825180531.94bfb86a26a43127c0a1296f@linux-foundation.org/ [2]
Link: https://lkml.kernel.org/r/20250826-akpm-v1-1-3c831f0e3799@debian.org
Fixes: bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/kexec_image.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/kexec_image.c~arm64-kexec-initialize-kexec_buf-struct-in-image_load
+++ a/arch/arm64/kernel/kexec_image.c
@@ -41,7 +41,7 @@ static void *image_load(struct kimage *i
 	struct arm64_image_header *h;
 	u64 flags, value;
 	bool be_image, be_kernel;
-	struct kexec_buf kbuf;
+	struct kexec_buf kbuf = {};
 	unsigned long text_offset, kernel_segment_number;
 	struct kexec_segment *kernel_segment;
 	int ret;
_

Patches currently in -mm which might be from leitao@debian.org are

arm64-kexec-initialize-kexec_buf-struct-in-image_load.patch

