Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9E3214A94
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 04:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315637; cv=none; b=ZuqDT4AOhlgG70lzvZDYpF7jm9BpYOvBubS4pMbBH8mFh608Zr6upkuBFWqg+56IR0gV2g9jUkHUrRtbq8Wm+TC44jzvIu9VfmSffJuMt08IhVkXdw1BrXQ9kK4IFFyO/zmhoHNoIHCf1ek/W+ttFsfil4U8Ft6ztxspEJ0cCHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315637; c=relaxed/simple;
	bh=DH5mIYqG4HNVJWlx5CcTG2Tk8+yTc87UoGD8kOzoTrY=;
	h=Date:To:From:Subject:Message-Id; b=WDbQLGMSEUudiloGma4dFACLk7gikWY1j5yJyouiht/Pp5gnTzw9Hit/enFt2tWGNmyASfph8i14KcstIxtZyLlvpn0DOQNVrPt3ct3rYjeK79Ierwobvd9fp5wZ5KPvLSeSxLnMgSFecMr3VG9Fxu7KJNsLy11xyRrZZM+wUFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bJ5cUJh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bJ5cUJh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4ABC4CEFB;
	Wed,  5 Nov 2025 04:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762315635;
	bh=DH5mIYqG4HNVJWlx5CcTG2Tk8+yTc87UoGD8kOzoTrY=;
	h=Date:To:From:Subject:From;
	b=bJ5cUJh4gi2Ue/+qsE4j9kF6MzZP4yKPCrEskarLttqPQcjYPfl6bheDP6N+7E1jw
	 qjg77mRXMytnb8YrjJ31zWrBwk8cPaNOWtDcsK7pRx1dFR8QoFzwrhpD2k2JLEokPS
	 p3BTWYm+j3DQUKerbLM+p9h5QAJOOyNi1iVUdxeI=
Date: Tue, 04 Nov 2025 20:07:14 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,lkp@intel.com,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kexec-print-out-debugging-message-if-required-for-kexec_load.patch removed from -mm tree
Message-Id: <20251105040715.5A4ABC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: print out debugging message if required for kexec_load
has been removed from the -mm tree.  Its filename was
     kexec-print-out-debugging-message-if-required-for-kexec_load.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Qiang Ma <maqianga@uniontech.com>
Subject: kexec: print out debugging message if required for kexec_load
Date: Mon, 3 Nov 2025 14:34:39 +0800

The commit a85ee18c7900 ("kexec_file: print out debugging message if
required") has added general code printing in kexec_file_load(), but not
in kexec_load().

Especially in the RISC-V architecture, kexec_image_info() has been
removed(commit eb7622d908a0 ("kexec_file, riscv: print out debugging
message if required")).  As a result, when using '-d' for the kexec_load
interface, print nothing in the kernel space.  This might be helpful for
verifying the accuracy of the data passed to the kernel.  Therefore, refer
to this commit a85ee18c7900 ("kexec_file: print out debugging message if
required"), debug print information has been added.

Link: https://lkml.kernel.org/r/20251103063440.1681657-4-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510310332.6XrLe70K-lkp@intel.com/
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/kexec.c~kexec-print-out-debugging-message-if-required-for-kexec_load
+++ a/kernel/kexec.c
@@ -154,7 +154,15 @@ static int do_kexec_load(unsigned long e
 	if (ret)
 		goto out;
 
+	kexec_dprintk("nr_segments = %lu\n", nr_segments);
 	for (i = 0; i < nr_segments; i++) {
+		struct kexec_segment *ksegment;
+
+		ksegment = &image->segment[i];
+		kexec_dprintk("segment[%lu]: buf=0x%p bufsz=0x%zx mem=0x%lx memsz=0x%zx\n",
+			      i, ksegment->buf, ksegment->bufsz, ksegment->mem,
+			      ksegment->memsz);
+
 		ret = kimage_load_segment(image, i);
 		if (ret)
 			goto out;
@@ -166,6 +174,9 @@ static int do_kexec_load(unsigned long e
 	if (ret)
 		goto out;
 
+	kexec_dprintk("kexec_load: type:%u, start:0x%lx head:0x%lx flags:0x%lx\n",
+		      image->type, image->start, image->head, flags);
+
 	/* Install the new kernel and uninstall the old */
 	image = xchg(dest_image, image);
 
_

Patches currently in -mm which might be from maqianga@uniontech.com are

kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch

