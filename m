Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CCA4C83;
	Thu,  4 Sep 2025 00:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944437; cv=none; b=H0KheQtU5SJm5oGJPoBT0BUubFgbtvzDtI8A2KOhb3KaS1o/l29Kl2SyLk09NFbZuKbC4NP1mk1LTbJ9fJlZgKsoZuirX/gDVtZNYyuoCZPVUpB5FGFdVLsOnxZhMleokjQtVERu4iuesA4AeDAEM0XfeYC5koSIZEmLZbGFh10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944437; c=relaxed/simple;
	bh=Ed6aDAdki6JS7qVRPmB0pcRQmO0mvXm2jw0QNIAp7KE=;
	h=Date:To:From:Subject:Message-Id; b=uDkRt+9iM9vSjX+/srAdTIyvP94GMOjTdK4u7hr1ZWqfd/RlzanoJUITxfCGegcmRh3E8KQJbJvVjvIcIzjaSP6S3id3ZYr3EisMiwm7CtVaiTRAtQFwh4IMqVyUXRpFZHxZTsC9FPr0Hx6ReYiynCxb3JfnhA6NvDX9NAb9+rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LsznzHMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LsznzHMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1680DC4CEE7;
	Thu,  4 Sep 2025 00:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944437;
	bh=Ed6aDAdki6JS7qVRPmB0pcRQmO0mvXm2jw0QNIAp7KE=;
	h=Date:To:From:Subject:From;
	b=LsznzHMzSJWsxf6C4DNDgfTKSimKSePUnN/FA7DSbSJamDo4OIg4E0bQPdd7j8yha
	 fGMSNf+zPug3/ou8kEIUVFdoC0F0c79qWOSvoLN54+w2Wa1ncJyNVrQ3UHXUpCCAzC
	 LKEcIFjUd1+K8HuIRc5NCLaJdOJtjbCEBMqIvRjo=
Date: Wed, 03 Sep 2025 17:07:16 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,stable@vger.kernel.org,ryncsn@gmail.com,okozina@redhat.com,mark.rutland@arm.com,kernelfans@gmail.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,coxu@redhat.com,bhe@redhat.com,berrange@redhat.com,akpm@linux-foundation.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] arm64-kexec-initialize-kexec_buf-struct-in-image_load.patch removed from -mm tree
Message-Id: <20250904000717.1680DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: kexec: initialize kexec_buf struct in image_load()
has been removed from the -mm tree.  Its filename was
     arm64-kexec-initialize-kexec_buf-struct-in-image_load.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: arm64: kexec: initialize kexec_buf struct in image_load()
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

arm64-kexec-initialize-kexec_buf-struct-in-load_other_segments.patch
riscv-kexec-initialize-kexec_buf-struct.patch
s390-kexec-initialize-kexec_buf-struct.patch

