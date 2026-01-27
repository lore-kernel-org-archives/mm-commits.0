Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFB4321F42
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769487914; cv=none; b=bdZrp4LEWtiMobSNT8Zs5k9X/Wlg7QkTg+wJ3sqJ63ptJZDzF25yf/evN/1lH3VffUwulMPYAQ4MFNdYOmfLTpBc7x/AjtJsG0yryyoNe8JjNGjNs60m5BRWz3+5mpBJ+14vVFVxeZRjMqEmO26ncymfmRJM7Bw91SwiKA6KyzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769487914; c=relaxed/simple;
	bh=0w+Q7VEJpvuyKq3UUYajGK2RFTaK5j+OHwwfzIytPoE=;
	h=Date:To:From:Subject:Message-Id; b=MPeZlta8FLyU/qGMLZL0ogCCEjvzrVLipBjpsQpmjncxfRN9QIl25ceMG9XB85LCaTf2PNli3q4mcqb64kViQt0S2BIwsGpgtVqFODYPqkph59rM/feGXEVc7mip9Qw1aaMjPwyiYlAarSCo6t9SIVGtSHeDRwNCVZ98dS/B9WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YF0EXvbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YF0EXvbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975D1C116C6;
	Tue, 27 Jan 2026 04:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769487913;
	bh=0w+Q7VEJpvuyKq3UUYajGK2RFTaK5j+OHwwfzIytPoE=;
	h=Date:To:From:Subject:From;
	b=YF0EXvbbPeNvQN73cKguqQUnTIMV+eERaR8mvop23oCwsu5G0CYl+UT0vdYol+rxz
	 Fnt5XmBGz/CPN0aAJq6EbWFEV+rjCqkrGuSMY7NGB/lG/3BzwX96WM/MOoky/sArSV
	 Q9bRHFe1asOu8O6sGJu+RsFtOcl4mAUl05S8tFwA=
Date: Mon, 26 Jan 2026 20:25:13 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,catalin.marinas@arm.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] kexec-print-out-debugging-message-if-required-for-kexec_load.patch removed from -mm tree
Message-Id: <20260127042513.975D1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: print out debugging message if required for kexec_load
has been removed from the -mm tree.  Its filename was
     kexec-print-out-debugging-message-if-required-for-kexec_load.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Qiang Ma <maqianga@uniontech.com>
Subject: kexec: print out debugging message if required for kexec_load
Date: Fri, 19 Dec 2025 17:31:33 +0800

The commit a85ee18c7900 ("kexec_file: print out debugging message if
required") has added general code printing in kexec_file_load(), but not
in kexec_load().

As a result, when using '-d' for the kexec_load interface, print nothing
in the kernel space.

Since the segments debugging message has already been printed by the
user-space tool kexec-tools, it will not be printed here in the kernel
space.

And print out type/start/head of kimage and flags to help debug.

Link: https://lkml.kernel.org/r/20251219093134.2268620-4-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kexec.c~kexec-print-out-debugging-message-if-required-for-kexec_load
+++ a/kernel/kexec.c
@@ -166,6 +166,9 @@ static int do_kexec_load(unsigned long e
 	if (ret)
 		goto out;
 
+	kexec_dprintk("kexec_load: type:%u, start:0x%lx head:0x%lx flags:0x%lx\n",
+		      image->type, image->start, image->head, flags);
+
 	/* Install the new kernel and uninstall the old */
 	image = xchg(dest_image, image);
 
_

Patches currently in -mm which might be from maqianga@uniontech.com are

arm64-kexec-adjust-the-debug-print-of-kexec_image_info.patch

